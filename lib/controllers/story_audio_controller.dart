import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../core/helpers/media_url_helper.dart';

/// Media controller for the story audio/video detail screens.
///
/// Same fix as [AudioController]: this used to fake audio with a Timer (no
/// real sound, hardcoded 600s) and tracked play state in two competing
/// places, which made the play/pause button and timestamp unreliable.
/// Everything now goes through ONE [VideoPlayerController] (it plays plain
/// audio URLs too), so playback, duration and position are real and there
/// is a single source of truth.
class StoryAudioController extends GetxController {
  VideoPlayerController? _vc;

  final isVideo = false.obs;
  final isPlaying = false.obs;
  final isInitialized = false.obs;
  final isBuffering = false.obs;

  final currentTime = 0.0.obs; // seconds (fractional)
  final totalTime = 0.0.obs; // seconds
  final playbackSpeed = 1.0.obs;

  String? _currentUrl;

  VideoPlayerController get videoController => _vc!;

  /// Load (if needed) then play — guarantees a single tap works.
  Future<void> loadAndPlay(String url, {required bool video}) async {
    await setMediaPath(url, video: video);
    await play();
  }

  Future<void> setMediaPath(String url, {bool video = false}) async {
    if (_currentUrl == url && isInitialized.value) return;

    _currentUrl = url;
    isVideo.value = video;
    isPlaying.value = false;
    isInitialized.value = false;
    isBuffering.value = true;
    currentTime.value = 0;
    totalTime.value = 0;

    await _disposeController();

    final uri = MediaUrlHelper.toUri(url);
    if (uri == null) {
      isInitialized.value = false;
      isBuffering.value = false;
      return;
    }

    final vc = VideoPlayerController.networkUrl(uri);
    _vc = vc;
    vc.addListener(_onTick);

    try {
      await vc.initialize().timeout(const Duration(seconds: 25));
      totalTime.value = vc.value.duration.inMilliseconds / 1000.0;
      await vc.setPlaybackSpeed(playbackSpeed.value);
      isInitialized.value = true;
    } catch (e) {
      isInitialized.value = false;
      isBuffering.value = false;
      // ignore: avoid_print
      print('Error initializing media ($url): $e');
    }
  }

  void _onTick() {
    final vc = _vc;
    if (vc == null || !vc.value.isInitialized) return;

    final v = vc.value;
    isBuffering.value = v.isBuffering;
    if (isPlaying.value != v.isPlaying) isPlaying.value = v.isPlaying;

    currentTime.value = v.position.inMilliseconds / 1000.0;
    final dur = v.duration.inMilliseconds / 1000.0;
    if (dur > 0 && (totalTime.value - dur).abs() > 0.5) {
      totalTime.value = dur;
    }

    if (v.position >= v.duration && v.duration > Duration.zero) {
      vc.pause();
      vc.seekTo(Duration.zero);
      isPlaying.value = false;
      currentTime.value = 0;
    }
  }

  Future<void> togglePlayPause() async {
    if (!isInitialized.value) return;
    if (_vc!.value.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> play() async {
    final vc = _vc;
    if (vc == null || !isInitialized.value) return;
    if (vc.value.position >= vc.value.duration &&
        vc.value.duration > Duration.zero) {
      await vc.seekTo(Duration.zero);
    }
    await vc.play();
  }

  Future<void> pause() async {
    final vc = _vc;
    if (vc == null || !isInitialized.value) return;
    await vc.pause();
  }

  Future<void> seek(double seconds) async {
    final vc = _vc;
    if (vc == null || !isInitialized.value) return;
    final clamped = seconds.clamp(0.0, totalTime.value);
    await vc.seekTo(Duration(milliseconds: (clamped * 1000).round()));
    currentTime.value = clamped;
  }

  Future<void> setPlaybackSpeed(double speed) async {
    playbackSpeed.value = speed;
    if (isInitialized.value) await _vc?.setPlaybackSpeed(speed);
  }

  String formatSpeed(double speed) {
    if (speed == speed.toInt()) return "${speed.toInt()}X";
    return "${speed.toStringAsFixed(1)}X";
  }

  void restart() => seek(0.0);

  bool get isAtEnd =>
      totalTime.value > 0 && currentTime.value >= totalTime.value;

  Future<void> _disposeController() async {
    final vc = _vc;
    _vc = null;
    if (vc != null) {
      vc.removeListener(_onTick);
      try {
        await vc.pause();
      } catch (_) {}
      try {
        await vc.dispose();
      } catch (_) {}
    }
  }

  @override
  void onClose() {
    _disposeController();
    super.onClose();
  }

  final List<String> hashtags = [
    "#innovation",
    "#tech",
    "#engineer",
    "#2010s",
  ];
}
