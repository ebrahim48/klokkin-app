import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:klokkin_app/services/download_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';
import '../../global/custom_assets/assets.gen.dart';
import 'custom_network_image.dart';

class ImageListCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String meta;
  final String hashtags;
  final String imagePath;
  final bool isPlaying;
  final VoidCallback? onTap;

  const ImageListCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.hashtags,
    required this.imagePath,
    this.isPlaying = false,
    this.onTap,
  });

  @override
  State<ImageListCard> createState() => _ImageListCardState();
}

class _ImageListCardState extends State<ImageListCard> {
  bool _isDownloading = false;

  Future<void> _downloadImage() async {
    if (_isDownloading) return; // Prevent multiple simultaneous downloads
    
    setState(() {
      _isDownloading = true;
    });

    try {
      final downloadService = DownloadService();
      bool success = await downloadService.downloadImage(
        widget.imagePath,
        title: widget.title,
        subtitle: widget.subtitle,
        meta: widget.meta,
        hashtags: widget.hashtags,
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
          description: const Text('Could not save image to device'),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [
                  /// Image
                  Container(
                    width: 124.w,
                    height: 90.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: CustomNetworkImage(
                      imageUrl: widget.imagePath,
                    ),
                  ),

                  SizedBox(width: 12.w),

                  /// Texts
                  SizedBox(
                    width: 210.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: widget.title,
                          color: AppColors.textColorDCDCDC,
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 4.h),
                        CustomText(
                          textAlign: TextAlign.start,
                          text: widget.subtitle,
                          color: AppColors.textColor919191,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.w400,
                          maxline: 2,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            CustomText(
                              text: widget.meta,
                              color: AppColors.textColor8C8C8C,
                              fontsize: 11.sp,
                              fontWeight: FontWeight.w300,
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _downloadImage,
                              child: Container(
                                padding: EdgeInsets.all(4.r),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColorC79235.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: _isDownloading
                                    ? SpinKitCircle(
                                        size: 16.sp,
                                        color: AppColors.primaryColorC79235,
                                      )
                                    : Assets.icons.downloadSimple.svg(
                                        color: AppColors.primaryColorC79235,
                                      ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 4.h),
                        CustomText(
                          text: widget.hashtags,
                          color: AppColors.textColor2165DF,
                          fontsize: 11.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 10.h),

          Divider(
            color: AppColors.secondary836531,
            height: 0.4.h,
            thickness: 0.6,
          ),


        ],
      ),
    );
  }
}
