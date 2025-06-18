import AVFoundation
#if os(macOS)
import FlutterMacOS
#else
import Flutter
#endif

class AvMediaTexture: NSObject, FlutterTexture {
	private let callback: () -> Unmanaged<CVPixelBuffer>?
	init(_ cb: @escaping () -> Unmanaged<CVPixelBuffer>?) {
		callback = cb
	}
	func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
		return callback()
	}
}

class AvMediaPlayer: NSObject, FlutterStreamHandler {
	var id: Int64!
	var subId: Int64!
	private let textureRegistry: FlutterTextureRegistry
	private let avPlayer = AVPlayer()
	private let subtitleLayer = AVPlayerLayer()
	private var videoTexture: AvMediaTexture!
	private var subtitleTexture: AvMediaTexture!
	private var eventChannel: FlutterEventChannel!
	private var videoOutput: AVPlayerItemVideoOutput?
	private var eventSink: FlutterEventSink?
	private var watcher: Any?
	private var position = CMTime.zero
	private var bufferPosition = CMTime.zero
	private var speed: Float = 1
	private var volume: Float = 1
	private var looping = false
	private var reading: CMTime?
	private var rendering: CMTime?
	private var state: UInt8 = 0 //0: idle, 1: opening, 2: ready, 3: playing
	private var source: String?
	private var mediaGroups: [AVMediaSelectionGroup] = []
	private var maxWidth = 0.0
	private var maxHeight = 0.0
	private var maxBitrate = 0.0
	private var showSubtitle = false

