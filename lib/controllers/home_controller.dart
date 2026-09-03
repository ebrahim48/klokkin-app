import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/models/my_story_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import '../core/helpers/media_url_helper.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../services/api_client.dart';
import '../../../services/api_constants.dart';
import '../core/helpers/toast_message_helper.dart';
import '../models/all_tags_model.dart';
import '../models/latest_form_model.dart';
import '../models/profile_model.dart';
import '../models/story_single_model.dart';
import '../models/story_steps_model.dart';
import '../models/working_days_model.dart';

class HomeController extends GetxController {

  // ================================> Pending Story Fields (for record flow) ======>
  RxString pendingTitle = ''.obs;
  RxString pendingDescription = ''.obs;

  // ================================> Home data freshness guard ==============>
  // The Home tab is a StatefulWidget reached via the bottom nav, so its
  // initState re-runs on every tab switch. Without this guard each switch
  // re-fired 5 network calls and flashed the shimmer every time. We only
  // refetch if the data is stale (or the user explicitly pulls to refresh).
  DateTime? _lastHomeLoad;
  static const Duration _homeFreshFor = Duration(seconds: 60);

  bool get _homeDataFresh =>
      _lastHomeLoad != null &&
      DateTime.now().difference(_lastHomeLoad!) < _homeFreshFor;

  /// Loads everything the Home screen needs. No-op if data is still fresh,
  /// unless [force] is set (pull-to-refresh).
  Future<void> loadHomeData({bool force = false}) async {
    if (!force && _homeDataFresh && latestForm.isNotEmpty) return;
    _lastHomeLoad = DateTime.now();
    final List<Future<dynamic>> tasks = <Future<dynamic>>[
      getLatestForm(),
      getMyStory(),
      getWorkingDays(),
      getStorySteps(),
      getProfile(),
    ];
    await Future.wait(tasks);
  }

  // ================================> All Tags  ==============================>


  RxBool getAllTagsLoading = false.obs;
  RxList<AllTagsModel> allTags = <AllTagsModel>[].obs;
  getAllTags()async{
    getAllTagsLoading(true);
    var response = await ApiClient.getData(ApiConstants.getAllTagsEndPoint);
    if(response.statusCode == 200){
      allTags.value = List<AllTagsModel>.from(response.body["data"]["attributes"]["tags"].
      map((x)=> AllTagsModel.fromJson(x)));


      getAllTagsLoading(false);
    }else{
      getAllTagsLoading(false);
    }
  }

  // ================================> Update Tags  ==============================>

  var loading = false.obs;

  Future<void> updateTag(String id,List<String> tags)
  async {
    loading.value = true;
    var body = {
      "tag": tags,
    };

    var response = await ApiClient.patchData(
      ApiConstants.updateTagEndPoint(id),
      body: body,
    );

    print("===========response body : ${response.body} \nand status code : ${response.statusCode}");

    if (response.statusCode == 200 ) {
      update();
      ToastMessageHelper.showToastMessage("${response.body["message"]}",title: 'Success');
    } else {
      ToastMessageHelper.showToastMessage("${response.body["message"]}", title: "fail");
    }

    loading.value = false;
  }



/// ================================> Upload Story  ==============================>


  RxBool uploadStoryLoading = false.obs;

  bool _isVideoFile(String path) {
    final p = path.toLowerCase();
    return p.endsWith('.mp4') ||
        p.endsWith('.mov') ||
        p.endsWith('.mkv') ||
        p.endsWith('.avi') ||
        p.endsWith('.webm') ||
        p.endsWith('.m4v') ||
        p.endsWith('.3gp');
  }

