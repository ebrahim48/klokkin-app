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
  final String? caption;
  final String? description;
  final DateTime? createdAt;
  final List<String>? tags;
  final String? duration;

  const CustomImageDetailsProgressBar({
    super.key,
    this.caption,
    this.description,
    this.createdAt,
    this.tags,
    this.duration,
  });

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
      controllers.getLibraryStoryData();
    });
  }

  Future<void> _downloadCurrentMedia() async {
    try {
      // Try to get media URL from controller data first
      dynamic currentStory;
      String? mediaUrl;
      String? title;
      String? subtitle;
      String? meta;
      String? hashtags;

      // If widget parameters were provided, we might need to get the media URL differently
      // For now, use the controller's data for download since that contains the actual media URL
      if (controllers.libraryStoryData.isNotEmpty) {
        currentStory = controllers.libraryStoryData.first;
        mediaUrl = currentStory.mediaUrl?.isNotEmpty == true
            ? currentStory.mediaUrl!.first
            : null;
        title = currentStory.caption ?? 'Media';
        subtitle = currentStory.description ?? 'Downloaded from Klokkin App';
        meta = currentStory.duration ?? 'Media';
        hashtags = currentStory.tags?.toString() ?? '';
      } else {
        // If no library data, try to get from the widget data if possible
        // This is a fallback, in most cases the library data should be available
        await controllers.getLibraryStoryData(); // Try to load data
        if (controllers.libraryStoryData.isNotEmpty) {
          currentStory = controllers.libraryStoryData.first;
          mediaUrl = currentStory.mediaUrl?.isNotEmpty == true
              ? currentStory.mediaUrl!.first
              : null;
          title = currentStory.caption ?? 'Media';
          subtitle = currentStory.description ?? 'Downloaded from Klokkin App';
          meta = currentStory.duration ?? 'Media';
          hashtags = currentStory.tags?.toString() ?? '';
        }
      }

      if (mediaUrl != null) {
        Get.snackbar(
          "Downloading...",
          "Please wait while we download your media",
          snackPosition: SnackPosition.BOTTOM,
        );

        bool success = await DownloadService().downloadMedia(
          mediaUrl!,
          title: title ?? 'Media',
          subtitle: subtitle ?? 'Downloaded from Klokkin App',
          meta: meta ?? 'Media',
          hashtags: hashtags ?? '',
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

    // Use passed parameters if available, otherwise use controller data
    String? captionText = widget.caption;
    String? descriptionText = widget.description;
    DateTime? createdAtDate = widget.createdAt;
    List<String>? tagsList = widget.tags;
    String? durationText = widget.duration;

    // Only use controller data if no parameters were passed for specific fields
    if (controllers.libraryStoryData.isNotEmpty) {
      final story = controllers.libraryStoryData.first;
      // Use controller data as fallback if widget parameters are null
      captionText = captionText ?? story.caption;
      descriptionText = descriptionText ?? story.description;
      createdAtDate = createdAtDate ?? story.createdAt;
      tagsList = tagsList ?? story.tags;
      durationText = durationText ?? story.duration;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 28.h),
        CustomText(
          textAlign: TextAlign.start,
          text: captionText ?? 'N/A',
          color: AppColors.textColorFFFFFF,
          fontsize: 24.sp,
          fontWeight: FontWeight.w500,
          maxline: 2,
        ),
        SizedBox(height: 17.h),
        CustomText(
          textAlign: TextAlign.start,
          text: descriptionText ?? 'N/A',
          color: AppColors.textColorFFFFFF,
          fontsize: 16.sp,
          fontWeight: FontWeight.w400,
          maxline: 10,
        ),
        SizedBox(height: 17.h),
        CustomText(
          textAlign: TextAlign.start,
          text: createdAtDate != null
              ? 'Post: ${DateFormat("dd MMM yyyy").format(createdAtDate)}'
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
                children: (tagsList ?? []).map((tag) {
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
  }
}