	init(registrar: FlutterPluginRegistrar) {
#if os(macOS)
		textureRegistry = registrar.textures
		let messager = registrar.messenger
#else
		textureRegistry = registrar.textures()
		let messager = registrar.messenger()
#endif
		super.init()
		videoTexture = AvMediaTexture({ [weak self] in
			if self != nil,
				 let t = self!.reading {
				self!.reading = nil
				if let pixelBuffer = self!.videoOutput?.copyPixelBuffer(forItemTime: t, itemTimeForDisplay: nil) {
					self!.rendering = t
					return Unmanaged.passRetained(pixelBuffer)
				}
			}
			return nil
		})
		subtitleTexture = AvMediaTexture({ [weak self] in
			if self != nil && self!.showSubtitle,
				let size = self!.avPlayer.currentItem?.presentationSize {
				var subtitleBuffer: CVPixelBuffer?
				if CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width), Int(size.height), kCVPixelFormatType_32BGRA, [
						kCVPixelBufferIOSurfacePropertiesKey: [:],
						kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA
					] as CFDictionary, &subtitleBuffer) == kCVReturnSuccess && CVPixelBufferLockBaseAddress(subtitleBuffer!, .readOnly) == kCVReturnSuccess {
					if let context = CGContext(
						data: CVPixelBufferGetBaseAddress(subtitleBuffer!),
						width: Int(size.width),
						height: Int(size.height),
						bitsPerComponent: 8,
						bytesPerRow: CVPixelBufferGetBytesPerRow(subtitleBuffer!),
						space: CGColorSpaceCreateDeviceRGB(),
						bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue.littleEndian) {
#if !os(macOS)
						context.translateBy(x: 0, y: size.height)
						context.scaleBy(x: 1, y: -1)
#endif
						self!.subtitleLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
						self!.subtitleLayer.render(in: context)
					}
					CVPixelBufferUnlockBaseAddress(subtitleBuffer!, .readOnly)
					return Unmanaged.passRetained(subtitleBuffer!)
				}
			}
			return nil
		})
		id = textureRegistry.register(videoTexture)
		subId = textureRegistry.register(subtitleTexture)
		eventChannel = FlutterEventChannel(name: "av_media_player/\(id!)", binaryMessenger: messager)
		eventChannel.setStreamHandler(self)
		avPlayer.appliesMediaSelectionCriteriaAutomatically = true
		setPreferredAudioLanguage(language: "")
		setPreferredSubtitleLanguage(language: "")
		avPlayer.addObserver(self, forKeyPath: #keyPath(AVPlayer.timeControlStatus), options: .old, context: nil)
		avPlayer.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), context: nil)
		avPlayer.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.loadedTimeRanges), context: nil)
		avPlayer.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.presentationSize), context: nil)
		subtitleLayer.player = avPlayer
	}

	deinit {
		eventSink?(FlutterEndOfEventStream)
		eventChannel.setStreamHandler(nil)
		avPlayer.removeObserver(self, forKeyPath: #keyPath(AVPlayer.timeControlStatus))
		avPlayer.removeObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status))
		avPlayer.removeObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.loadedTimeRanges))
		avPlayer.removeObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.presentationSize))
		textureRegistry.unregisterTexture(id)
		subtitleLayer.player = nil
	}

	func open(source: String) {
		let uri: URL?
		if source.starts(with: "asset://") {
			uri = URL(fileURLWithPath: Bundle.main.bundlePath + "/" + FlutterDartProject.lookupKey(forAsset: String(source.suffix(source.count - 8))))
		} else if source.contains("://") {
			uri = URL(string: source)
		} else {
			uri = URL(fileURLWithPath: source)
		}
		if uri == nil {
			eventSink?([
				"event": "error",
				"value": "Invalid source"
			])
		} else {
			close()
			self.source = source
			state = 1
			avPlayer.replaceCurrentItem(with: AVPlayerItem(asset: AVAsset(url: uri!)))
			//AVPlayer.eligibleForHDRPlayback
			//avPlayer.currentItem!.appliesPerFrameHDRDisplayMetadata = true
			avPlayer.currentItem!.preferredPeakBitRate = maxBitrate
			avPlayer.currentItem!.preferredMaximumResolution = maxWidth == 0 && maxHeight == 0 ? CGSizeZero : CGSize(width: maxWidth, height: maxHeight)
			NotificationCenter.default.addObserver(
				self,
				selector: #selector(onFinish(notification:)),
				name: AVPlayerItem.didPlayToEndTimeNotification,
				object: avPlayer.currentItem
			)
		}
	}

	func close() {
		state = 0
		position = .zero
		bufferPosition = .zero
		avPlayer.pause()
		stopVideo()
		stopWatcher()
		source = nil
		reading = nil
		rendering = nil
		mediaGroups.removeAll()
		if avPlayer.currentItem != nil {
			NotificationCenter.default.removeObserver(
				self,
				name: AVPlayerItem.didPlayToEndTimeNotification,
				object: avPlayer.currentItem
			)
			avPlayer.replaceCurrentItem(with: nil)
		}
	}

	func play() {
		if state == 2 {
			state = 3
			justPlay()
		}
	}

	func pause() {
		if state > 2 {
			state = 2
			avPlayer.pause()
		}
	}

	func seekTo(pos: CMTime) {
		if avPlayer.currentItem == nil || !(avPlayer.currentItem!.duration.seconds > 0) || avPlayer.currentTime() == pos {
			eventSink?(["event": "seekEnd"])
		} else {
			avPlayer.seek(to: pos, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] finished in
				if finished && self != nil {
					self!.eventSink?(["event": "seekEnd"])
					if self!.watcher == nil {
						self!.setPosition(time: self!.avPlayer.currentTime())
					}
				}
			}
		}
	}

	func setVolume(vol: Float) {
		volume = vol
		avPlayer.volume = volume
	}

	func setSpeed(spd: Float) {
		speed = spd
		if avPlayer.rate > 0 {
			avPlayer.rate = speed
		}
	}

	func setLooping(loop: Bool) {
		looping = loop
	}

	func setMaxBitRate(bitrate: Double) {
		maxBitrate = bitrate
		if state > 0 {
			avPlayer.currentItem!.preferredPeakBitRate = maxBitrate
		}
	}

	func setMaxResolution(width: Double, height: Double) {
		maxWidth = width
		maxHeight = height
		if state > 0 {
			avPlayer.currentItem!.preferredMaximumResolution = maxWidth == 0 && maxHeight == 0 ? CGSizeZero : CGSize(width: maxWidth, height: maxHeight)
		}
	}

	func setPreferredAudioLanguage(language: String) {
		avPlayer.setMediaSelectionCriteria(AVPlayerMediaSelectionCriteria(
			preferredLanguages: language.isEmpty ? Locale.preferredLanguages : [language],
			preferredMediaCharacteristics: nil
		), forMediaCharacteristic: AVMediaCharacteristic.audible)
	}

	func setPreferredSubtitleLanguage(language: String) {
		avPlayer.setMediaSelectionCriteria(AVPlayerMediaSelectionCriteria(
			preferredLanguages: language.isEmpty ? Locale.preferredLanguages : [language],
			preferredMediaCharacteristics: nil
		), forMediaCharacteristic: AVMediaCharacteristic.legible)
	}

	func setShowSubtitle(show: Bool) {
		showSubtitle = show
		if showSubtitle && state == 2 {
			textureRegistry.textureFrameAvailable(subId)
		}
	}

	func overrideTrack(groupId: Int, trackId: Int, enabled: Bool) {
		if state > 1 {
			let group = mediaGroups[groupId]
			let option = group.options[trackId]
			if enabled {
				avPlayer.currentItem!.select(option, in: group)
			} else if avPlayer.currentItem!.currentMediaSelection.selectedMediaOption(in: group) == option {
				avPlayer.currentItem!.selectMediaOptionAutomatically(in: group)
			}
		}
	}

	private func justPlay() {
		if position == avPlayer.currentItem!.duration {
			avPlayer.seek(to: .zero) { [weak self] finished in
				if finished && self != nil {
					self!.setPosition(time: .zero)
					self!.justPlay()
				}
			}
		} else {
			if watcher == nil && avPlayer.currentItem != nil && avPlayer.currentItem!.duration.seconds > 0 {
				watcher = avPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.01, preferredTimescale: 1000), queue: nil) { [weak self] time in
					if self != nil {
						if self!.avPlayer.rate == 0 || self!.avPlayer.error != nil {
							self!.stopWatcher()
						}
						self!.setPosition(time: time)
					}
				}
			}
			avPlayer.rate = speed
		}
	}

	private func createOutput() {
		videoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: [
			String(kCVPixelBufferIOSurfacePropertiesKey): [:],
			String(kCVPixelBufferPixelFormatTypeKey): kCVPixelFormatType_32BGRA
		])
		avPlayer.currentItem!.add(videoOutput!)
	}

	private func stopVideo() {
		if displayLink != nil {
#if os(macOS)
			CVDisplayLinkStop(displayLink!)
#else
			displayLink!.invalidate()
#endif
			displayLink = nil
		}
		if videoOutput != nil {
			avPlayer.currentItem?.remove(videoOutput!)
			videoOutput = nil
		}
	}

	private func stopWatcher() {
		if watcher != nil {
			avPlayer.removeTimeObserver(watcher!)
			watcher = nil
		}
	}

	private func setPosition(time: CMTime) {
		if time != position {
			position = time
			eventSink?([
				"event": "position",
				"value": Int(position.seconds * 1000)
			])
		}
	}

	@objc private func onFinish(notification: NSNotification) {
		if state > 2 {
			if avPlayer.currentItem == nil || avPlayer.currentItem!.duration == .zero {
				if avPlayer.currentItem != nil {
					close()
				}
			} else {
				if watcher != nil {
					stopWatcher()
				}
				setPosition(time: avPlayer.currentItem!.duration)
				if looping {
					justPlay()
				} else {
					state = 2
				}
			}
			eventSink?(["event": "finished"])
		}
	}

	func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
		eventSink = events
		return nil
	}

	func onCancel(withArguments arguments: Any?) -> FlutterError? {
		eventSink = nil
		return nil
	}

