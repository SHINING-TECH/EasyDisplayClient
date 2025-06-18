//
//  FCImage.swift
//
//  Created by Mgenware(Liu YuanYuan) on 2023/9/30.
//  https://github.com/flutter-cavalry/fc_native_image_resize/blob/main/darwin/Classes/FCImage.swift
//

import AVFoundation
import Foundation

#if os(iOS)
  import UIKit
  typealias PlatformImage = UIImage
#elseif os(macOS)
  import AppKit
  typealias PlatformImage = NSImage
#endif

enum FCImageOutputFormat {
  case jpeg
  case png
}

class FCImage {
  private let image: PlatformImage

  var rawImage: PlatformImage {
    return image
  }

  init(image: PlatformImage) {
    self.image = image
  }

  init?(path: String) {
    #if os(iOS)
      guard let img = UIImage(contentsOfFile: path) else {
        return nil
      }
    #elseif os(macOS)
      guard let img = NSImage(contentsOfFile: path) else {
        return nil
      }
    #endif
    image = img
  }

  init?(url: URL) {
    #if os(iOS)
      guard let img = UIImage(contentsOfFile: url.path) else {
        return nil
      }
    #elseif os(macOS)
      guard let img = NSImage(contentsOf: url) else {
        return nil
      }
    #endif
    image = img
  }

  init(cgImage: CGImage) {
    #if os(iOS)
      let img = UIImage(cgImage: cgImage)
    #elseif os(macOS)
      let img = NSImage(cgImage: cgImage, size: .zero)
    #endif
    image = img
  }

  func size() -> CGSize {
    #if os(iOS)
      // Don't use `cgImage` to get size, it doesn't take orientation into account.
      return CGSize(width: image.size.width * image.scale, height: image.size.height * image.scale)
    #elseif os(macOS)
      if let rep = image.representations.first {
        let size = CGSize(width: rep.pixelsWide, height: rep.pixelsHigh)
        return size
      }
      return CGSize()
    #endif
  }

  func getCGImage() -> CGImage? {
    #if os(iOS)
      return image.cgImage
    #elseif os(macOS)
      return image.cgImage(forProposedRect: nil, context: nil, hints: nil)
    #endif
  }

  func resized(to: CGSize, keepAspectRatio: Bool) -> FCImage? {
    if to.width <= 0 && to.height <= 0 {
      return nil
    }
    var targetSize = to
    if to.width <= 0 {
      targetSize.width = self.size().width * to.height / self.size().height
    }
    if to.height <= 0 {
      targetSize.height = self.size().height * to.width / self.size().width
    }
    #if os(iOS)
      return FCImage(image: image.resized(to: targetSize, keepAspectRatio: keepAspectRatio))
    #elseif os(macOS)
      return FCImage(image: image.resized(to: targetSize, keepAspectRatio: keepAspectRatio))
    #endif
  }

  func saveToJPEGFile(dest: URL, quality: Int?) throws {
    #if os(iOS)
      let data = image.jpegData(compressionQuality: Double(quality ?? 90) / 100.0)
    #elseif os(macOS)
      let data = image.nsImageToData(type: .jpeg, quality: quality)
    #endif
    try data?.write(to: dest)
  }

  func saveToPNGFile(dest: URL) throws {
    #if os(iOS)
      let data = image.pngData()
    #elseif os(macOS)
      let data = image.nsImageToData(type: .png, quality: nil)
    #endif
    try data?.write(to: dest)
  }
}

#if os(iOS)
  extension UIImage {
    func resized(to newSize: CGSize, keepAspectRatio: Bool) -> UIImage {
      var targetSize = newSize
      if keepAspectRatio {
        let availableRect = AVFoundation.AVMakeRect(
          aspectRatio: self.size,
          insideRect: .init(origin: .zero, size: newSize)
        )
        targetSize = availableRect.size

        // Prevent upscaling.
        if targetSize.width > self.size.width && targetSize.height > self.size.height {
          targetSize = self.size
        }
      }

      let format = UIGraphicsImageRendererFormat()
      format.scale = 1
      let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

      // Resize the image
      let resized = renderer.image { _ in
        self.draw(in: CGRect(origin: .zero, size: targetSize))
      }

      return resized
    }
  }

#elseif os(macOS)
  extension NSImage {
    public func resized(to newSize: CGSize, keepAspectRatio: Bool) -> NSImage {
      var targetSize = newSize
      if keepAspectRatio {
        let availableRect = AVFoundation.AVMakeRect(
          aspectRatio: self.size,
          insideRect: .init(origin: .zero, size: newSize)
        )
        targetSize = availableRect.size

        // Prevent upscaling.
        if targetSize.width > self.size.width && targetSize.height > self.size.height {
          targetSize = self.size
        }
      }
      let scale = NSScreen.main?.backingScaleFactor ?? 1.0
      targetSize = CGSize(width: targetSize.width / scale, height: targetSize.height / scale)

      let rawImg = NSImage(size: targetSize)

      rawImg.lockFocus()
      defer {
        rawImg.unlockFocus()
      }

      if let ctx = NSGraphicsContext.current {
        ctx.imageInterpolation = .high
        draw(in: NSRect(origin: .zero, size: targetSize))
      }
      return rawImg
    }

    public func nsImageToData(type: NSBitmapImageRep.FileType, quality: Int?) -> Data? {
      guard let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil)
      else {
        return nil
      }
      let imageRep = NSBitmapImageRep(cgImage: cgImage)

      var opt: [NSBitmapImageRep.PropertyKey: Any] = [:]
      if type == .jpeg {
        opt[NSBitmapImageRep.PropertyKey.compressionFactor] = Double(quality ?? 90) / 100.0
      }
      return imageRep.representation(using: type, properties: opt)
    }
  }
#endif
