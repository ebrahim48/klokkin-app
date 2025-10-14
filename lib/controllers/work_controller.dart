import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class WorkCardController extends GetxController {


  final _currentPlayingIndex = (-1).obs;
  final _videoControllers = <int, VideoPlayerController>{}.obs;

  int get currentPlayingIndex => _currentPlayingIndex.value;

  Future<void> setVideoPath(int index, String videoUrl) async {
    // Stop other videos
    if (_currentPlayingIndex.value != -1 && _currentPlayingIndex.value != index) {
      final prev = _videoControllers[_currentPlayingIndex.value];
      prev?.pause();
    }

    // Check if controller exists
    if (!_videoControllers.containsKey(index)) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await controller.initialize();
      _videoControllers[index] = controller;
    }

    _currentPlayingIndex.value = index;
    update();
  }

  VideoPlayerController? getController(int index) => _videoControllers[index];

  void togglePlayPause(int index) {
    final controller = _videoControllers[index];
    if (controller == null) return;

    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }

    _currentPlayingIndex.value = index;
    update();
  }

  bool isPlaying(int index) {
    final controller = _videoControllers[index];
    return controller?.value.isPlaying ?? false;
  }

  bool isInitialized(int index) {
    final controller = _videoControllers[index];
    return controller?.value.isInitialized ?? false;
  }

  @override
  void onClose() {
    for (var vc in _videoControllers.values) {
      vc.dispose();
    }
    super.onClose();
  }













  // late VideoPlayerController videoController;
  // var isPlaying = false.obs;
  // var isInitialized = false.obs;
  //
  // void setVideoPath(String videoUrl) {
  //   videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
  //     ..initialize().then((_) {
  //       isInitialized.value = true;
  //       update();
  //     });
  // }
  //
  // void togglePlayPause() {
  //   if (isPlaying.value) {
  //     videoController.pause();
  //   } else {
  //     videoController.play();
  //   }
  //   isPlaying.value = !isPlaying.value;
  // }
  //
  // @override
  // void onClose() {
  //   videoController.dispose();
  //   super.onClose();
  // }









}