#if os(macOS)
	private var displayLink: CVDisplayLink?
	private func displlayCallback(outputTime: CVTimeStamp) {
		if let t = videoOutput?.itemTime(for: outputTime),
			reading != t && rendering != t {
			textureRegistry.textureFrameAvailable(id)
			if showSubtitle {
				textureRegistry.textureFrameAvailable(subId)
			}
			reading = t
		}
	}
#else
	private var displayLink: CADisplayLink?
	@objc private func displayCallback() {
		if let displayLink = displayLink,
			let t = videoOutput?.itemTime(forHostTime: displayLink.targetTimestamp),
			reading != t && rendering != t {
			textureRegistry.textureFrameAvailable(id)
			if showSubtitle {
				textureRegistry.textureFrameAvailable(subId)
			}
			reading = t
		}
	}
#endif

	func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
		if let t = reading {
			reading = nil
			if let pixelBuffer = videoOutput?.copyPixelBuffer(forItemTime: t, itemTimeForDisplay: nil) {
				rendering = t
				return Unmanaged.passRetained(pixelBuffer)
			}
		}
		return nil
	}

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
		switch keyPath {
		case #keyPath(AVPlayer.timeControlStatus):
			if let oldValue = change?[NSKeyValueChangeKey.oldKey] as? Int,
				 let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue),
				 state > 2 && (oldStatus == .waitingToPlayAtSpecifiedRate || avPlayer.timeControlStatus == .waitingToPlayAtSpecifiedRate) {
				eventSink?([
					"event": "loading",
					"value": avPlayer.timeControlStatus == .waitingToPlayAtSpecifiedRate
				])
			}
		case #keyPath(AVPlayer.currentItem.status):
			switch avPlayer.currentItem?.status {
			case .readyToPlay:
				Task { @MainActor in
					if state == 1 && avPlayer.currentItem?.status == .readyToPlay {
						var tracks: [String: [String: String?]] = [:]
						if let characteristics = try? await avPlayer.currentItem!.asset.load(.availableMediaCharacteristicsWithMediaSelectionOptions) {
							for characteristic in characteristics {
								if let group = try? await avPlayer.currentItem!.asset.loadMediaSelectionGroup(for: characteristic) {
									let i = mediaGroups.count
									mediaGroups.append(group)
									for j in 0..<group.options.count {
										if group.options[j].isPlayable {
											let type = if group.options[j].mediaType == .audio {
												"audio"
											} else if (group.options[j].mediaType == .video) {
												"video"
											} else if (group.options[j].mediaType == .subtitle || group.options[j].mediaType == .closedCaption) {
												"sub"
											} else {
												""
											}
											if type != "" {
												let key = "\(i).\(j)"
												tracks[key] = [
													"type": type,
													"title": group.options[j].displayName,
													"language": group.options[j].locale?.identifier ?? group.options[j].extendedLanguageTag
												]
											}
										}
									}
								}
							}
						}
						avPlayer.volume = volume
						state = 2
						eventSink?([
							"event": "mediaInfo",
							"duration": avPlayer.currentItem!.duration.seconds > 0 ? Int(avPlayer.currentItem!.duration.seconds * 1000) : 0,
							"tracks": tracks,
							"source": source!
						])
					}
				}
			case .failed:
				if state > 0 {
					eventSink?([
						"event": "error",
						"value": avPlayer.currentItem?.error?.localizedDescription ?? "Unknown error"
					])
					close()
				}
			default:
				break
			}
		case #keyPath(AVPlayer.currentItem.presentationSize):
			if let width = avPlayer.currentItem?.presentationSize.width,
				 let height = avPlayer.currentItem?.presentationSize.height,
				 state > 0 {
				if width == 0 || height == 0 {
					stopVideo()
				} else {
					if displayLink == nil {
#if os(macOS)
						CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
						if displayLink != nil {
							CVDisplayLinkSetOutputCallback(displayLink!, { (displayLink, now, outputTime, flagsIn, flagsOut, context) -> CVReturn in
								let player: AvMediaPlayer = Unmanaged.fromOpaque(context!).takeUnretainedValue()
								player.displlayCallback(outputTime: outputTime.pointee)
								return kCVReturnSuccess
							}, Unmanaged.passUnretained(self).toOpaque())
							CVDisplayLinkStart(displayLink!)
							createOutput()
						}
#else
						displayLink = CADisplayLink(target: self, selector: #selector(displayCallback))
						displayLink!.add(to: .current, forMode: .common)
						createOutput()
#endif
					}
				}
				eventSink?([
					"event": "videoSize",
					"width": width,
					"height": height
				])
			}
		case #keyPath(AVPlayer.currentItem.loadedTimeRanges):
			if let duration = avPlayer.currentItem?.duration.seconds,
				 let currentTime = avPlayer.currentItem?.currentTime(),
				 let timeRanges = avPlayer.currentItem?.loadedTimeRanges as? [CMTimeRange],
				 state > 1 && duration > 0 {
				for timeRange in timeRanges {
					let end = timeRange.start + timeRange.duration
					if timeRange.start <= currentTime && end >= currentTime {
						if end != bufferPosition {
							bufferPosition = end
							eventSink?([
								"event": "buffer",
								"begin": Int(currentTime.seconds * 1000),
								"end": Int(bufferPosition.seconds * 1000)
							])
						}
						break
					}
				}
			}
		default:
			break
		}
	}
}

