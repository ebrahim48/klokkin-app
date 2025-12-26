import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../core/helpers/toast_message_helper.dart';
import '../models/story_libray_data_model.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

class AudioBookController extends GetxController {

  /// ================================> Audio Player ==============================>

  final AudioPlayer audioPlayer = AudioPlayer();

  // Track which audio is currently playing
  final RxInt currentPlayingIndex = (-1).obs;
  final RxBool isPlaying = false.obs;
  final RxBool isLoading = false.obs;

  // Track current position and duration
  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;

  // Streams subscription to avoid multiple listeners
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PlayerState>? _stateSubscription;

  @override
  void onInit() {
    super.onInit();

    // Listen to position changes (real-time progress)
    _positionSubscription = audioPlayer.positionStream.listen((position) {
      currentPosition.value = position;
      update();
    });

    // Listen to duration
    _durationSubscription = audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        totalDuration.value = duration;
        update();
      }
    });

    // Listen to player state changes
    _stateSubscription = audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isPlaying.value = false;
        currentPlayingIndex.value = -1;
        currentPosition.value = Duration.zero;
        update();
      }
    });
  }

  /// Play or pause audio at specific index
  Future<void> toggleAudio(int index, String audioUrl) async {
    try {
      // If clicking the same audio that's playing
      if (currentPlayingIndex.value == index && isPlaying.value) {
        // Update state immediately before calling audio player
        isPlaying.value = false;
        update();
        await audioPlayer.pause();
        return;
      }

      // If clicking the same audio that's paused
      if (currentPlayingIndex.value == index && !isPlaying.value) {
        // Update state immediately before calling audio player
        isPlaying.value = true;
        update();
        await audioPlayer.play();
        return;
      }

      // If clicking a different audio
      isLoading.value = true;
      update();

      currentPlayingIndex.value = index;

      await audioPlayer.setUrl(audioUrl);
      await audioPlayer.play();

      // Update state after audio starts playing
      isPlaying.value = true;
      isLoading.value = false;
      update();

    } catch (e) {
      print('Error playing audio: $e');
      isLoading.value = false;
      isPlaying.value = false;
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
    await audioPlayer.stop();
    isPlaying.value = false;
    currentPlayingIndex.value = -1;
    currentPosition.value = Duration.zero;
  }

  /// ================================> Library Stories ==============================>

  Rxn<Meta> audioMeta = Rxn<Meta>();
  Rxn<Meta> videoMeta = Rxn<Meta>();
  Rxn<Meta> imageMeta = Rxn<Meta>();

  RxInt page = 1.obs;
  var totalPages = (-1);
  var currentPage = (-1);
  var total = (-1);

  void loadMore() {
    print("==========================================total page ${totalPages} page No: ${page.value} == total result ${total}");
    if (totalPages > page.value) {
      page.value += 1;
      print("**********************print here");
      update();
    }
  }

  RxBool getLibraryStoryLoading = false.obs;

  RxList<StoryLibraryDataModel> libraryStoryData = <StoryLibraryDataModel>[].obs;

  getLibraryStoryData() async {
    if (page.value == 1) {
      getLibraryStoryLoading(true);
    }

    getLibraryStoryLoading(true);
    var response = await ApiClient.getData(ApiConstants.getStoryLibraryEndPoint);

    if (response.statusCode == 200) {
      final data = response.body["data"]["attributes"]["data"];

      final mergedStories = <StoryLibraryDataModel>[];

      // Collect audio
      final audioGroup = data["audio"];
      final audioResults = (data["audio"]["results"] as List?) ?? [];
      audioMeta.value = audioGroup?["meta"] != null ? Meta.fromJson(audioGroup["meta"]) : null;
      mergedStories.addAll(
        audioResults.map((x) => StoryLibraryDataModel.fromJson(x as Map<String, dynamic>)),
      );

      // Collect video
      final videoGroup = data["video"];
      final videoResults = (data["video"]["results"] as List?) ?? [];
      videoMeta.value = videoGroup?["meta"] != null ? Meta.fromJson(videoGroup["meta"]) : null;
      mergedStories.addAll(
        videoResults.map((x) => StoryLibraryDataModel.fromJson(x as Map<String, dynamic>)),
      );

      // Collect image
      final imageGroup = data["image"];
      final imageResults = (data["image"]["results"] as List?) ?? [];
      imageMeta.value = imageGroup?["meta"] != null ? Meta.fromJson(imageGroup["meta"]) : null;
      mergedStories.addAll(
        imageResults.map((x) => StoryLibraryDataModel.fromJson(x as Map<String, dynamic>)),
      );

      libraryStoryData.value = mergedStories;
    }

    getLibraryStoryLoading(false);
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

//// ==================================> Delete ============================>

  var deleteStoryLoading = false.obs;

  Future<void> deleteStory(String storyId) async {
    deleteStoryLoading(true);

    try {
      var response = await ApiClient.deleteData(
        ApiConstants.deleteStoryEndPoint(storyId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastMessageHelper.showToastMessage("Story deleted successfully");
        // Refresh the story list after delete
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
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _stateSubscription?.cancel();
    audioPlayer.dispose();
    super.onClose();
  }






}