import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../core/helpers/media_url_helper.dart';



class WorkCardLibraryController extends GetxController {

  late VideoPlayerController videoController;
  bool _initialized = false;
  var isPlaying = false.obs;
  var isInitialized = false.obs;

  void setVideoPath(String videoUrl) {
    final uri = MediaUrlHelper.toUri(videoUrl);
    if (uri == null) {
      isInitialized.value = false;
      return;
    }

    videoController = VideoPlayerController.networkUrl(uri);
    _initialized = true;

    // The failure branch used to be missing entirely, so a broken URL threw an
    // unhandled async error and the card stayed on its spinner (2.1(a)).
    videoController
        .initialize()
        .timeout(const Duration(seconds: 25))
        .then((_) {
      isInitialized.value = true;
      videoController.setLooping(true);
    }).catchError((Object e) {
      isInitialized.value = false;
      // ignore: avoid_print
      print('Error initializing library video: $e');
    });
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      videoController.pause();
    } else {
      videoController.play();
    }
    isPlaying.toggle();
  }

  @override
  void onClose() {
    if (_initialized) videoController.dispose();
    super.onClose();
  }



}

