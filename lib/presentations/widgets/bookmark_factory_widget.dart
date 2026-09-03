import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:klokkin_app/services/download_service.dart';
import 'package:toastification/toastification.dart';
import '../../controllers/audio_book_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../global/custom_assets/assets.gen.dart';
import 'custom_network_image.dart';
import 'custom_text.dart';

class BookmarkFactoryCard extends StatefulWidget {
  final String title;
  final String id;
  final String caption;
  final String imagePath;
  final VoidCallback? onTap;

   const BookmarkFactoryCard({
    super.key,
    required this.id,
    required this.title,
    required this.caption,
    required this.imagePath,
    this.onTap,
  });

  @override
  State<BookmarkFactoryCard> createState() => _BookmarkFactoryCardState();
}

class _BookmarkFactoryCardState extends State<BookmarkFactoryCard> {
  final AudioBookController controller = Get.put(AudioBookController());
  bool _isDownloading = false;

  Future<void> _downloadImage() async {
    if (_isDownloading) return; // Prevent multiple simultaneous downloads
    
    setState(() {
      _isDownloading = true;
    });

    try {
      final downloadService = DownloadService();
      bool success = await downloadService.downloadMedia(
        widget.imagePath,
        title: widget.title,
        subtitle: widget.caption,
        meta: 'Bookmark Image',
        hashtags: 'Bookmark',
      );
      
      if (success) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          title: const Text('Download Complete'),
          description: const Text('Image has been saved to your device'),
        );
      } else {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          title: const Text('Download Failed'),
          description: Text(DownloadService().lastError.isNotEmpty
              ? DownloadService().lastError
              : 'Could not save the image. Please try again.'),
        );
      }
    } catch (e) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        title: const Text('Download Error'),
        description: Text('Error: $e'),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: AppColors.textColorFFFFFF,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// =============================> Image with overlay ========================>
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomNetworkImage(
                        imageUrl: widget.imagePath,

                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 8,
                      right: 8,
                      child: Container(
                        height: 24.h,
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        decoration: BoxDecoration(
                          color: AppColors.textColorFFFFFF.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Make the text flexible
                            Expanded(
                              child: CustomText(
                                text: widget.title,
                                color: AppColors.textColorFFFFFF,
                                fontsize: 12.sp,
                                fontWeight: FontWeight.w500,
                                maxline: 1,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            ),

                            SizedBox(width: 8.w), // spacing between text and icon

                            GestureDetector(
                              onTap: _downloadImage,
                              child: _isDownloading
                                  ? Icon(
                                      Icons.downloading,
                                      color: AppColors.textColorFFFFFF,
                                      size: 16.w,
                                    )
                                  : SvgPicture.asset(
                                      "assets/icons/downloadSimple.svg",
                                      width: 16.w,
                                      height: 16.h,
                                      color: AppColors.textColorFFFFFF,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8.w,
                      child: GestureDetector(
                        onTap: () {
                          controller.bookMark(widget.id);
                        },
                        child: Assets.icons.bookmarkSimple.svg(
                          width: 22.w,
                          height: 22.h,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFC79235),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              // Bottom caption
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(6.w),
                color: AppColors.textColorFFFFFF,
                child: CustomText(
                  textAlign: TextAlign.start,
                  text: widget.caption,
                  fontsize: 12.sp,
                  maxline: 2,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor000000,
                ),
              ),
              SizedBox(height: 14.h),
            ],
          ),
        ),
      ),
    );
  }
}
