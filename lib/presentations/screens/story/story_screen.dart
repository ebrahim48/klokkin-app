import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../../models/story_libray_data_model.dart';
import '../../widgets/audio_book_card.dart';
import '../../widgets/category_widget.dart';
import '../../widgets/custom_loader.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final AudioBookController controller = Get.put(AudioBookController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    // Check if scrolled to bottom
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // Load more if available
      if (controller.canLoadMoreAudio && !controller.loadingMoreAudio.value) {
        controller.loadMoreAudioStories();
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
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              Center(child: Assets.icons.storyIcon.svg()),
              SizedBox(height: 7.h),
              Align(
                alignment: Alignment.center,
                child: CustomText(
                  text: 'Story Spark Studio',
                  color: AppColors.textColorFFFFFF,
                  fontsize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomText(
                  textAlign: TextAlign.center,
                  text: 'Every story holds a world within it, waiting to be discovered. Through stories, we live a thousand lives in one lifetime.',
                  color: AppColors.textColor919191,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w500,
                  maxline: 5,
                ),
              ),

              /// ==============================> Categories ===================================>
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomText(
                  textAlign: TextAlign.start,
                  text: 'Categories of stories',
                  color: AppColors.buttonColorE8A533,
                  fontsize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              /// =====================================> Categories Scroll =====================================>
              SizedBox(height: 11.h),
              Obx(() {
                if (controller.getLibraryStoryLoading.value) {
                  return const Center(child: CustomLoader());
                }
                if (controller.libraryStoryData.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: "Library Story Data Unavailable",
                      textAlign: TextAlign.center,
                      color: AppColors.textColorC2C2C2,
                    ),
                  );
                }
                return SizedBox(
                  height: 120.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: 3,
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final types = ["audio", "video", "image"];
                      final type = types[index];

                      final subtitleText = () {
                        switch (type) {
                          case "audio":
                            return "${controller.audioMeta.value?.total ?? 0} Stories";
                          case "video":
                            return "${controller.videoMeta.value?.total ?? 0} Stories";
                          case "image":
                            return "${controller.imageMeta.value?.total ?? 0} Stories";
                          default:
                            return "0 Stories";
                        }
                      }();

                      final imagePath = () {
                        switch (type) {
                          case "audio":
                            return "assets/images/audioimage.png";
                          case "video":
                            return "assets/images/videoimage.png";
                          case "image":
                            return "assets/images/imageworld.png";
                          default:
                            return "assets/images/default.png";
                        }
                      }();

                      return CategoryCard(
                        title: type.toUpperCase(),
                        subtitle: subtitleText,
                        imagePath: imagePath,
                        onTap: () {
                          if (type == "audio") {
                            context.pushNamed(AppRoutes.storyAudioBookScreen);
                          } else if (type == "video") {
                            context.pushNamed(AppRoutes.storyVideoScreen);
                          } else if (type == "image") {
                            context.pushNamed(AppRoutes.storyImageScreen);
                          }
                        },
                      );
                    },
                  ),
                );
              }),
              SizedBox(height: 27.h),

              /// =====================================> Audio Book Section =====================================>
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Audio Book',
                      fontsize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.buttonColorE8A533,
                    ),
                    Obx(() {
                      if (controller.audioMeta.value != null) {
                        return CustomText(
                          text: "${controller.audioStories.length} / ${controller.audioMeta.value?.total ?? 0}",
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor919191,
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
              SizedBox(height: 9.h),

              /// Audio Book List
              Obx(() {
                if (controller.audioStories.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: "Audio Book Data Unavailable",
                      textAlign: TextAlign.center,
                      color: AppColors.textColorC2C2C2,
                    ),
                  );
                }

                return Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: controller.audioStories.length,
                      separatorBuilder: (context, index) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final audioBook = controller.audioStories[index];

                        // Find original index in libraryStoryData
                        final originalIndex = controller.libraryStoryData.indexOf(audioBook);

                        return Obx(() {
                          final isCurrentPlaying = controller.currentPlayingIndex.value == originalIndex;

                          return AudioBookCard(
                            title: audioBook.caption ?? 'N/A',
                            subtitle: audioBook.duration ?? 'N/A',
                            currentTime: isCurrentPlaying
                                ? controller.formatDuration(controller.currentPosition.value)
                                : null,
                            imagePath: audioBook.thumbnail ??
                                "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                            isPlaying: isCurrentPlaying && controller.isPlaying.value,
                            onPlayPause: () {
                              final audioUrl = audioBook.mediaUrl != null &&
                                  audioBook.mediaUrl!.isNotEmpty
                                  ? audioBook.mediaUrl!.first
                                  : "";

                              if (audioUrl.isNotEmpty) {
                                controller.toggleAudio(originalIndex, audioUrl);
                              }
                            },
                            onTap: () {
                              context.pushNamed(
                                AppRoutes.storyAudioScreen,
                                extra: {
                                  "caption": audioBook.caption ?? "",
                                  "duration": audioBook.duration ?? "",
                                  "imagePath": audioBook.thumbnail ??
                                      "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                                },
                              );
                            },
                          );
                        });
                      },
                    ),

                    /// Loading More Indicator
                    Obx(() {
                      if (controller.loadingMoreAudio.value) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: const Center(child: CustomLoader()),
                        );
                      }

                      // Show "Load More" button if there are more pages
                      if (controller.canLoadMoreAudio) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                controller.loadMoreAudioStories();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.primaryColorC79235,
                                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: CustomText(
                                text: "Load More",
                                color: Colors.white,
                                fontsize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }

                      // Show "No more stories" if at the end
                      if (controller.audioStories.isNotEmpty && !controller.canLoadMoreAudio) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Center(
                            child: CustomText(
                              text: "No more audio stories",
                              color: AppColors.textColor919191,
                              fontsize: 12.sp,
                            ),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    }),
                  ],
                );
              }),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}