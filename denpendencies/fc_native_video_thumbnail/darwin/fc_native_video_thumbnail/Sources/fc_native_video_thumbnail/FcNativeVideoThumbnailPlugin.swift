import AVFoundation
import Foundation

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#endif

public class FcNativeVideoThumbnailPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    #if os(iOS)
      let binaryMessenger = registrar.messenger()
    #elseif os(macOS)
      let binaryMessenger = registrar.messenger
    #endif
    let channel = FlutterMethodChannel(
      name: "fc_native_video_thumbnail", binaryMessenger: binaryMessenger)
    let instance = FcNativeVideoThumbnailPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError(code: "InvalidArgsType", message: "Invalid args type", details: nil))
      return
    }
    switch call.method {
    case "getVideoThumbnail":
      // Arguments are enforced on dart side.
      let srcFile = args["srcFile"] as! String
      let destFile = args["destFile"] as! String
      let width = args["width"] as! Int
      let height = args["height"] as! Int
      let outputString = args["format"] as! String
      let srcUri = args["srcFileUri"] as? Bool ?? false
      let quality = args["quality"] as? Int
      let outputType = outputString == "png" ? FCImageOutputFormat.png : FCImageOutputFormat.jpeg

      guard let srcUrl = srcUri ? URL(string: srcFile) : URL(fileURLWithPath: srcFile) else {
        result(FlutterError(code: "PluginError", message: "Invalid source URL", details: nil))
        return
      }
      let destUrl = URL(fileURLWithPath: destFile)

      if #available(macOS 13.0, iOS 16.0, *) {
        let asset = AVURLAsset(url: srcUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(5), preferredTimescale: 100)
        imageGenerator.generateCGImageAsynchronously(for: time) { cgImage, time, err in
          do {
            if let err = err {
              DispatchQueue.main.async {
                result(
                  FlutterError(code: "PluginError", message: err.localizedDescription, details: nil)
                )
              }
              return
            }
            guard let cgImage = cgImage else {
              DispatchQueue.main.async {
                result(false)
              }
              return
            }
            #if os(iOS)
              let rawImg = UIImage(cgImage: cgImage)
            #elseif os(macOS)
              let rawImg = NSImage(
                cgImage: cgImage, size: CGSize(width: cgImage.width, height: cgImage.height))
            #endif
            var img = FCImage(image: rawImg)
            guard
              let resized = img.resized(
                to: CGSize(width: CGFloat(width), height: CGFloat(height)), keepAspectRatio: true)
            else {
              DispatchQueue.main.async {
                result(
                  FlutterError(code: "PluginError", message: "Invalid resize params", details: nil))
              }
              return
            }
            img = resized

            switch outputType {
            case .jpeg:
              try img.saveToJPEGFile(dest: destUrl, quality: quality)
            case .png:
              try img.saveToPNGFile(dest: destUrl)
            }

            DispatchQueue.main.async {
              result(true)
            }
          } catch {
            DispatchQueue.main.async {
              result(
                FlutterError(code: "PluginError", message: error.localizedDescription, details: nil)
              )
            }
          }
        }
      } else {
        // Legacy sync implementation.
        DispatchQueue.global().async {
          do {
            let asset = AVURLAsset(url: srcUrl)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true

            let cgImage = try imageGenerator.copyCGImage(
              at: .zero,
              actualTime: nil)

            #if os(iOS)
              let rawImg = UIImage(cgImage: cgImage)
            #elseif os(macOS)
              let rawImg = NSImage(
                cgImage: cgImage, size: CGSize(width: cgImage.width, height: cgImage.height))
            #endif
            var img = FCImage(image: rawImg)
            guard
              let resized = img.resized(
                to: CGSize(width: CGFloat(width), height: CGFloat(height)), keepAspectRatio: true)
            else {
              DispatchQueue.main.async {
                result(
                  FlutterError(code: "PluginError", message: "Invalid resize params", details: nil))
              }
              return
            }
            img = resized

            switch outputType {
            case .jpeg:
              try img.saveToJPEGFile(dest: destUrl, quality: quality)
            case .png:
              try img.saveToPNGFile(dest: destUrl)
            }

            DispatchQueue.main.async {
              result(true)
            }
          } catch {
            DispatchQueue.main.async {
              result(
                FlutterError(code: "PluginError", message: error.localizedDescription, details: nil)
              )
            }
          }
        }
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
