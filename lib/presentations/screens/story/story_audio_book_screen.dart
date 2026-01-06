import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../core/config/app_routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/story_libray_data_model.dart';
import '../../widgets/audio_book_card.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/custom_text.dart';

class StoryAudioBookScreen extends StatefulWidget {
  const StoryAudioBookScreen({super.key});

  @override
  State<StoryAudioBookScreen> createState() => _StoryAudioBookScreenState();
}

class _StoryAudioBookScreenState extends State<StoryAudioBookScreen> {
  final AudioBookController controller = Get.put(AudioBookController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getLibraryStoryData();
    });

    // Add scroll listener for infinite scroll
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Check if scrolled near bottom (200px before end)
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more if available and not already loading
      if (controller.canLoadMoreAudio && !controller.loadingMoreAudio.value) {
        print("📥 Triggering load more audio stories...");
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
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header with counter
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
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
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor919191,
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),

            /// Audio Book List
            Expanded(
              child: Obx(() {
                if (controller.getLibraryStoryLoading.value &&
                    controller.audioStories.isEmpty) {
                  return const Center(child: CustomLoader());
                }

                if (controller.audioStories.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: "Audio Book Data Unavailable",
                      textAlign: TextAlign.center,
                      color: AppColors.textColorC2C2C2,
                    ),
                  );
                }

                return ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: controller.audioStories.length + 1, // +1 for loading indicator
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    // Show loading indicator at the end
                    if (index == controller.audioStories.length) {
                      return _buildBottomWidget();
                    }

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
                              "storyId": audioBook.id ?? "",
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom widget - shows loading or end message
  Widget _buildBottomWidget() {
    return Obx(() {
      // Show loading indicator when loading more
      if (controller.loadingMoreAudio.value) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: const Center(child: CustomLoader()),
        );
      }

      // Show "No more stories" if at the end and all loaded
      if (controller.audioStories.isNotEmpty && !controller.canLoadMoreAudio) {
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
                  text: "All audio stories loaded",
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