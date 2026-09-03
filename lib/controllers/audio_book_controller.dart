import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../core/helpers/media_url_helper.dart';
import '../core/helpers/toast_message_helper.dart';
import '../models/story_libray_data_model.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

class AudioBookController extends GetxController {

  /// ================================> Audio Player ==============================>
  // Uses video_player because just_audio is not declared in pubspec and the
  // detail screen already plays the same media URLs reliably through
  // video_player. One controller per active track; recreated when the user
  // taps a different row.
  VideoPlayerController? _vc;
  Timer? _positionTimer;

  // Track which audio is currently playing
  final RxInt currentPlayingIndex = (-1).obs;
  final RxBool isPlaying = false.obs;
  final RxBool isLoading = false.obs;

  // Track current position and duration
  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;

  void _onTick() {
    final vc = _vc;
    if (vc == null || !vc.value.isInitialized) return;
    currentPosition.value = vc.value.position;
    if (vc.value.duration > Duration.zero) {
      totalDuration.value = vc.value.duration;
    }
    if (isPlaying.value != vc.value.isPlaying) {
      isPlaying.value = vc.value.isPlaying;
    }
    if (vc.value.position >= vc.value.duration &&
        vc.value.duration > Duration.zero) {
      vc.pause();
      vc.seekTo(Duration.zero);
      isPlaying.value = false;
      currentPlayingIndex.value = -1;
      currentPosition.value = Duration.zero;
    }
  }

  Future<void> _disposeVc() async {
    final vc = _vc;
    _vc = null;
    if (vc != null) {
      vc.removeListener(_onTick);
      try { await vc.pause(); } catch (_) {}
      try { await vc.dispose(); } catch (_) {}
    }
  }

  /// Play or pause audio at specific index
  Future<void> toggleAudio(int index, String audioUrl) async {
    try {
      // Same row, currently playing → pause
      if (currentPlayingIndex.value == index && _vc != null) {
        if (_vc!.value.isPlaying) {
          await _vc!.pause();
          isPlaying.value = false;
        } else {
          await _vc!.play();
          isPlaying.value = true;
        }
        update();
        return;
      }

      // Different row — tear down previous and start fresh
      isLoading.value = true;
      currentPlayingIndex.value = index;
      currentPosition.value = Duration.zero;
      totalDuration.value = Duration.zero;
      update();

      await _disposeVc();

      final uri = MediaUrlHelper.toUri(audioUrl);
      if (uri == null) throw Exception('Invalid media url');

      final vc = VideoPlayerController.networkUrl(uri);
      _vc = vc;
      vc.addListener(_onTick);
      await vc.initialize().timeout(const Duration(seconds: 25));
      totalDuration.value = vc.value.duration;
      await vc.play();

      isPlaying.value = true;
      isLoading.value = false;
      update();
    } catch (e) {
      print('Error playing audio: $e');
      isLoading.value = false;
      isPlaying.value = false;
      currentPlayingIndex.value = -1;
      update();
      ToastMessageHelper.showToastMessage("No Audio");
    }
  }

  /// Format duration to mm:ss
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  /// Stop audio
  Future<void> stopAudio() async {
    await _disposeVc();
    isPlaying.value = false;
    currentPlayingIndex.value = -1;
    currentPosition.value = Duration.zero;
  }

  /// ================================> Library Stories ==============================>

  Rxn<Meta> audioMeta = Rxn<Meta>();
  Rxn<Meta> videoMeta = Rxn<Meta>();
  Rxn<Meta> imageMeta = Rxn<Meta>();

  // Pagination variables
  RxInt audioPage = 1.obs;
  RxInt videoPage = 1.obs;
  RxInt imagePage = 1.obs;

  RxBool getLibraryStoryLoading = false.obs;
  RxBool loadingMoreAudio = false.obs;

  RxList<StoryLibraryDataModel> libraryStoryData = <StoryLibraryDataModel>[].obs;
  RxList<StoryLibraryDataModel> audioStories = <StoryLibraryDataModel>[].obs;
  RxList<StoryLibraryDataModel> videoStories = <StoryLibraryDataModel>[].obs;
  RxList<StoryLibraryDataModel> imageStories = <StoryLibraryDataModel>[].obs;

