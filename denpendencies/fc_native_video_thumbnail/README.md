# fc_native_video_thumbnail

[![pub package](https://img.shields.io/pub/v/fc_native_video_thumbnail.svg)](https://pub.dev/packages/fc_native_video_thumbnail)

A Flutter plugin to create video thumbnails via native APIs.

|      | iOS | Android | macOS | Windows |
| ---- | --- | ------- | ----- | ------- |
| Path | ✅  | ✅      | ✅    | ✅      |
| Uri  | ✅  | ✅      | ✅    | -       |

## Usage

```dart
final plugin = FcNativeVideoThumbnail();

try {
  /// Gets a thumbnail from [srcFile] with the given options and saves it to [destFile].
  ///
  /// [srcFile] source video path or Uri (See [srcFileUri]).
  /// [srcFileUri] If true, [srcFile] is a Uri (Android/iOS/macOS only).
  /// [destFile] destination thumbnail path.
  /// [width] / [height] max dimensions of the destination thumbnail.
  /// Windows doesn't support non-square thumbnail images, only [width] is used in Windows, resulting in a [width]x[width] max thumbnail.
  /// [format] only "jpeg" is supported. Defaults to "jpeg".
  /// [quality] a fallback value for the quality of the thumbnail image (0-100). May be ignored by the platform.
  ///
  /// Returns true if thumbnail was successfully created. Or false if thumbnail is not available.
  /// Throws if error happens during thumbnail generation.
  final thumbnailGenerated = await plugin.getVideoThumbnail(
            srcFile: srcFile,
            destFile: destFile,
            width: 300,
            height: 300,
            format: 'jpeg',
            quality: 90);
} catch (err) {
  // Handle platform errors.
}
```