  Future<File?> _generateVideoThumbnail(String videoPath) async {
    try {
      final dir = await getTemporaryDirectory();
      final outPath = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: dir.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 512,
        quality: 75,
      );
      if (outPath == null) return null;
      final file = File(outPath);
      return await file.exists() ? file : null;
    } catch (e) {
      print('Thumbnail generation failed: $e');
      return null;
    }
  }

  uploadStory({
     required List<File> images,
        String? caption,
        File? thumbnail,
        String? description,
        String? tags,
        required BuildContext context}) async {
    // Validate required input up front. Without this the button would fire an
    // empty request and — on the backend's silent rejection — look completely
    // unresponsive to the user (App Store 2.1(a) "post button unresponsive").
    if (images.isEmpty) {
      ToastMessageHelper.showToastMessage(
          "Please add a photo, video or audio before posting",
          title: "Nothing to post");
      return;
    }
    if ((caption ?? '').trim().isEmpty) {
      ToastMessageHelper.showToastMessage(
          "Please add a title/caption for your story",
          title: "Title required");
      return;
    }

    uploadStoryLoading(true);
    try {
      List<MultipartBody> multipartBody = [];
      for (var photos in images) {
        multipartBody.add(MultipartBody("files", photos));
      }

      // Auto-generate a thumbnail from the first video file if the caller
      // didn't provide one. Backend / list UI expect a thumbnail image to
      // render the card preview — videos uploaded without one show a blank tile.
      File? effectiveThumbnail = thumbnail;
      if (effectiveThumbnail == null && images.isNotEmpty) {
        final firstVideo = images.firstWhere(
          (f) => _isVideoFile(f.path),
          orElse: () => File(''),
        );
        if (firstVideo.path.isNotEmpty) {
          effectiveThumbnail = await _generateVideoThumbnail(firstVideo.path);
        }
      }
      if (effectiveThumbnail != null) {
        multipartBody.add(MultipartBody("thumbnail", effectiveThumbnail));
      }

      var body = {
        "caption": "$caption",
        "description": "$description",
        "tags": "$tags",
      };
      var response = await ApiClient.postMultipartData(
          ApiConstants.uploadEndPoint, body,
          multipartBody: multipartBody);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastMessageHelper.showToastMessage("${response.body["message"]}",
            title: "Success");
        context.pushNamed(AppRoutes.bottomNavbarScreen);
        update();
      } else {
        // Surface the real failure instead of silently doing nothing, so the
        // button never appears "dead" after a tap.
        final msg = response.body is Map
            ? (response.body["message"]?.toString() ??
                response.statusText ??
                'Could not post your story. Please try again.')
            : (response.statusText ??
                'Could not post your story. Please try again.');
        ToastMessageHelper.showToastMessage(msg, title: "Post failed");
      }
    } catch (e) {
      ToastMessageHelper.showToastMessage(
          "Something went wrong while posting: $e",
          title: "Post failed");
    } finally {
      // Always release the button, even on error — otherwise the spinner
      // stays and the button is permanently disabled.
      uploadStoryLoading(false);
    }
  }



