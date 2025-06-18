## 1.1.5 & 1.2.1
- fixed support for GlibC prior to 2.74 on linux.
- fixed support for building with VS2019 on windows.

## 1.2.0
- support Impeller renderer on android.
- require flutter 3.27.0 or higher. use 1.1.x for older flutter versions.

## 1.1.4
- fixed a bug on ios/macos that can lead to crash while setting the volume and speed.

## 1.1.3
- restore example project

## 1.1.2
- minor fixes and optimizations
- support swift package manager on ios/macos

## 1.1.1
- fix broken windows build
- fix flutter min version

## 1.1.0
- support subtitles on all platforms.
- support track selection on all platforms.
- add `setMaxBitRate`, `setMaxResolution`, `setPreferredSubtitleLanguage` and `setPreferredAudioLanguage` methods to `AVMediaPlayer` class.

## 1.0.6
- fixed hls detection issue on android.

## 1.0.5
- fixed a critical issue on ios/macos that may antifact the video.

## 1.0.4
- move android backend to `ExoPlayer` for wider compatibility.
- improve windows backend stability.

## 1.0.3
- fixed a serious bug on android that introduced in v1.0.2.

## 1.0.2
- add linux support.
- **behavior change:** do not seek to beginning while playback is reaching the end until new playback started.

## 1.0.1
- fixed an issue that may cause an error while disposing the player.

## 1.0.0

- improve rendering performance on ios/macos.

## 0.7.2
- prevent calling backend while player is disposed in dart side.

## 0.7.1
- optimize windows backend.

## 0.7.0
- fixed `asset://` scheme issues on android and macos.
- support hot restart on all platforms.

## 0.6.9
- minor fixes on windows.

## 0.6.8
- add Windows support.
- **breaking change:** rename `AVMediaPlayer` class to `AvMediaPlayer`.
- **breaking change:** rename `AVMediaView` class to `AvMediaView`.

## 0.6.7
- support `asset://` scheme for local assets.
- support realtime streaming playback(ios/macos: ll-hls, android: rtsp). a realtime stream should have a `duration` of 0.
- **breaking change:** move `width` and `height` from `mediaInfo` to `videoSize` in `AVMediaPlayer` class as video size may change during playback.

## 0.6.6
- dispose all native `AVMediaPlayer` instances while flutter engine is restarting. (Android only)

## 0.6.5
- make sure the first frame is loaded before receiving `mediaInfo` in ios/macos.

## 0.6.4
- fixed a bug may cause video freeze on ios/macos.
- **breaking change:** replace `SetStateSafely` mixin with `SetStateAsync`.

## 0.6.3
- minor fixes.

## 0.6.2
- fix code formatting issues.

## 0.6.1
- `seekTo` won't increase `finishedTimes` any more if the player is not in `playing` state.
- auto correct param values in `seekTo`, `setVolume` and `setSpeed` methods.

## 0.6.0
- fix type mismatch issue in android seekTo method.

## 0.5.9
- check current position in seekTo calls from native side.

## 0.5.8
- interduce `SetStateSafely` mixin to prevent errors while `setState` is called on a bad time.

## 0.5.7
- **breaking change:** remove `keepAspectRatio` property from `AVMediaView` widget and add `sizingMode` property instead.

## 0.5.6
- fix setState issue in `AVMediaView` widget

## 0.5.5
- improve vsync handling on ios/macos
- improve dartdoc comments

## 0.5.4
- improve vsync handling on macos
- fixed a resource leak issue on ios/macos

## 0.5.3
- improve dartdoc comments
- improve examples
- combine macos and ios backend code
- add `backgroundColor` and `keepAspectRatio` support for `AVMediaView` widget

## 0.5.2
- add dartdoc comments
- change default example to the simple one

## 0.5.1
- first public release.