public class AvMediaPlayerPlugin: NSObject, FlutterPlugin {
	public static func register(with registrar: FlutterPluginRegistrar) {
#if os(macOS)
		let messager = registrar.messenger
#else
		let messager = registrar.messenger()
#endif
		registrar.addMethodCallDelegate(
			AvMediaPlayerPlugin(registrar: registrar),
			channel: FlutterMethodChannel(name: "av_media_player", binaryMessenger: messager)
		)
	}

	private var players: [Int64: AvMediaPlayer] = [:]
	private let registrar: FlutterPluginRegistrar

	init(registrar: FlutterPluginRegistrar) {
		self.registrar = registrar
		super.init()
	}

	public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
		for player in players.values {
			player.close()
		}
		players.removeAll()
	}

	public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
		var response: Any?
		switch call.method {
		case "create":
			let player = AvMediaPlayer(registrar: registrar)
			players[player.id] = player
			response = [
				"id": player.id,
				"subId": player.subId
			]
		case "dispose":
			if let id = call.arguments as? Int64 {
				players[id]?.close()
				players.removeValue(forKey: id)
			} else {
				detachFromEngine(for: registrar)
			}
		case "open":
			let args = call.arguments as! [String: Any]
			players[args["id"] as! Int64]?.open(source: args["value"] as! String)
		case "close":
			players[call.arguments as! Int64]?.close()
		case "play":
			players[call.arguments as! Int64]?.play()
		case "pause":
			players[call.arguments as! Int64]?.pause()
		case "seekTo":
			let args = call.arguments as! [String: Any]
			players[args["id"] as! Int64]?.seekTo(pos: CMTime(seconds: args["value"] as! Double / 1000, preferredTimescale: 1000))
		case "setVolume":
			let args = call.arguments as! [String: Any]
			players[args["id"] as! Int64]?.setVolume(vol: Float(args["value"] as! Double))
		case "setSpeed":
			let args = call.arguments as! [String: Any]
			players[args["id"] as! Int64]?.setSpeed(spd: Float(args["value"] as! Double))
		case "setLooping":
			let args = call.arguments as! [String: Any]
			players[args["id"] as! Int64]?.setLooping(loop: args["value"] as! Bool)
		case "setMaxBitRate":
			let args = call.arguments as! [String: Any]
			players[args["id"] as! Int64]?.setMaxBitRate(bitrate: args["value"] as! Double)
		case "setMaxResolution":
			let args = call.arguments as! [String: Any]
			players[args["id"] as! Int64]?.setMaxResolution(width: args["width"] as! Double, height: args["height"] as! Double)
		case "setPreferredAudioLanguage":
			let args = call.arguments as! [String: Any]
			players[args["id"] as! Int64]?.setPreferredAudioLanguage(language: args["value"] as! String)
		case "setPreferredSubtitleLanguage":
			let args = call.arguments as! [String: Any]
			players[args["id"] as! Int64]?.setPreferredSubtitleLanguage(language: args["value"] as! String)
		case "setShowSubtitle":
			let args = call.arguments as! [String: Any]
			players[args["id"] as! Int64]?.setShowSubtitle(show: args["value"] as! Bool)
		case "overrideTrack":
			let args = call.arguments as! [String: Any]
			players[args["id"] as! Int64]?.overrideTrack(groupId: args["groupId"] as! Int, trackId: args["trackId"] as! Int, enabled: args["value"] as! Bool)
		default:
			response = FlutterMethodNotImplemented
		}
		result(response)
	}
}
