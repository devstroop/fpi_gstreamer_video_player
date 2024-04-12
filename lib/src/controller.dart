import 'package:fpi_gstreamer_video_player/src/seek_mode.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import '../fpi_gstreamer_video_player.dart';
import 'fpi_video_player.dart';

class FpiVideoPlayerController extends VideoPlayerController {
  FpiVideoPlayerController._network(
    super.dataSource, {
    super.formatHint,
    super.closedCaptionFile,
    super.videoPlayerOptions,
    super.httpHeaders,
  }) : super.networkUrl();

  factory FpiVideoPlayerController.withGstreamerPipeline(
    String pipeline, {
    VideoFormat? formatHint,
    Future<ClosedCaptionFile>? closedCaptionFile,
    VideoPlayerOptions? videoPlayerOptions,
    Map<String, String> httpHeaders = const <String, String>{},
  }) {
    _checkPlatform();

    return FpiVideoPlayerController._network(
      Uri(
        scheme: FpiVideoPlayer.pipelineUrlScheme,
        path: FpiVideoPlayer.pipelineUrlCodec.encode(pipeline),
      ),
      formatHint: formatHint,
      closedCaptionFile: closedCaptionFile,
      videoPlayerOptions: videoPlayerOptions,
      httpHeaders: httpHeaders,
    );
  }
}

void _checkPlatform() {
  if (VideoPlayerPlatform.instance is! FpiVideoPlayer) {
    throw StateError(
      '`VideoPlayerPlatform.instance` must be of `FlutterpiVideoPlayer` to use advanced video player features.'
          'Make sure you\'ve called `FlutterpiVideoPlayer.registerWith()` somewhere in main.',
    );
  }
}

FpiVideoPlayer get _platform {
  _checkPlatform();
  return VideoPlayerPlatform.instance as FpiVideoPlayer;
}

extension FlutterpiVideoPlayerControllerAdvancedControls on VideoPlayerController {
  Future<void> fastSeek(Duration position) {
    _platform.seekMode = SeekMode.fast;
    return seekTo(position);
  }

  Future<void> stepForward() async {
    _checkPlatform();

    if (value.isPlaying) {
      await pause();
    }

    // ignore: invalid_use_of_visible_for_testing_member
    await _platform.stepForward(textureId);

    final position = await this.position;
    if (position != null) {
      _platform.seekMode = SeekMode.noop;
      await seekTo(position);
    }
  }

  Future<void> stepBackward() async {
    _checkPlatform();

    if (value.isPlaying) {
      await pause();
    }

    // ignore: invalid_use_of_visible_for_testing_member
    await _platform.stepBackward(textureId);

    final position = await this.position;
    if (position != null) {
      _platform.seekMode = SeekMode.noop;
      await seekTo(position);
    }
  }
}
