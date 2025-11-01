import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:klokkin_app/services/download_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';
import 'package:path/path.dart' as path;
import 'custom_network_image.dart';
import '../../global/custom_assets/assets.gen.dart';

class LocalImageListCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String meta;
  final String hashtags;
  final String imagePath; // This can be URL or local file path
  final bool isPlaying;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool isLocalFile; // Flag to indicate if it's a local file

  const LocalImageListCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.hashtags,
    required this.imagePath,
    this.isPlaying = false,
    this.onTap,
    this.onDelete,
    this.isLocalFile = false, // By default assume it's a URL
  });

  @override
  State<LocalImageListCard> createState() => _LocalImageListCardState();
}

class _LocalImageListCardState extends State<LocalImageListCard> {
  bool _isDownloading = false;

  Future<void> _downloadImage() async {
    if (_isDownloading) return; // Prevent multiple simultaneous downloads
    
    setState(() {
      _isDownloading = true;
    });

    try {
      final downloadService = DownloadService();
      bool success = await downloadService.downloadImage(widget.imagePath);
      
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
                  /// Image - handle both URL and local files
                  Container(
                    width: 124.w,
                    height: 90.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: widget.isLocalFile
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: Image.file(
                              File(widget.imagePath),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.broken_image,
                                  color: AppColors.textColor919191,
                                  size: 30.sp,
                                );
                              },
                            ),
                          )
                        : CustomNetworkImage(
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
                            if (widget.isLocalFile && widget.onDelete != null)
                              IconButton(
                                onPressed: widget.onDelete,
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: AppColors.textColor919191,
                                  size: 20.sp,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              )
                            else if (widget.isLocalFile)
                              Assets.icons.downloadSimple.svg(
                                color: AppColors.primaryColorC79235,
                                width: 16.w,
                                height: 16.h,
                              ) // Show download icon to indicate it's already downloaded
                            else
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
                              ),
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