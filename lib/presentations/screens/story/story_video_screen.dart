import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../controllers/work_controller.dart';
import '../../../core/config/app_routes/app_routes.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/video_list_widget.dart';
import '../../widgets/video_story_list_widget.dart';

class StoryVideoScreen extends StatefulWidget {
  const StoryVideoScreen({super.key});

  @override
  State<StoryVideoScreen> createState() => _StoryVideoScreenState();
}

class _StoryVideoScreenState extends State<StoryVideoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AudioBookController controller = Get.put(AudioBookController());
  WorkCardController workCardController = Get.put(WorkCardController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getLibraryStoryData();
    });

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Check if scrolled near bottom
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more video stories if available
      if (controller.canLoadMoreVideo && !controller.loadingMoreVideo.value) {
        print("📥 Triggering load more video stories...");
        controller.loadMoreVideoStories();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgColor20272E,
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        // Add video counter in app bar
        actions: [
          Obx(() {
            if (controller.videoMeta.value != null) {
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Center(
                  child: CustomText(
                    text: "${controller.videoStories.length} / ${controller.videoMeta.value?.total ?? 0}",
                    color: AppColors.textColor919191,
                    fontsize: 14.sp,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.getLibraryStoryLoading.value &&
              controller.videoStories.isEmpty) {
            return const Center(child: CustomLoader());
          }

          if (controller.videoStories.isEmpty) {
            return Center(
              child: CustomText(
                text: "No Video Stories Available",
                textAlign: TextAlign.center,
                color: AppColors.textColorC2C2C2,
              ),
            );
          }

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Horizontal List
                SizedBox(
                  height: 250.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: controller.videoStories.length,
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final libraryData = controller.videoStories[index];
                      return VideoStoryCard(
                        title: libraryData.caption ?? 'N/A',
                        imagePath: libraryData.thumbnail ??
                            libraryData.mediaUrl?.first ??
                            "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                        createdAt: libraryData.createdAt,
                        duration: libraryData.duration,
                        videoPath: libraryData.mediaUrl?.first ?? "",
                        onTap: () {
                          if (libraryData.mediaUrl != null &&
                              libraryData.mediaUrl!.isNotEmpty) {
                            context.pushNamed(
                              AppRoutes.storyVideoDetailsScreen,
                              extra: {
                                "videoUrl": libraryData.mediaUrl!.first,
                                "storyId": libraryData.id ?? "",
                                "title": libraryData.caption ?? 'N/A',
                                "duration": libraryData.duration ?? 'N/A',
                                "imagePath": libraryData.thumbnail ??
                                    libraryData.mediaUrl!.first,
                                "description": libraryData.description ?? 'N/A',
                                "tags": libraryData.tags ?? [],
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 12.h),

                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 15.h),
                  child: Divider(
                    color: AppColors.secondary836531,
                    height: 0.4.h,
                    thickness: 0.6,
                  ),
                ),

                SizedBox(height: 16.h),

                /// Bottom Vertical List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: controller.videoStories.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final libraryData = controller.videoStories[index];
                    return VideoListCard(
                      title: libraryData.caption ?? 'N/A',
                      subtitle: libraryData.description ?? 'N/A',
                      createdAt: libraryData.createdAt,
                      duration: libraryData.duration,
                      hashtags: (libraryData.tags ?? []).join(", "),
                      imagePath: libraryData.thumbnail ??
                          libraryData.mediaUrl?.first ??
                          "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                      videoPath: libraryData.mediaUrl?.first ?? "",
                      onTap: () {
                        if (libraryData.mediaUrl != null &&
                            libraryData.mediaUrl!.isNotEmpty) {
                          context.pushNamed(
                            AppRoutes.storyVideoDetailsScreen,
                            extra: {
                              "videoUrl": libraryData.mediaUrl!.first,
                              "storyId": libraryData.id ?? "",
                              "title": libraryData.caption ?? 'N/A',
                              "duration": libraryData.duration ?? 'N/A',
                              "imagePath": libraryData.thumbnail ??
                                  libraryData.mediaUrl!.first,
                              "description": libraryData.description ?? 'N/A',
                              "tags": libraryData.tags ?? [],
                            },
                          );
                        }
                      },
                    );
                  },
                ),

                /// Loading / End Indicator
                _buildBottomWidget(),

                SizedBox(height: 10.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Bottom widget - shows loading or end message
  Widget _buildBottomWidget() {
    return Obx(() {
      // Show loading indicator when loading more
      if (controller.loadingMoreVideo.value) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: const Center(child: CustomLoader()),
        );
      }

      // Show "No more videos" if at the end
      if (controller.videoStories.isNotEmpty && !controller.canLoadMoreVideo) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primaryColorC79235,
                  size: 32.sp,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: "You've reached the end",
                  color: AppColors.textColor919191,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: "All video stories loaded",
                  color: AppColors.textColor6B6B6B,
                  fontsize: 12.sp,
                ),
              ],
            ),
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }
}