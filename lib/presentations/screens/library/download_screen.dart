import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:klokkin_app/services/download_service.dart';
import 'package:toastification/toastification.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../core/constants/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AudioBookController controller = Get.put(AudioBookController());
  final DownloadService _downloadService = DownloadService();
  List<DownloadedContent> _downloadedContents = [];
  bool _isDeviceDownloadsLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getLibraryStoryData();
      _loadDeviceDownloads();
    });
  }

  Future<void> _loadDeviceDownloads() async {
    setState(() {
      _isDeviceDownloadsLoading = true;
    });

    try {
      final contents = await _downloadService.getDownloadedContent();
      if (mounted) {
        setState(() {
          _downloadedContents = contents;
          _isDeviceDownloadsLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDeviceDownloadsLoading = false;
        });
      }
    }
  }

  void _showCreateFolderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgColor20272E,
          title: CustomText(
            text: 'Create Folder',
            color: AppColors.textColorFFFFFF,
            fontsize: 20.sp,
          ),
          content: const TextField(
            style: TextStyle(color: AppColors.textColorFFFFFF),
            decoration: InputDecoration(
              hintText: 'Enter folder name',
              hintStyle: TextStyle(color: AppColors.textColor919191),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryColorC79235),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryColorC79235),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textColor919191)),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement folder creation
                Navigator.pop(context);
                toastification.show(
                  context: context,
                  type: ToastificationType.success,
                  title: const Text('Folder Created'),
                  description: const Text('New folder has been created'),
                );
              },
              child: const Text('Create', style: TextStyle(color: AppColors.primaryColorC79235)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgColor20272E,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.backgColor20272E,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColorFFFFFF),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          return RefreshIndicator(
            onRefresh: () async {
              await controller.getLibraryStoryData();
              await _loadDeviceDownloads();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Downloading Section Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        CustomText(
                          text: 'Downloading',
                          color: AppColors.primaryColorC79235,
                          fontsize: 24.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: _showCreateFolderDialog,
                          icon: Icon(
                            Icons.more_vert,
                            color: AppColors.textColorFFFFFF,
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Divider(
                      color: AppColors.secondary836531,
                      height: 1.h,
                      thickness: 0.5,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  /// Downloading List
                  if (controller.getLibraryStoryLoading.value)
                    _buildShimmerList()
                  else if (controller.libraryStoryData.isNotEmpty)
                    _buildDownloadingList()
                  else
                    _buildEmptyState('No ongoing downloads'),

                  SizedBox(height: 24.h),

                  /// My Downloads Section Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        CustomText(
                          text: 'My Downloads',
                          color: AppColors.primaryColorC79235,
                          fontsize: 24.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: _showCreateFolderDialog,
                          icon: Icon(
                            Icons.more_vert,
                            color: AppColors.textColorFFFFFF,
                            size: 24.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Divider(
                      color: AppColors.secondary836531,
                      height: 1.h,
                      thickness: 0.5,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  /// My Downloads List
                  if (_isDeviceDownloadsLoading)
                    _buildShimmerList()
                  else if (_downloadedContents.isNotEmpty)
                    _buildMyDownloadsList()
                  else
                    _buildEmptyState('No downloaded files yet'),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Build Downloading List
  Widget _buildDownloadingList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: controller.libraryStoryData.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final downloadData = controller.libraryStoryData[index];
        final createdAt = downloadData.createdAt;
        String formattedDate = 'N/A';

        if (createdAt != null) {
          formattedDate = DateFormat("h:mm a • d MMM").format(createdAt);
        }

        // For video: use thumbnail, for image: use mediaUrl
        final isVideo = downloadData.type == 'video';
        final displayUrl = isVideo
            ? (downloadData.thumbnail ?? "https://via.placeholder.com/150")
            : (downloadData.mediaUrl != null && downloadData.mediaUrl!.isNotEmpty
            ? downloadData.mediaUrl!.first
            : "https://via.placeholder.com/150");

        // Download URL should be mediaUrl for both
        final downloadUrl = downloadData.mediaUrl != null && downloadData.mediaUrl!.isNotEmpty
            ? downloadData.mediaUrl!.first
            : "";

        return _buildMediaCard(
          imageUrl: displayUrl,
          title: downloadData.caption ?? 'Untitled',
          subtitle: downloadData.description ?? 'No description',
          meta: formattedDate,
          hashtags: (downloadData.tags is List)
              ? (downloadData.tags as List).join(" ")
              : (downloadData.tags?.toString() ?? ''),
          isVideo: isVideo,
          onDownload: () async {
            try {
              bool success = await _downloadService.downloadMedia(
                downloadUrl,
                title: downloadData.caption ?? 'Untitled',
                subtitle: downloadData.description ?? '',
                meta: formattedDate,
                hashtags: (downloadData.tags is List)
                    ? (downloadData.tags as List).join(" ")
                    : '',
              );

              if (success && mounted) {
                toastification.show(
                  context: context,
                  type: ToastificationType.success,
                  title: const Text('Download Complete'),
                  description: const Text('Content saved to device'),
                );
                _loadDeviceDownloads();
              }
            } catch (e) {
              if (mounted) {
                toastification.show(
                  context: context,
                  type: ToastificationType.error,
                  title: const Text('Download Failed'),
                  description: Text('Error: $e'),
                );
              }
            }
          },
        );
      },
    );
  }

  /// Build My Downloads List
  Widget _buildMyDownloadsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: _downloadedContents.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final content = _downloadedContents[index];

        // Check if it's a video file
        final isVideo = content.filePath.toLowerCase().endsWith('.mp4') ||
            content.filePath.toLowerCase().endsWith('.mov') ||
            content.filePath.toLowerCase().endsWith('.avi') ||
            content.filePath.toLowerCase().endsWith('.mkv') ||
            content.filePath.toLowerCase().endsWith('.m3u8');

        return _buildDownloadedMediaCard(
          filePath: content.filePath,
          title: content.title,
          subtitle: content.subtitle,
          meta: content.meta,
          hashtags: content.hashtags,
          isVideo: isVideo,
          onDelete: () async {
            bool? confirm = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: AppColors.backgColor20272E,
                  title: CustomText(
                    text: 'Delete Download',
                    color: AppColors.textColorFFFFFF,
                    fontsize: 20.sp,
                  ),
                  content: CustomText(
                    text: 'Delete "${content.title}"?',
                    color: AppColors.textColorFFFFFF,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel',
                          style: TextStyle(color: AppColors.textColor919191)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Delete',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );

            if (confirm == true) {
              try {
                bool success = await _downloadService.deleteDownloadedContentByObject(content);
                if (success && mounted) {
                  toastification.show(
                    context: context,
                    type: ToastificationType.success,
                    title: const Text('Deleted'),
                    description: const Text('File deleted successfully'),
                  );
                  _loadDeviceDownloads();
                }
              } catch (e) {
                if (mounted) {
                  toastification.show(
                    context: context,
                    type: ToastificationType.error,
                    title: const Text('Delete Failed'),
                    description: Text('Error: $e'),
                  );
                }
              }
            }
          },
        );
      },
    );
  }

  /// Build Media Card
  Widget _buildMediaCard({
    required String imageUrl,
    required String title,
    required String subtitle,
    required String meta,
    required String hashtags,
    required VoidCallback onDownload,
    bool isVideo = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Image/Thumbnail with Video Indicator
        Stack(
          children: [
            Container(
              width: 82.w,
              height: 82.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.textColor919191.withOpacity(0.2),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.broken_image,
                    color: AppColors.textColor919191,
                    size: 32.sp,
                  );
                },
              ),
            ),

            // Video play icon overlay
            if (isVideo)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),

        SizedBox(width: 12.w),

        /// Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              CustomText(
                text: title,
                color: AppColors.textColorFFFFFF,
                fontsize: 16.sp,
                fontWeight: FontWeight.w500,
                maxline: 2,
              ),

              SizedBox(height: 4.h),

              /// Subtitle
              CustomText(
                text: subtitle,
                color: AppColors.textColor919191,
                fontsize: 13.sp,
                maxline: 2,
              ),

              SizedBox(height: 8.h),

              /// Meta and Download Button
              Row(
                children: [
                  CustomText(
                    text: meta,
                    color: AppColors.textColor8C8C8C,
                    fontsize: 12.sp,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onDownload,
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColorC79235.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.download,
                        color: AppColors.primaryColorC79235,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              /// Hashtags
              if (hashtags.isNotEmpty)
                CustomText(
                  text: hashtags,
                  color: AppColors.textColor2165DF,
                  fontsize: 12.sp,
                  maxline: 1,
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build Shimmer Loading
  Widget _buildShimmerList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: 3,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.textColor919191.withOpacity(0.2),
          highlightColor: AppColors.textColor919191.withOpacity(0.1),
          child: Row(
            children: [
              Container(
                width: 82.w,
                height: 82.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16.h,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 14.h,
                      width: 200.w,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 12.h,
                      width: 100.w,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build Empty State
  Widget _buildEmptyState(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      child: Center(
        child: CustomText(
          text: message,
          color: AppColors.textColor919191,
          fontsize: 16.sp,
        ),
      ),
    );
  }

  /// Build Downloaded Media Card (for My Downloads section)
  Widget _buildDownloadedMediaCard({
    required String filePath,
    required String title,
    required String subtitle,
    required String meta,
    required String hashtags,
    required bool isVideo,
    required VoidCallback onDelete,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Media Preview with Video Indicator
        Stack(
          children: [
            Container(
              width: 82.w,
              height: 82.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.textColor919191.withOpacity(0.2),
              ),
              clipBehavior: Clip.hardEdge,
              child: isVideo
                  ? Container(
                color: Colors.black,
                child: Icon(
                  Icons.videocam,
                  color: AppColors.textColor919191,
                  size: 32.sp,
                ),
              )
                  : Image.file(
                File(filePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image,
                    color: AppColors.textColor919191,
                    size: 32.sp,
                  );
                },
              ),
            ),

            // Video play icon overlay
            if (isVideo)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),

        SizedBox(width: 12.w),

        /// Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              CustomText(
                text: title,
                color: AppColors.textColorFFFFFF,
                fontsize: 16.sp,
                fontWeight: FontWeight.w500,
                maxline: 2,
              ),

              SizedBox(height: 4.h),

              /// Subtitle
              CustomText(
                text: subtitle,
                color: AppColors.textColor919191,
                fontsize: 13.sp,
                maxline: 2,
              ),

              SizedBox(height: 8.h),

              /// Meta and Delete Button
              Row(
                children: [
                  CustomText(
                    text: meta,
                    color: AppColors.textColor8C8C8C,
                    fontsize: 12.sp,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              /// Hashtags
              if (hashtags.isNotEmpty)
                CustomText(
                  text: hashtags,
                  color: AppColors.textColor2165DF,
                  fontsize: 12.sp,
                  maxline: 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}