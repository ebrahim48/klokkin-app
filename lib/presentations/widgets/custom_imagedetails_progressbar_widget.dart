import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:intl/intl.dart';
import '../../controllers/audio_book_controller.dart';
import '../../controllers/audio_controller.dart';
import '../../core/constants/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import '../../../services/download_service.dart';

class CustomImageDetailsProgressBar extends StatefulWidget {
  const CustomImageDetailsProgressBar({super.key});

  @override
  State<CustomImageDetailsProgressBar> createState() => _CustomImageDetailsProgressBarState();
}

class _CustomImageDetailsProgressBarState extends State<CustomImageDetailsProgressBar> {
  final AudioBookController controllers = Get.put(AudioBookController());

  @override
  void initState() {
    super.initState();
    // Move API call outside of build cycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controllers.libraryStoryData.isEmpty) {
        controllers.getLibraryStoryData();
      }
    });
  }

  Future<void> _downloadCurrentMedia() async {
    try {
      if (controllers.libraryStoryData.isNotEmpty) {
        final currentStory = controllers.libraryStoryData.first;
        final mediaUrl = currentStory.mediaUrl?.isNotEmpty == true
            ? currentStory.mediaUrl!.first
            : null;

        if (mediaUrl != null) {
          Get.snackbar(
            "Downloading...",
            "Please wait while we download your media",
            snackPosition: SnackPosition.BOTTOM,
          );

          bool success = await DownloadService().downloadMedia(
            mediaUrl,
            title: currentStory.caption ?? 'Media',
            subtitle: currentStory.description ?? 'Downloaded from Klokkin App',
            meta: currentStory.duration ?? 'Media',
            hashtags: currentStory.tags?.toString() ?? '',
          );

          if (success) {
            Get.snackbar(
              "Success!",
              "Media downloaded successfully",
              backgroundColor: Colors.green,
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            Get.snackbar(
              "Download Failed",
              "Could not save media to device",
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        "Download Error",
        e.toString(),
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioController());

    return Obx(() {
      // Check if data is empty
      if (controllers.libraryStoryData.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final story = controllers.libraryStoryData.first;

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 28.h),
          CustomText(
            textAlign: TextAlign.start,
            text: story.caption ?? 'N/A',
            color: AppColors.textColorFFFFFF,
            fontsize: 24.sp,
            fontWeight: FontWeight.w500,
            maxline: 2,
          ),
          SizedBox(height: 17.h),
          CustomText(
            textAlign: TextAlign.start,
            text: story.description ?? 'N/A',
            color: AppColors.textColorFFFFFF,
            fontsize: 16.sp,
            fontWeight: FontWeight.w400,
            maxline: 10,
          ),
          SizedBox(height: 17.h),
          CustomText(
            textAlign: TextAlign.start,
            text: story.createdAt != null
                ? 'Post: ${DateFormat("dd MMM yyyy").format(story.createdAt!)}'
                : 'Post: --',
            color: AppColors.textColorFFFFFF,
            fontsize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 17.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 4.h,
                  children: (story.tags ?? []).map((tag) {
                    return GestureDetector(
                      onTap: () {
                        print("$tag tapped");
                      },
                      child: CustomText(
                        text: tag,
                        color: AppColors.textColor2165DF,
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: _downloadCurrentMedia,
                child: SvgPicture.asset(
                  "assets/icons/downloadSimple.svg",
                  width: 24.w,
                  height: 24.h,
                  color: AppColors.primaryColorC79235,
                ),
              ),
            ],
          ),
          SizedBox(height: 100.h),
        ],
      );
    });
  }
}