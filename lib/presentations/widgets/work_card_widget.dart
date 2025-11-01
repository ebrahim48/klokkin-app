import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:klokkin_app/services/download_service.dart';
import 'package:toastification/toastification.dart';
import '../../controllers/work_controller.dart';
import '../../core/constants/app_colors.dart';
import 'custom_network_image.dart';
import 'custom_text.dart';

class WorkCard extends StatefulWidget {
  final int index;
  final String title;
  final String duration;
  final String imagePath;
  final String videoPath;
  final VoidCallback? onTap;

  const WorkCard({
    super.key,
    required this.index,
    required this.title,
    required this.duration,
    required this.imagePath,
    required this.videoPath,
    this.onTap,
  });

  @override
  State<WorkCard> createState() => _WorkCardState();
}

class _WorkCardState extends State<WorkCard> {
  bool _isDownloading = false;

  Future<void> _downloadMedia() async {
    if (_isDownloading) return; // Prevent multiple simultaneous downloads
    
    setState(() {
      _isDownloading = true;
    });

    try {
      final downloadService = DownloadService();
      bool success = await downloadService.downloadMedia(
        widget.videoPath, // Download the video
        title: widget.title,
        subtitle: 'Duration: ${widget.duration}',
        meta: 'Work Video',
        hashtags: 'Work,Video',
      );
      
      if (success) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          title: const Text('Download Complete'),
          description: const Text('Video has been saved to your device'),
        );
      } else {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          title: const Text('Download Failed'),
          description: const Text('Could not save video to device'),
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
    final controller = Get.find<WorkCardController>();

    return GestureDetector(
      onTap: () async {
        await controller.setVideoPath(widget.index, widget.videoPath);
        if (widget.onTap != null) widget.onTap!();
      },
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: GetBuilder<WorkCardController>(
            builder: (_) {
              final videoCtrl = controller.getController(widget.index);
              final isInit = controller.isInitialized(widget.index);
              final isPlaying = controller.isPlaying(widget.index);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        if (isInit && videoCtrl != null)
                          AspectRatio(
                            aspectRatio: videoCtrl.value.aspectRatio,
                            child: VideoPlayer(videoCtrl),
                          )
                        else
                          Center(
                            child: CustomNetworkImage(
                              imageUrl: widget.imagePath,
                              borderRadius: BorderRadius.zero,
                            ),
                          ),

                        // Title Overlay
                        Positioned(
                          top: 16,
                          left: 8,
                          right: 8,
                          child: Container(
                            height: 50.h,
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            color: AppColors.textColor000000.withOpacity(0.2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    textAlign: TextAlign.start,
                                    text: widget.title,
                                    color: AppColors.textColorFFFFFF,
                                    fontsize: 12.sp,
                                    fontWeight: FontWeight.w900,
                                    maxline: 2,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _downloadMedia,
                                  child: _isDownloading
                                      ? Icon(
                                          Icons.downloading,
                                          color: AppColors.textColorFFFFFF,
                                          size: 24.w,
                                        )
                                      : SvgPicture.asset(
                                          "assets/icons/downloadSimple.svg",
                                          width: 24.w,
                                          height: 24.h,
                                          color: AppColors.textColorFFFFFF,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Play & Duration Overlay
                        Positioned(
                          bottom: 8.h,
                          left: 8.w,
                          right: 8.w,
                          child: Container(
                            height: 34.h,
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            color: AppColors.textColor000000.withOpacity(0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => controller.togglePlayPause(widget.index),
                                  child: Container(
                                    width: 32.w,
                                    height: 32.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.textColorFFFFFF,
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                    child: Icon(
                                      isPlaying ? Icons.pause : Icons.play_arrow,
                                      color: Colors.orange,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                                CustomText(
                                  text: widget.duration,
                                  color: AppColors.textColorFFFFFF,
                                  fontsize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
