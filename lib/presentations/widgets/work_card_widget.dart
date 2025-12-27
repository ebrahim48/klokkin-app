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
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      final downloadService = DownloadService();
      bool success = await downloadService.downloadMedia(
        widget.videoPath,
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
        width: 160.w,
        height: 180.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: AppColors.backgColor20272E,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: GetBuilder<WorkCardController>(
            builder: (_) {
              final videoCtrl = controller.getController(widget.index);
              final isInit = controller.isInitialized(widget.index);
              final isPlaying = controller.isPlaying(widget.index);

              return Stack(
                children: [
                  // Video or Thumbnail
                  Positioned.fill(
                    child: isInit && videoCtrl != null
                        ? VideoPlayer(videoCtrl)
                        : CustomNetworkImage(
                      imageUrl: widget.imagePath,
                      borderRadius: BorderRadius.zero,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Dark Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Title & Download Overlay
                  Positioned(
                    top: 12.h,
                    left: 12.w,
                    right: 12.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            textAlign: TextAlign.start,
                            text: widget.title,
                            color: AppColors.textColorFFFFFF,
                            fontsize: 13.sp,
                            fontWeight: FontWeight.w600,
                            maxline: 2,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: _downloadMedia,
                          child: Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColorC79235,
                              shape: BoxShape.circle,
                            ),
                            child: _isDownloading
                                ? SizedBox(
                              width: 12.w,
                              height: 12.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : Icon(
                              Icons.download,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Play Button & Duration
                  Positioned(
                    bottom: 12.h,
                    left: 12.w,
                    right: 12.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Play/Pause Button - ALWAYS VISIBLE
                        GestureDetector(
                          onTap: () async {
                            // Initialize video if not already done
                            if (!isInit) {
                              await controller.setVideoPath(widget.index, widget.videoPath);
                            }
                            controller.togglePlayPause(widget.index);
                          },
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColorC79235,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ),

                        // Duration Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: CustomText(
                            text: widget.duration,
                            color: AppColors.textColorFFFFFF,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}