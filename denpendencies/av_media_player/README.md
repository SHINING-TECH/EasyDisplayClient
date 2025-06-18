## About

av_media_player is a lightweight media player with subtitle rendering[^subtitle] and track selection support, leveraging system or app-level components for seamless playback, video rendering via `Texture` widget.
For API documentation, please visit [here](https://pub.dev/documentation/av_media_player/latest/index/index-library.html).

| **Platform** | **Version** | **Backend**                                                                           |
| ------------ | ----------- | ------------------------------------------------------------------------------------- |
| iOS          | 15+         | [AVPlayer](https://developer.apple.com/documentation/avfoundation/avplayer/)          |
| macOS        | 12+         | [AVPlayer](https://developer.apple.com/documentation/avfoundation/avplayer/)          |
| Android      | 8+          | [ExoPlayer](https://developer.android.com/media/media3/exoplayer)                     |
| Windows      | 10+         | [MediaPlayer](https://learn.microsoft.com/uwp/api/windows.media.playback.mediaplayer) |
| Linux        | N/A         | [libmpv](https://github.com/mpv-player/mpv/tree/master/libmpv)[^libmpv]               |

## Supported media formats

The supported media formats vary by platform but generally include:

| **Type**          | **Formats**               |
| ----------------- | ------------------------- |
| Video Codec       | H.264, H.265(HEVC)[^h265] |
| Audio Codec       | AAC, MP3                  |
| Container Format  | MP4, TS                   |
| Subtitle Format   | WebVTT[^webvtt]           |
| Transfer Protocol | HTTP, HLS, LL-HLS         |

[^subtitle]: Only internal subtitle tracks are supported.
[^libmpv]: The Linux backend requires `libmpv`(aka `mpv-libs`). Developers integrating this plugin into Linux app should install `libmpv-dev`(aka `mpv-libs-devel`) instead. If unavailable in your package manager, please build `libmpv` from source. For details, refer to [mpv-build](https://github.com/mpv-player/mpv-build).
[^h265]: Windows user may need to install a free [H.265(HEVC) decoder](https://apps.microsoft.com/detail/9n4wgh0z6vhq) from Microsoft Store.
[^webvtt]: WebVTT is supported on all platforms except Linux, where SRT and ASS formats are supported instead.