  // Initial load - gets first page of all types
  getLibraryStoryData() async {
    getLibraryStoryLoading(true);

    var response = await ApiClient.getData(ApiConstants.getStoryLibraryEndPoint);

    if (response.statusCode == 200) {
      final data = response.body["data"]["attributes"]["data"];

      // Clear existing data
      libraryStoryData.clear();
      audioStories.clear();
      videoStories.clear();
      imageStories.clear();

      // Collect audio
      final audioGroup = data["audio"];
      final audioResults = (audioGroup["results"] as List?) ?? [];
      audioMeta.value = audioGroup?["meta"] != null ? Meta.fromJson(audioGroup["meta"]) : null;

      final audioList = audioResults.map((x) =>
          StoryLibraryDataModel.fromJson(x as Map<String, dynamic>)
      ).toList();

      audioStories.addAll(audioList);
      libraryStoryData.addAll(audioList);

      // Collect video
      final videoGroup = data["video"];
      final videoResults = (videoGroup["results"] as List?) ?? [];
      videoMeta.value = videoGroup?["meta"] != null ? Meta.fromJson(videoGroup["meta"]) : null;

      final videoList = videoResults.map((x) =>
          StoryLibraryDataModel.fromJson(x as Map<String, dynamic>)
      ).toList();

      videoStories.addAll(videoList);
      libraryStoryData.addAll(videoList);

      // Collect image
      final imageGroup = data["image"];
      final imageResults = (imageGroup["results"] as List?) ?? [];
      imageMeta.value = imageGroup?["meta"] != null ? Meta.fromJson(imageGroup["meta"]) : null;

      final imageList = imageResults.map((x) =>
          StoryLibraryDataModel.fromJson(x as Map<String, dynamic>)
      ).toList();

      imageStories.addAll(imageList);
      libraryStoryData.addAll(imageList);

      print("✅ Loaded: ${audioStories.length} audio, ${videoStories.length} video, ${imageStories.length} image");
    }

    getLibraryStoryLoading(false);
  }

  // Load more audio stories
  Future<void> loadMoreAudioStories() async {
    // Check if there are more pages
    if (audioMeta.value == null) return;

    final currentPage = audioMeta.value!.page ?? 1;
    final totalPages = audioMeta.value!.totalPage ?? 1;

    if (currentPage >= totalPages) {
      print("⚠️ No more audio stories to load");
      return;
    }

    if (loadingMoreAudio.value) {
      print("⚠️ Already loading more audio stories");
      return;
    }

    loadingMoreAudio(true);
    audioPage.value = currentPage + 1;

    try {
      print("📥 Loading audio page ${audioPage.value}...");

      // API call with page parameter (you need to update your endpoint to support pagination)
      var response = await ApiClient.getData(
          "${ApiConstants.getStoryLibraryEndPoint}?audioPage=${audioPage.value}"
      );

      if (response.statusCode == 200) {
        final data = response.body["data"]["attributes"]["data"];
        final audioGroup = data["audio"];
        final audioResults = (audioGroup["results"] as List?) ?? [];

        // Update meta with new pagination info
        audioMeta.value = audioGroup?["meta"] != null ? Meta.fromJson(audioGroup["meta"]) : null;

        // Add new audio stories
        final newAudioList = audioResults.map((x) =>
            StoryLibraryDataModel.fromJson(x as Map<String, dynamic>)
        ).toList();

        audioStories.addAll(newAudioList);
        libraryStoryData.addAll(newAudioList);

        print("✅ Loaded ${newAudioList.length} more audio stories. Total: ${audioStories.length}");
      }
    } catch (e) {
      print("❌ Error loading more audio stories: $e");
      ToastMessageHelper.showToastMessage("Failed to load more stories");
    }

    loadingMoreAudio(false);
  }

  // Check if can load more audio
  bool get canLoadMoreAudio {
    if (audioMeta.value == null) return false;
    final currentPage = audioMeta.value!.page ?? 1;
    final totalPages = audioMeta.value!.totalPage ?? 1;
    return currentPage < totalPages;
  }

  // Load more video stories
  RxBool loadingMoreVideo = false.obs;

  Future<void> loadMoreVideoStories() async {
    if (videoMeta.value == null) return;

    final currentPage = videoMeta.value!.page ?? 1;
    final totalPages = videoMeta.value!.totalPage ?? 1;

    if (currentPage >= totalPages) {
      print("⚠️ No more video stories to load");
      return;
    }

    if (loadingMoreVideo.value) {
      print("⚠️ Already loading more video stories");
      return;
    }

    loadingMoreVideo(true);
    videoPage.value = currentPage + 1;

    try {
      print("📥 Loading video page ${videoPage.value}...");

      var response = await ApiClient.getData(
          "${ApiConstants.getStoryLibraryEndPoint}?videoPage=${videoPage.value}"
      );

      if (response.statusCode == 200) {
        final data = response.body["data"]["attributes"]["data"];
        final videoGroup = data["video"];
        final videoResults = (videoGroup["results"] as List?) ?? [];

        videoMeta.value = videoGroup?["meta"] != null ? Meta.fromJson(videoGroup["meta"]) : null;

        final newVideoList = videoResults.map((x) =>
            StoryLibraryDataModel.fromJson(x as Map<String, dynamic>)
        ).toList();

        videoStories.addAll(newVideoList);
        libraryStoryData.addAll(newVideoList);

        print("✅ Loaded ${newVideoList.length} more video stories. Total: ${videoStories.length}");
      }
    } catch (e) {
      print("❌ Error loading more video stories: $e");
      ToastMessageHelper.showToastMessage("Failed to load more video stories");
    }

    loadingMoreVideo(false);
  }

