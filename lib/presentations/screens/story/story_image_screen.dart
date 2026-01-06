import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../core/config/app_routes/app_routes.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/image_story_list_widget.dart';
import '../../widgets/image_story_widget.dart';

class StoryImageScreen extends StatefulWidget {
  const StoryImageScreen({super.key});

  @override
  State<StoryImageScreen> createState() => _StoryImageScreenState();
}

class _StoryImageScreenState extends State<StoryImageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AudioBookController controller = Get.put(AudioBookController());
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
      // Load more image stories if available
      if (controller.canLoadMoreImage && !controller.loadingMoreImage.value) {
        print("📥 Triggering load more image stories...");
        controller.loadMoreImageStories();
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
        // Add image counter in app bar
        actions: [
          Obx(() {
            if (controller.imageMeta.value != null) {
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Center(
                  child: CustomText(
                    text: "${controller.imageStories.length} / ${controller.imageMeta.value?.total ?? 0}",
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
              controller.imageStories.isEmpty) {
            return const Center(child: CustomLoader());
          }

          if (controller.imageStories.isEmpty) {
            return Center(
              child: CustomText(
                text: "No Image Stories Available",
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
                    itemCount: controller.imageStories.length,
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final libraryData = controller.imageStories[index];
                      return ImageStoryCard(
                        title: libraryData.caption ?? 'N/A',
                        caption: libraryData.description ?? 'N/A',
                        imagePath: libraryData.mediaUrl != null && libraryData.mediaUrl!.isNotEmpty
                            ? libraryData.mediaUrl!.first
                            : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                        createdAt: libraryData.createdAt,
                        duration: libraryData.duration,
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.storyImageDetailsScreen,
                            extra: {
                              "id": libraryData.id ?? "",
                              "caption": libraryData.caption ?? "",
                              "description": libraryData.description ?? "",
                              "imagePath": libraryData.mediaUrl != null && libraryData.mediaUrl!.isNotEmpty
                                  ? libraryData.mediaUrl!.first
                                  : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

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
                  itemCount: controller.imageStories.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final libraryData = controller.imageStories[index];
                    return ImageListCard(
                      title: libraryData.caption ?? 'N/A',
                      subtitle: libraryData.description ?? 'N/A',
                      createdAt: libraryData.createdAt,
                      duration: libraryData.duration,
                      hashtags: (libraryData.tags is List)
                          ? (libraryData.tags as List).join(", ")
                          : (libraryData.tags?.toString() ?? 'N/A'),
                      imagePath: libraryData.mediaUrl != null && libraryData.mediaUrl!.isNotEmpty
                          ? libraryData.mediaUrl!.first
                          : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                      onTap: () {
                        context.pushNamed(
                          AppRoutes.storyImageDetailsScreen,
                          extra: {
                            "id": libraryData.id ?? "",
                            "caption": libraryData.caption ?? "",
                            "description": libraryData.description ?? "",
                            "imagePath": libraryData.mediaUrl != null && libraryData.mediaUrl!.isNotEmpty
                                ? libraryData.mediaUrl!.first
                                : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                          },
                        );
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
      if (controller.loadingMoreImage.value) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: const Center(child: CustomLoader()),
        );
      }

      // Show "No more images" if at the end
      if (controller.imageStories.isNotEmpty && !controller.canLoadMoreImage) {
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
                  text: "All image stories loaded",
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