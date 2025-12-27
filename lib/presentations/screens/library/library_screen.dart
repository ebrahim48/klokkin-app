import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/work_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/border_button.dart';
import '../../widgets/custom_network_image.dart';

class LibraryScreen extends StatefulWidget {
  final String videoPath;
  const LibraryScreen({super.key, required this.videoPath});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  HomeController homeController = Get.put(HomeController());
  WorkCardController get workController => Get.find<WorkCardController>();

  @override
  void initState() {
    super.initState();

    // Initialize or get existing controller
    if (!Get.isRegistered<WorkCardController>()) {
      Get.put(WorkCardController());
    }

    homeController.getWorkingDays();
    // homeController.getMyStory();

    // Initialize videos after data loads
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _initializeVideos();
      }
    });
  }

  void _initializeVideos() async {
    if (homeController.workingDays.isEmpty) return;

    // Check if controller exists and is not disposed
    if (!Get.isRegistered<WorkCardController>()) {
      print("⚠️ WorkCardController not registered");
      return;
    }

    final controller = Get.find<WorkCardController>();

    // Initialize video players for positions that need video
    // Positions: 0, 2, 3, 4, 6
    final positions = [0, 2, 3, 4, 6];

    for (var pos in positions) {
      if (pos < homeController.workingDays.length) {
        final item = homeController.workingDays[pos];
        if (item.type == 'video' &&
            item.mediaUrl != null &&
            item.mediaUrl!.isNotEmpty) {
          print("🎥 Initializing video[$pos]: ${item.mediaUrl!.first}");
          await controller.setVideoPath(pos, item.mediaUrl!.first);
          // Add small delay between initializations
          await Future.delayed(const Duration(milliseconds: 200));
        }
      }
    }
  }

  // Get media URL from workingDays
  String _getWorkingDaysMedia(int index) {
    if (index >= homeController.workingDays.length) {
      return "https://via.placeholder.com/400x300.png?text=No+Data";
    }

    final item = homeController.workingDays[index];

    // For video items, use thumbnail
    if (item.type == 'video' && item.thumbnail != null && item.thumbnail!.isNotEmpty) {
      return item.thumbnail!;
    }

    // For image items, use mediaUrl
    if (item.mediaUrl == null || item.mediaUrl!.isEmpty) {
      return "https://via.placeholder.com/400x300.png?text=No+Media";
    }

    return item.mediaUrl!.first;
  }

  // Get media URL from myStory
  String _getMyStoryMedia(int index) {
    if (index >= homeController.myStory.length) {
      return "https://via.placeholder.com/400x300.png?text=No+Story";
    }

    final item = homeController.myStory[index];

    if (item.mediaUrl == null || item.mediaUrl!.isEmpty) {
      return "https://via.placeholder.com/400x300.png?text=No+Media";
    }

    return item.mediaUrl!.first;
  }

  // Check if workingDays item is video
  bool _isWorkingDaysVideo(int index) {
    if (homeController.workingDays.length > index) {
      return homeController.workingDays[index].type == 'video';
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: CustomText(
          text: "Library",
          color: AppColors.textColor987433,
          fontsize: 20.sp,
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (homeController.getWorkingLoading.value || homeController.getMyStoryLoading.value) {
            return _buildLoadingState();
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // /// Search Section
                // SizedBox(height: 10.h),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 16.w),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Container(
                //           height: 32.h,
                //           decoration: BoxDecoration(
                //             color: AppColors.bgColor,
                //             borderRadius: BorderRadius.circular(20.r),
                //             border: Border.all(
                //               color: const Color(0xFFDF9E2F),
                //               width: 1,
                //             ),
                //           ),
                //           child: TextFormField(
                //             controller: _searchController,
                //             style: const TextStyle(color: AppColors.textColorFFFFFF),
                //             decoration: InputDecoration(
                //               hintText: 'Search',
                //               hintStyle: const TextStyle(color: AppColors.textColorFFFFFF),
                //               contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                //               prefixIcon: Padding(
                //                 padding: EdgeInsets.all(6.w),
                //                 child: Assets.icons.search.svg(width: 16.w, height: 16.h),
                //               ),
                //               border: InputBorder.none,
                //               enabledBorder: InputBorder.none,
                //               focusedBorder: InputBorder.none,
                //             ),
                //           ),
                //         ),
                //       ),
                //       // SizedBox(width: 57.w),
                //       // SizedBox(
                //       //   width: 35.w,
                //       //   child: Assets.icons.filter.svg(width: 32.w, height: 32.h),
                //       // ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 18.h),

                /// Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      BorderButton(
                        title: "Download",
                        onPressed: () {
                          context.pushNamed(AppRoutes.downloadScreen);
                        },
                      ),
                      SizedBox(width: 12.w),
                      BorderButton(
                        title: "Bookmark",
                        onPressed: () {
                          context.pushNamed(AppRoutes.bookmarkScreen);
                        },
                      ),
                      // SizedBox(width: 70.w),
                      // SizedBox(
                      //   width: 35.w,
                      //   child: Assets.icons.dot.svg(width: 22.w, height: 22.h),
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Divider(
                    thickness: 1,
                    color: const Color(0x36D09F48),
                    height: 0.h,
                  ),
                ),

                /// Row 1: Video Player + Thumbnail
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildVideoOrThumbnail(0, 116.h),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: _buildMediaItem(_getWorkingDaysMedia(1), 116.h),
                      ),
                    ],
                  ),
                ),

                /// Row 2: Image + Video Player
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildMediaItem(_getMyStoryMedia(0), 116.h),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: _buildVideoOrThumbnail(2, 116.h),
                      ),
                    ],
                  ),
                ),

                /// Row 3: Video Player Full Width
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: _buildVideoOrThumbnail(3, 120.h),
                ),

                /// Row 4: Video Player + Thumbnail
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildVideoOrThumbnail(4, 160.h),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: _buildMediaItem(_getWorkingDaysMedia(5), 160.h),
                      ),
                    ],
                  ),
                ),

                /// Row 5: Video Player Full Width
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: _buildVideoOrThumbnail(6, 128.h),
                ),

                SizedBox(height: 21.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Build video player or thumbnail based on video type
  Widget _buildVideoOrThumbnail(int index, double height) {
    // If it's a video item, show thumbnail with video player overlay
    if (_isWorkingDaysVideo(index)) {
      return _buildVideoWithThumbnail(index, height);
    } else {
      // Regular image
      return _buildMediaItem(_getWorkingDaysMedia(index), height);
    }
  }

  // Video with thumbnail background and player overlay
  Widget _buildVideoWithThumbnail(int index, double height) {
    return GetBuilder<WorkCardController>(
      builder: (controller) {
        final isInitialized = controller.isInitialized(index);
        final isPlaying = controller.isPlaying(index);
        final videoController = controller.getController(index);

        return GestureDetector(
          onTap: () {
            // First tap will start playing, subsequent taps will toggle
            if (isInitialized) {
              controller.togglePlayPause(index);
            }
          },
          child: Container(
            height: height,
            width: double.infinity,
            child: Stack(
              children: [
                // Background: Thumbnail (visible when NOT playing)
                if (!isPlaying)
                  Positioned.fill(
                    child: _buildMediaItem(_getWorkingDaysMedia(index), height),
                  ),

                // Video Player (visible ONLY when playing)
                if (isInitialized && isPlaying && videoController != null)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        color: Colors.black,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: videoController.value.aspectRatio,
                            child: VideoPlayer(videoController),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Loading/Buffering Indicator (when video is playing but buffering)
                if (isInitialized &&
                    isPlaying &&
                    videoController != null &&
                    videoController.value.isBuffering)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDF9E2F)),
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),

                // Initializing indicator (first time load, shown over thumbnail)
                if (!isInitialized)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDF9E2F)),
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),

                // Gradient overlay for button visibility
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 60.h,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.r),
                        bottomRight: Radius.circular(8.r),
                      ),
                    ),
                  ),
                ),

                // Play/Pause Button
                Positioned(
                  bottom: 8.h,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: () {
                      if (isInitialized) {
                        print("🎬 Toggle play/pause for index $index");
                        controller.togglePlayPause(index);
                      } else {
                        print("⚠️ Video not initialized yet for index $index");
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.7),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10.r),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 24.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Video duration/position indicator (only when playing)
                if (isInitialized && isPlaying && videoController != null)
                  Positioned(
                    bottom: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: videoController,
                        builder: (context, VideoPlayerValue value, child) {
                          final position = value.position;
                          final duration = value.duration;
                          return Text(
                            '${_formatDuration(position)} / ${_formatDuration(duration)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

// Helper method to format duration
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }


  // Media Item Widget
  Widget _buildMediaItem(String imageUrl, double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
      ),
      clipBehavior: Clip.hardEdge,
      child: CustomNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: height,
      ),
    );
  }

  // Loading shimmer state
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[600]!,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[600]!,
            child: Container(
              width: 150,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (Get.isRegistered<WorkCardController>()) {
      final controller = Get.find<WorkCardController>();
      controller.pauseAll();
    }

    super.dispose();
  }



}