  bool get canLoadMoreVideo {
    if (videoMeta.value == null) return false;
    final currentPage = videoMeta.value!.page ?? 1;
    final totalPages = videoMeta.value!.totalPage ?? 1;
    return currentPage < totalPages;
  }

  // Load more image stories
  RxBool loadingMoreImage = false.obs;

  Future<void> loadMoreImageStories() async {
    if (imageMeta.value == null) return;

    final currentPage = imageMeta.value!.page ?? 1;
    final totalPages = imageMeta.value!.totalPage ?? 1;

    if (currentPage >= totalPages) {
      print("⚠️ No more image stories to load");
      return;
    }

    if (loadingMoreImage.value) {
      print("⚠️ Already loading more image stories");
      return;
    }

    loadingMoreImage(true);
    imagePage.value = currentPage + 1;

    try {
      print("📥 Loading image page ${imagePage.value}...");

      var response = await ApiClient.getData(
          "${ApiConstants.getStoryLibraryEndPoint}?imagePage=${imagePage.value}"
      );

      if (response.statusCode == 200) {
        final data = response.body["data"]["attributes"]["data"];
        final imageGroup = data["image"];
        final imageResults = (imageGroup["results"] as List?) ?? [];

        imageMeta.value = imageGroup?["meta"] != null ? Meta.fromJson(imageGroup["meta"]) : null;

        final newImageList = imageResults.map((x) =>
            StoryLibraryDataModel.fromJson(x as Map<String, dynamic>)
        ).toList();

        imageStories.addAll(newImageList);
        libraryStoryData.addAll(newImageList);

        print("✅ Loaded ${newImageList.length} more image stories. Total: ${imageStories.length}");
      }
    } catch (e) {
      print("❌ Error loading more image stories: $e");
      ToastMessageHelper.showToastMessage("Failed to load more image stories");
    }

    loadingMoreImage(false);
  }

  bool get canLoadMoreImage {
    if (imageMeta.value == null) return false;
    final currentPage = imageMeta.value!.page ?? 1;
    final totalPages = imageMeta.value!.totalPage ?? 1;
    return currentPage < totalPages;
  }

  /// ============================> Update Story ==================================>

  var updateStoryLoading = false.obs;

  updateStory(
      String storyId,
      String? caption,
      String? description,
      ) async {
    var body = {
      'caption': caption,
      'description': description,
    };
    updateStoryLoading(true);
    var response = await ApiClient.patchData(
      ApiConstants.updateStoryEndPoint(storyId),
      body: body,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.showToastMessage("${response.body["message"]}");
    }
    updateStoryLoading(false);
  }

  /// ==================================> Delete ============================>

  var deleteStoryLoading = false.obs;

  Future<void> deleteStory(String storyId) async {
    deleteStoryLoading(true);

    try {
      var response = await ApiClient.deleteData(
        ApiConstants.deleteStoryEndPoint(storyId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastMessageHelper.showToastMessage("Story deleted successfully");
        await getLibraryStoryData();
      } else {
        ToastMessageHelper.showToastMessage("Failed to delete story");
      }
    } catch (e) {
      print("Delete error: $e");
      ToastMessageHelper.showToastMessage("Error deleting story");
    }

    deleteStoryLoading(false);
  }

  /// ============================> Bookmark ==================================>

  var bookMarkLoading = false.obs;

  bookMark(String storyId) async {
    var body = {
      'story': storyId,
    };
    bookMarkLoading(true);
    var response = await ApiClient.postData(
        ApiConstants.bookMarkEndPoint,
        jsonEncode(body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.showToastMessage("${response.body["message"]}");
    }
    bookMarkLoading(false);
  }

  var deleteBookMarkLoading = false.obs;

  deleteBookMark(String bookmarkId) async {
    var body = {
      'bookmarkId': bookmarkId,
    };
    deleteBookMarkLoading(true);
    var response = await ApiClient.postData(
        ApiConstants.deleteBookMarkEndPoint,
        jsonEncode(body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.showToastMessage("${response.body["message"]}");
    }
    deleteBookMarkLoading(false);
  }

  @override
  void onClose() {
    _positionTimer?.cancel();
    _disposeVc();
    super.onClose();
  }
}