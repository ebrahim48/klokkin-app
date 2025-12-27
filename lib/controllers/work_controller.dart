import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class WorkCardController extends GetxController {
  final _currentPlayingIndex = (-1).obs;
  final _videoControllers = <int, VideoPlayerController>{}.obs;
  final _isInitialized = <int, bool>{}.obs;
  final _isPlaying = <int, bool>{}.obs;

  int get currentPlayingIndex => _currentPlayingIndex.value;

  Future<void> setVideoPath(int index, String videoUrl) async {
    try {
      // Stop and pause other videos
      if (_currentPlayingIndex.value != -1 && _currentPlayingIndex.value != index) {
        final prevController = _videoControllers[_currentPlayingIndex.value];
        if (prevController != null && prevController.value.isPlaying) {
          await prevController.pause();
          _isPlaying[_currentPlayingIndex.value] = false;
        }
      }

      // Check if controller already exists
      if (_videoControllers.containsKey(index)) {
        print("✅ Video controller already exists for index $index");
        return;
      }

      print("🎥 Initializing video for index $index: $videoUrl");

      // Create new controller
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

      // Add listener for state changes
      controller.addListener(() {
        _isPlaying[index] = controller.value.isPlaying;
        update();
      });

      // Initialize the controller
      await controller.initialize();

      // Store controller and mark as initialized
      _videoControllers[index] = controller;
      _isInitialized[index] = true;
      _isPlaying[index] = false;

      print("✅ Video initialized successfully for index $index");
      update();
    } catch (e) {
      print("❌ Error initializing video at index $index: $e");
      _isInitialized[index] = false;
    }
  }

  VideoPlayerController? getController(int index) => _videoControllers[index];

  Future<void> togglePlayPause(int index) async {
    final controller = _videoControllers[index];
    if (controller == null || !(_isInitialized[index] ?? false)) {
      print("⚠️ Controller not initialized for index $index");
      return;
    }

    try {
      if (controller.value.isPlaying) {
        // Pause current video
        print("⏸️ Pausing video at index $index");
        await controller.pause();
        _isPlaying[index] = false;
      } else {
        // Pause any currently playing video
        if (_currentPlayingIndex.value != -1 && _currentPlayingIndex.value != index) {
          final prevController = _videoControllers[_currentPlayingIndex.value];
          if (prevController != null && prevController.value.isPlaying) {
            await prevController.pause();
            _isPlaying[_currentPlayingIndex.value] = false;
          }
        }

        // Play this video
        print("▶️ Playing video at index $index");
        await controller.play();
        _isPlaying[index] = true;
        _currentPlayingIndex.value = index;
      }

      update();
    } catch (e) {
      print("❌ Error toggling play/pause for index $index: $e");
    }
  }

  bool isPlaying(int index) {
    return _isPlaying[index] ?? false;
  }

  bool isInitialized(int index) {
    return _isInitialized[index] ?? false;
  }

  // Pause all videos
  Future<void> pauseAll() async {
    for (var entry in _videoControllers.entries) {
      if (entry.value.value.isPlaying) {
        await entry.value.pause();
        _isPlaying[entry.key] = false;
      }
    }
    _currentPlayingIndex.value = -1;
    update();
  }

  // Dispose specific controller
  void disposeController(int index) {
    final controller = _videoControllers[index];
    if (controller != null) {
      controller.removeListener(() {});
      controller.dispose();
      _videoControllers.remove(index);
      _isInitialized.remove(index);
      _isPlaying.remove(index);

      if (_currentPlayingIndex.value == index) {
        _currentPlayingIndex.value = -1;
      }

      print("🗑️ Disposed controller for index $index");
    }
  }

  @override
  void onClose() {
    print("🧹 Disposing all video controllers");
    for (var entry in _videoControllers.entries) {
      entry.value.removeListener(() {});
      entry.value.dispose();
    }
    _videoControllers.clear();
    _isInitialized.clear();
    _isPlaying.clear();
    super.onClose();
  }
}