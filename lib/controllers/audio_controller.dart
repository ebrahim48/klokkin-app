import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

/// Single media controller for BOTH audio and video.
///
/// Previously audio was faked with a Timer that just incremented a counter
/// (no real sound, hardcoded 600s duration), and video state was tracked
/// in two competing places (a manual `isPlaying = !isPlaying` flip *and* a
/// listener), which made the play button and timestamp inconsistent.
///
/// `video_player` can play a plain audio URL (e.g. an .mp3) just fine — it
/// simply has no video track — so we route everything through one
/// [VideoPlayerController]. That gives real playback, the real duration and
/// the real position for audio and video alike, with ONE source of truth.
class AudioController extends GetxController {
  VideoPlayerController? _vc;

  /// Whether the current media has a visible video surface (vs. audio-only).
  /// Only affects the UI; playback path is identical for both.
  final isVideo = false.obs;

  final isPlaying = false.obs;
  final isInitialized = false.obs;
  final isBuffering = false.obs;

  final currentTime = 0.0.obs; // seconds (fractional, smooth)
  final totalTime = 0.0.obs; // seconds
  final playbackSpeed = 1.0.obs;

  String? _currentUrl;

  VideoPlayerController get videoController => _vc!;

  /// Load [url] (if not already loaded) and start playing. Used by the play
  /// button so a single tap always works — the old code called an async
  /// `setMediaPath` and a synchronous `togglePlayPause` together, so the
  /// first tap bailed out with "not initialized" and you had to tap twice.
  Future<void> loadAndPlay(String url, {required bool video}) async {
    await setMediaPath(url, video: video);
    await play();
  }

  /// Prepare media without auto-playing (call from the screen as soon as the
  /// story is known, so the player is ready before the first tap).
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

    final vc = VideoPlayerController.networkUrl(Uri.parse(url));
    _vc = vc;
    vc.addListener(_onTick);

    try {
      await vc.initialize();
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

  /// The ONLY place play state / progress is derived from — keeps the
  /// button icon and both timestamps perfectly in sync with the player.
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

    // Reached the end: stop cleanly and reset to the start so the play
    // button shows ▶ again and replays from 0 instead of being stuck.
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
}
