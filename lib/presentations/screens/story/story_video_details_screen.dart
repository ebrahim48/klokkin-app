import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:video_player/video_player.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/config/app_routes/app_routes.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/custom_image_details_widget.dart';
import '../../widgets/custom_video_details_widget.dart';
import '../../widgets/youtube_media_player.dart';
import '../../../core/helpers/media_url_helper.dart';

class StoryVideoDetailsScreen extends StatefulWidget {
  const StoryVideoDetailsScreen({super.key});

  @override
  State<StoryVideoDetailsScreen> createState() => _StoryVideoDetailsScreenState();
}

class _StoryVideoDetailsScreenState extends State<StoryVideoDetailsScreen> {
  HomeController homeController = Get.put(HomeController());
  AudioBookController audioBookController = Get.put(AudioBookController());

  final AudioBookController controller = Get.put(AudioBookController());

  VideoPlayerController? _videoController;
  Map? routeData;
  bool _isVideoInitialized = false;
  String? _videoError;
  String _videoUrl = '';

  // Set when the video story is a YouTube trailer — rendered with the
  // embedded YouTube player instead of VideoPlayerController.
  String? _ytUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      routeData = GoRouterState.of(context).extra as Map?;
      homeController.getProfile();

      if (routeData != null) {
        final storyId = routeData!['storyId'] ?? '';
        if (storyId.isNotEmpty) {
          homeController.getStorySingle(id: storyId);
        }

        // Initialize video player
        final videoUrl = routeData!['videoUrl'] ?? '';
        if (videoUrl.isNotEmpty) {
          if (isYoutubeUrl(videoUrl)) {
            setState(() => _ytUrl = videoUrl);
          } else {
            _videoUrl = videoUrl;
            _initializeVideo(videoUrl);
          }
        }
      }
    });
  }

  /// Loads the remote video.
  ///
  /// Guideline 2.1(a): the reviewer reported the player "loaded indefinitely".
  /// The old version swallowed initialisation errors with a bare `print`, so a
  /// bad URL / unsupported file left the spinner on screen forever. Now the
  /// URL is normalised first, initialisation is bounded by a timeout, and any
  /// failure switches to an error state with a Retry button.
  Future<void> _initializeVideo(String rawUrl) async {
    final uri = MediaUrlHelper.toUri(rawUrl);
    if (uri == null) {
      if (mounted) {
        setState(() {
          _videoError = 'This video is unavailable.';
          _isVideoInitialized = false;
        });
      }
      return;
    }

    setState(() {
      _videoError = null;
      _isVideoInitialized = false;
    });

    final oldController = _videoController;
    _videoController = null;
    await oldController?.dispose();

    final controller = VideoPlayerController.networkUrl(uri);
    _videoController = controller;

    try {
      await controller.initialize().timeout(const Duration(seconds: 25));
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _isVideoInitialized = true;
        _videoError = null;
      });
    } catch (error) {
      debugPrint('Video initialization error: $error');
      if (!mounted) return;
      setState(() {
        _isVideoInitialized = false;
        _videoError = 'This video could not be played. Please try again.';
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    routeData ??= GoRouterState.of(context).extra as Map;

    final title = routeData!['title'] ?? 'N/A';
    final duration = routeData!['duration'] ?? 'N/A';
    final description = routeData!['description'] ?? 'N/A';
    final imagePath = routeData!['imagePath'] ?? '';
    final storyId = routeData!['storyId'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.backgColor20272E,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 28.h),

              /// Profile Section
              Obx(() {
                final profile = homeController.profile.value;
                return Row(
                  children: [
                    CustomProfileImageDetailsImage(
                      imagePath: profile.profile?.avatar?.isNotEmpty == true
                          ? profile.profile!.avatar!
                          : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                    ),
                    SizedBox(width: 11.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: profile.fname ?? 'N/A',
                            color: AppColors.textColorFFFFFF,
                            fontsize: 20.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          CustomText(
                            text: 'Bangladesh',
                            color: AppColors.textColorFFFFFF,
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            TextEditingController captionController =
                            TextEditingController(text: title);
                            TextEditingController descriptionController =
                            TextEditingController(text: description);

                            return AlertDialog(
                              backgroundColor: AppColors.backgColor20272E,
                              title: CustomText(
                                text: "Edit Story",
                                color: AppColors.textColorFFFFFF,
                                fontsize: 20.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: captionController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText: "Enter caption",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.primaryColorC79235),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.primaryColorC79235),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  TextField(
                                    controller: descriptionController,
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      hintText: "Enter description",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.primaryColorC79235),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.primaryColorC79235),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: CustomText(
                                    text: "Cancel",
                                    color: Colors.grey,
                                    fontsize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Update the values
                                    await controller.updateStory(
                                      storyId,
                                      captionController.text,
                                      descriptionController.text,
                                    );

                                    // Update the local route data with new values
                                    routeData!['title'] = captionController.text;
                                    routeData!['description'] = descriptionController.text;

                                    Navigator.of(context).pop();
                                    // Optionally reload data
                                    controller.getLibraryStoryData();
                                    // Also refresh the single story data
                                    homeController.getStorySingle(id: storyId);

                                    // Show feedback
                                    Get.snackbar(
                                      "Updated",
                                      "Story updated successfully",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );
                                  },
                                  child: CustomText(
                                    text: "Save",
                                    color: AppColors.primaryColorC79235,
                                    fontsize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Assets.icons.editImage.svg(),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () => _showDeleteConfirmation(context, storyId),
                      child: Assets.icons.deleteimage.svg(),
                    ),
                  ],
                );
              }),

              SizedBox(height: 40.h),

              /// Video Player
              if (_ytUrl != null)
                YoutubeMediaPlayer(url: _ytUrl!)
              else if (_isVideoInitialized && _videoController != null)
                AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(_videoController!),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_videoController!.value.isPlaying) {
                              _videoController!.pause();
                            } else {
                              _videoController!.play();
                            }
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Center(
                            child: Icon(
                              _videoController!.value.isPlaying
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              size: 64.sp,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  height: 200.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: _videoError == null
                        ? const CircularProgressIndicator(
                            color: AppColors.primaryColorC79235,
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                color: AppColors.textColorC2C2C2,
                                size: 34.sp,
                              ),
                              SizedBox(height: 8.h),
                              CustomText(
                                text: _videoError!,
                                color: AppColors.textColorC2C2C2,
                                fontsize: 13.sp,
                                maxline: 2,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8.h),
                              TextButton(
                                onPressed: _videoUrl.isEmpty
                                    ? null
                                    : () => _initializeVideo(_videoUrl),
                                child: CustomText(
                                  text: 'Retry',
                                  color: AppColors.primaryColorC79235,
                                  fontsize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

              SizedBox(height: 16.h),

              /// Video Controls & Details.
              /// For YouTube trailers the embedded player already provides
              /// play/seek, so the file-based control bar (which would be
              /// inert without a VideoPlayerController) is replaced with a
              /// plain title/description/tags block.
              if (_ytUrl == null)
                CustomVideoDetailsProgressBar(
                  videoController: _videoController,
                  title: title,
                  duration: duration,
                  storyId: storyId,
                  description: routeData!['description'] ?? 'N/A',
                  tags: routeData!['tags'] ?? [],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      textAlign: TextAlign.start,
                      text: title,
                      color: AppColors.textColorFFFFFF,
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w600,
                      maxline: 2,
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      textAlign: TextAlign.start,
                      text: routeData!['description'] ?? 'N/A',
                      color: AppColors.textColorC2C2C2,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w400,
                      maxline: 10,
                    ),
                  ],
                ),

              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String storyId) {
    if (storyId.isEmpty) {
      Get.snackbar("Error", "Story ID not found", backgroundColor: Colors.red);
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.backgColor20272E,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          title: CustomText(
            text: "Delete Story",
            color: AppColors.textColorFFFFFF,
            fontsize: 20.sp,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          content: CustomText(
            text: "Are you sure you want to delete this story?",
            color: AppColors.textColorC2C2C2,
            fontsize: 16.sp,
            maxline: 2,
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: CustomText(
                    text: "Cancel",
                    color: Colors.grey,
                    fontsize: 16.sp,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    await audioBookController.deleteStory(storyId);
                    _showDeleteSuccess(context);
                  },
                  child: CustomText(
                    text: "Delete",
                    color: Colors.red,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showDeleteSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(dialogContext, rootNavigator: true).pop();
            context.pop();
          }
        });

        return AlertDialog(
          backgroundColor: AppColors.backgColor20272E,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 59.w,
                height: 59.h,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColorC79235,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 30.sp, color: Colors.white),
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: "Delete successfully!",
                color: AppColors.textColorFFFFFF,
                fontsize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        );
      },
    );
  }
}