/// ================================> Latest form   ==============================>


  RxBool getLatestFormLoading = false.obs;
  RxList<LatestFormModel> latestForm = <LatestFormModel>[].obs;
  getLatestForm()async{
    getLatestFormLoading(true);
    var response = await ApiClient.getData(ApiConstants.getLatestFormEndPoint);
    if(response.statusCode == 200){
      latestForm.value = List<LatestFormModel>.from(response.body["data"]["attributes"]["data"].
      map((x)=> LatestFormModel.fromJson(x)));
      getLatestFormLoading(false);
    }else{
      getLatestFormLoading(false);
    }
  }



  /// ================================> My Stories   ==============================>

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
    print("**********************print here**************");
  }
  RxBool getMyStoryLoading = false.obs;
  RxList<MyStoryModel> myStory = <MyStoryModel>[].obs;
  getMyStory()async{
    if(page.value == 1){
      loading(true);
    }
    getMyStoryLoading(true);
    var response = await ApiClient.getData(ApiConstants.getMyStoryEndPoint("${page.value}"));
    if(response.statusCode == 200){

      // totalPages = jsonDecode(response.body['pagination']['totalPages'].toString()) ?? 0;
      // currentPage = jsonDecode(response.body['pagination']['currentPage'].toString()) ?? 0;
      // total = jsonDecode(response.body['pagination']['total'].toString()) ?? 0;

      myStory.value = List<MyStoryModel>.from(response.body["data"]["attributes"]["data"].
      map((x)=> MyStoryModel.fromJson(x)));

      getMyStoryLoading(false);
    }else{
      getMyStoryLoading(false);
    }
  }


  /// ================================> Working Days   ==============================>


  RxBool getWorkingLoading = false.obs;
  RxList<WorkingDaysModel> workingDays = <WorkingDaysModel>[].obs;
  getWorkingDays()async{
    getWorkingLoading(true);
    var response = await ApiClient.getData(ApiConstants.getWorkingDaysEndPoint);
    if(response.statusCode == 200){
      workingDays.value = List<WorkingDaysModel>.from(response.body["data"]["attributes"]["data"].
      map((x)=> WorkingDaysModel.fromJson(x)));
      update();
      getWorkingLoading(false);
    }else{
      getWorkingLoading(false);
    }
  }


  /// ================================> Story   ==============================>


  RxBool getStoryStepsLoading = false.obs;
  RxList<StoryStepsModel> storySteps = <StoryStepsModel>[].obs;
  getStorySteps()async{
    getStoryStepsLoading(true);
    var response = await ApiClient.getData(ApiConstants.getStoryStepsEndPoint);
    if(response.statusCode == 200){
      storySteps.value = List<StoryStepsModel>.from(response.body["data"]["attributes"].
      map((x)=> StoryStepsModel.fromJson(x)));
      update();
      getStoryStepsLoading(false);
    }else{
      getStoryStepsLoading(false);
    }
  }

  /// ================================> Story Single  ==============================>


  RxBool getStorySingleLoading = false.obs;
  Rx<StorySingleModel> storySingle = StorySingleModel().obs;

  // Client-side cache so reopening a story is INSTANT instead of hitting
  // the network every time (that's why "the same content took the same
  // time to load" — there was no client cache and it was even refetched
  // on every widget rebuild).
  final Map<String, StorySingleModel> _storyCache = {};

  getStorySingle({String? id}) async {
    if (id == null || id.isEmpty) {
      getStorySingleLoading(false);
      return;
    }

    // Cache hit → show immediately, no spinner, no network round-trip.
    final cached = _storyCache[id];
    if (cached != null) {
      storySingle.value = cached;
      getStorySingleLoading(false);
      update();
      return;
    }

    getStorySingleLoading(true);
    var response =
        await ApiClient.getData(ApiConstants.getStorySingleEndPoint(id));
    if (response.statusCode == 200) {
      final model =
          StorySingleModel.fromJson(response.body['data']['attributes']);
      _storyCache[id] = model;
      storySingle.value = model;
      update();
      getStorySingleLoading(false);
    } else {
      getStorySingleLoading(false);
    }
  }


  /// ================================> Share  ==============================>

  var shareLoading = false.obs;
  share(String storyId) async {

    var body = {
      'story':storyId,
    };
    shareLoading(true);
    var response = await ApiClient.postData(
        ApiConstants.shareEndPoint,
        jsonEncode(body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.showToastMessage("${response.body["message"]}");
      update();
    } else {
      shareLoading(false);
    }
    shareLoading(false);

  }





  /// ================================>  Profile ==============================>

  RxBool getProfileLoading = false.obs;
  Rx<UserProfileModel> profile = UserProfileModel().obs;
  getProfile() async {
    getProfileLoading(true);
    var response = await ApiClient.getData(ApiConstants.userProfileEndPoint);
    if (response.statusCode == 200) {
      profile.value = UserProfileModel.fromJson(response.body['data']['attributes']);
      update();
      getProfileLoading(false);
    } else if (response.statusCode == 404) {
      getProfileLoading(false);
    }
  }


  /// ================================> Update Profile ==============================>


  var updateProfileLoading = false.obs;

  updateProfile({
    String? aboutself,
    String? nickname,
    gender,
    dateofBirth,
     File? file,
    required BuildContext context

  }) async {

    updateProfileLoading(true);

    List<MultipartBody> multipartBody = [];
    if (file != null) {
      multipartBody.add(MultipartBody("file", file));
    }



    var body = {
      "aboutself": "$aboutself",
      "nickname": "$nickname",
      "gender": "$gender",
      if (dateofBirth != null) "dateofBirth": "$dateofBirth",
    };


    var response = await ApiClient.patchMultipartData(
      ApiConstants.userUpdateProfileEndPoint,
      body,
        multipartBody: multipartBody
    );



    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.showToastMessage("${response.body["message"]}");
      await getProfile();

      updateProfileLoading(false);
      context.pop();
      update();
    }

    else {
      updateProfileLoading(false);
      final message = response.body["message"] ?? "Failed to update profile.";
      ToastMessageHelper.showToastMessage(message, title: 'attention');
    }
  }


  ///=============== Delete Account ================<>


  var deleteLoading = false.obs;
  deleteProfile(BuildContext context) async {

    deleteLoading(true);
    var response = await ApiClient.deleteData(
        ApiConstants.deleteProfileEndPoint);
    if (response.statusCode == 200) {
      ToastMessageHelper.showToastMessage('Account Delete Successfully');
      context.pushNamed(AppRoutes.logInScreen);
    } else {
      deleteLoading(false);
    }

  }


  /// ================================> Feedback  ==============================>


  var feedbackLoading = false.obs;

  feedback({
    String? comment,
    File? file,
    required BuildContext context

  }) async {

    feedbackLoading(true);

    List<MultipartBody> multipartBody = [];
    if (file != null) {
      multipartBody.add(MultipartBody("file", file));
    }



    var body = {
      "comment": "$comment",
    };


    feedbackLoading(true);

    var response = await ApiClient.postMultipartData(
        ApiConstants.feedbackEndPoint,
        body,
        multipartBody: multipartBody
    );



    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.showToastMessage("${response.body["message"]}");


      feedbackLoading(false);
      context.pop();
      update();
    } else {
      feedbackLoading(false);
      ToastMessageHelper.showToastMessage("Failed feedback data.");
    }
  }





















  /// Store controllers for each story
  Map<String, VideoPlayerController> videoControllers = {};
  Map<String, bool> playStates = <String, bool>{}.obs;
  Map<String, bool> isInitializedStates = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void setVideoPath(String storyId, String videoUrl) {
    // Dispose previous controller if exists
    if (videoControllers.containsKey(storyId)) {
      videoControllers[storyId]?.dispose();
    }

    final uri = MediaUrlHelper.toUri(videoUrl);
    if (uri == null) {
      isInitializedStates[storyId] = false;
      update();
      return;
    }

    final controller = VideoPlayerController.networkUrl(uri);
    videoControllers[storyId] = controller;
    controller
        .initialize()
        .timeout(const Duration(seconds: 25))
        .then((_) {
      isInitializedStates[storyId] = true;
      update();
    }).catchError((Object e) {
      // Without this the future threw an unhandled async error and the tile
      // was stuck "loading" for good (App Review 2.1(a)).
      isInitializedStates[storyId] = false;
      update();
      // ignore: avoid_print
      print('Error initializing story video: $e');
    });
  }

  void togglePlayPause(String storyId) {
    if (!videoControllers.containsKey(storyId)) return;

    if (playStates[storyId] == true) {
      videoControllers[storyId]?.pause();
    } else {
      videoControllers[storyId]?.play();
    }
    playStates[storyId] = !(playStates[storyId] ?? false);
  }

  void disposeController(String storyId) {
    if (videoControllers.containsKey(storyId)) {
      videoControllers[storyId]?.dispose();
      videoControllers.remove(storyId);
      playStates.remove(storyId);
      isInitializedStates.remove(storyId);
    }
  }

  @override
  void onClose() {
    // Dispose all controllers
    videoControllers.values.forEach((controller) => controller.dispose());
    videoControllers.clear();
    super.onClose();
  }


}