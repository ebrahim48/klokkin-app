import 'dart:async';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class AudioController extends GetxController {



  late VideoPlayerController videoController;

  var isVideo = false.obs;
  var isPlaying = false.obs;
  var isInitialized = false.obs;

  // Audio variables
  var currentTime = 0.0.obs;
  var totalTime = 600.0.obs; // default audio duration
  var playbackSpeed = 1.0.obs;

  Timer? _timer;
  Timer? _videoProgressTimer;
  String? _currentMediaUrl;

  @override
  void onInit() {
    super.onInit();
  }

  // Set media URL (video/audio)
  void setMediaPath(String url, {bool video = false}) async {
    // Don't reload if same URL
    if (_currentMediaUrl == url && isInitialized.value) return;

    _currentMediaUrl = url;
    isVideo.value = video;
    isPlaying.value = false;
    isInitialized.value = false;

    // Stop and dispose previous media
    await _stopAndDispose();

    if (video) {
      await _initializeVideo(url);
    } else {
      await _initializeAudio(url);
    }
  }

  Future<void> _stopAndDispose() async {
    _timer?.cancel();
    _videoProgressTimer?.cancel();

    // if (isVideo.value && this::videoController.isInitialized) {
    //   try {
    //     await videoController.pause();
    //     await videoController.dispose();
    //   } catch (e) {
    //     print('Error disposing video controller: $e');
    //   }
    // }

    currentTime.value = 0;
  }

  Future<void> _initializeVideo(String url) async {
    try {
      videoController = VideoPlayerController.networkUrl(Uri.parse(url));

      // Add listener for video state changes
      videoController.addListener(_videoListener);

      await videoController.initialize();
      totalTime.value = videoController.value.duration.inSeconds.toDouble();
      isInitialized.value = true;

      // Start progress tracking timer for video
      _startVideoProgressTracking();

    } catch (e) {
      print('Error initializing video: $e');
      isInitialized.value = false;
    }
  }

  Future<void> _initializeAudio(String url) async {
    // For audio, you might want to use a proper audio player library
    // like just_audio or audioplayers for better audio handling
    // For now, using placeholder values
    totalTime.value = 600; // You should get actual duration from audio file
    currentTime.value = 0;
    isInitialized.value = true;
  }

  void _videoListener() {
    if (videoController.value.isPlaying != isPlaying.value) {
      isPlaying.value = videoController.value.isPlaying;
    }
  }

  void _startVideoProgressTracking() {
    _videoProgressTimer?.cancel();
    _videoProgressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (videoController.value.isInitialized) {
        currentTime.value = videoController.value.position.inSeconds.toDouble();

        // Check if video ended
        if (videoController.value.position >= videoController.value.duration) {
          isPlaying.value = false;
          _videoProgressTimer?.cancel();
        }
      }
    });
  }

  // Play/pause logic
  void togglePlayPause() async {
    if (!isInitialized.value) {
      print('Media not initialized');
      return;
    }

    if (isVideo.value) {
      await _toggleVideoPlayPause();
    } else {
      _toggleAudioPlayPause();
    }
  }

  Future<void> _toggleVideoPlayPause() async {
    try {
      if (isPlaying.value) {
        await videoController.pause();
        _videoProgressTimer?.cancel();
      } else {
        await videoController.play();
        _startVideoProgressTracking();
      }
      isPlaying.value = !isPlaying.value;
    } catch (e) {
      print('Error toggling video play/pause: $e');
    }
  }

  void _toggleAudioPlayPause() {
    if (isPlaying.value) {
      _timer?.cancel();
      isPlaying.value = false;
    } else {
      isPlaying.value = true;
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        currentTime.value += 0.1 * playbackSpeed.value;

        if (currentTime.value >= totalTime.value) {
          currentTime.value = totalTime.value;
          isPlaying.value = false;
          _timer?.cancel();
        }
      });
    }
  }

  void seek(double value) async {
    if (isVideo.value && isInitialized.value) {
      try {
        await videoController.seekTo(Duration(seconds: value.toInt()));
        currentTime.value = value;
      } catch (e) {
        print('Error seeking video: $e');
      }
    } else {
      currentTime.value = value.clamp(0, totalTime.value);
    }
  }

  void setPlaybackSpeed(double speed) {
    playbackSpeed.value = speed;

    if (isVideo.value && isInitialized.value) {
      videoController.setPlaybackSpeed(speed);
    }
    // For audio, the timer interval adjustment handles speed change
  }

  String formatSpeed(double speed) {
    if (speed == speed.toInt()) return "${speed.toInt()}X";
    return "${speed.toStringAsFixed(1)}X";
  }

  // Method to restart media from beginning
  void restart() {
    seek(0.0);
  }

  // Method to check if media is at the end
  bool get isAtEnd => currentTime.value >= totalTime.value;

  @override
  void onClose() {
    _stopAndDispose();
    super.onClose();
  }

  final List<String> hashtags = [
    "#innovation",
    "#tech",
    "#engineer",
    "#2010s",
  ];




}
