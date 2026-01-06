import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/home_controller.dart';
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

  @override
  void initState() {
    super.initState();
    homeController.getWorkingDays();
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

  // Get video URL from workingDays
  String _getWorkingDaysVideoUrl(int index) {
    if (index >= homeController.workingDays.length) {
      return "";
    }

    final item = homeController.workingDays[index];
    if (item.mediaUrl == null || item.mediaUrl!.isEmpty) {
      return "";
    }

    return item.mediaUrl!.first;
  }

  // Get title for video
  String _getVideoTitle(int index) {
    if (index >= homeController.workingDays.length) {
      return "Video";
    }
    return homeController.workingDays[index].caption ?? "Video";
  }

  // Get duration for video
  String _getVideoDuration(int index) {
    if (index >= homeController.workingDays.length) {
      return "00:00";
    }
    return homeController.workingDays[index].duration ?? "00:00";
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

                /// Row 1: Video Thumbnail + Image Thumbnail
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildVideoThumbnail(0, 116.h),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: _buildMediaItem(_getWorkingDaysMedia(1), 116.h),
                      ),
                    ],
                  ),
                ),

                /// Row 2: Image + Video Thumbnail
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildMediaItem(_getMyStoryMedia(0), 116.h),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: _buildVideoThumbnail(2, 116.h),
                      ),
                    ],
                  ),
                ),

                /// Row 3: Video Thumbnail Full Width
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: _buildVideoThumbnail(3, 120.h),
                ),

                /// Row 4: Video Thumbnail + Image Thumbnail
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildVideoThumbnail(4, 160.h),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: _buildMediaItem(_getWorkingDaysMedia(5), 160.h),
                      ),
                    ],
                  ),
                ),

                /// Row 5: Video Thumbnail Full Width
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: _buildVideoThumbnail(6, 128.h),
                ),

                SizedBox(height: 21.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Video thumbnail with play button that navigates to full screen
  Widget _buildVideoThumbnail(int index, double height) {
    // If it's a video item, show thumbnail with play button
    if (_isWorkingDaysVideo(index)) {
      final videoUrl = _getWorkingDaysVideoUrl(index);
      final thumbnailUrl = _getWorkingDaysMedia(index);
      final title = _getVideoTitle(index);
      final duration = _getVideoDuration(index);

      return GestureDetector(
        onTap: () {
          // Navigate to full screen video player
          if (videoUrl.isNotEmpty) {
            context.pushNamed(
              AppRoutes.videoPlayerScreen,
              extra: {
                "videoUrl": videoUrl,
                "title": title,
                "duration": duration,
                "thumbnail": thumbnailUrl,
              },
            );
          }
        },
        child: Container(
          height: height,
          width: double.infinity,
          child: Stack(
            children: [
              // Thumbnail Background
              Positioned.fill(
                child: _buildMediaItem(thumbnailUrl, height),
              ),

              // Dark Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),

              // Play Button - Center
              Center(
                child: Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColorC79235.withOpacity(0.95),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 30.sp,
                    color: Colors.white,
                  ),
                ),
              ),

              // Duration Badge
              Positioned(
                bottom: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    duration,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Regular image
      return _buildMediaItem(_getWorkingDaysMedia(index), height);
    }
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
    super.dispose();
  }
}