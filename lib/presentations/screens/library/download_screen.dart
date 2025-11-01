
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:klokkin_app/services/download_service.dart';
import 'package:toastification/toastification.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/image_story_list_widget.dart';
import '../../widgets/local_image_list_card.dart';
import 'package:intl/intl.dart';



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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Obx(() {
          // Show loader if both server data and device downloads are loading
          bool isLoading = controller.getLibraryStoryLoading.value || _isDeviceDownloadsLoading;
          if (isLoading && controller.libraryStoryData.isEmpty && _downloadedContents.isEmpty) {
            return const Center(child: CustomLoader());
          }

          return RefreshIndicator(
            onRefresh: () async {
              controller.getLibraryStoryData();
              _loadDeviceDownloads();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        /// =====================================> Downloading =====================================>
                        CustomText(
                          text: 'Downloading',
                          color: AppColors.primaryColorC79235,
                          fontsize: 24.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        const Spacer(),

                        SizedBox(
                          width: 35.w,
                          child: Assets.icons.dot.svg(width: 22.w, height: 22.h),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 15.w),
                    child: Divider(
                      color: AppColors.secondary836531,
                      height: 0.4.h,
                      thickness: 0.6,
                    ),
                  ),

                  // Ongoing downloads section from server data
                  if (controller.libraryStoryData.isNotEmpty)
                    SizedBox(
                      height: 400.h,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(), // Disable scrolling for this inner list
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: controller.libraryStoryData.length,
                        separatorBuilder: (context, index) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final downloadData = controller.libraryStoryData[index];
                          final createdAt = downloadData.createdAt;
                          String formattedDate = 'N/A';

                          if (createdAt != null && createdAt is String) {
                            final parsed = DateTime.tryParse(createdAt as String);
                            if (parsed != null) {
                              formattedDate = DateFormat("MMM d, yyyy • h:mm a").format(parsed);
                            }
                          }
                          return ImageListCard(
                            title: downloadData.caption ?? 'N/A',
                            subtitle: downloadData.description ?? 'N/A',
                            meta: formattedDate,
                            hashtags: (downloadData.tags is List)
                                ? (downloadData.tags as List).join(", ")
                                : (downloadData.tags?.toString() ?? 'N/A'),
                            imagePath: downloadData.mediaUrl != null && downloadData.mediaUrl!.isNotEmpty
                                ? downloadData.mediaUrl!.first
                                : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                            onTap: () async {
                              // When tapping the card, also trigger download
                              try {
                                final downloadService = DownloadService();
                                bool success = await downloadService.downloadImage(
                                  downloadData.mediaUrl != null && downloadData.mediaUrl!.isNotEmpty
                                      ? downloadData.mediaUrl!.first
                                      : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                                  title: downloadData.caption ?? 'N/A',
                                  subtitle: downloadData.description ?? 'N/A',
                                  meta: formattedDate,
                                  hashtags: (downloadData.tags is List)
                                      ? (downloadData.tags as List).join(", ")
                                      : (downloadData.tags?.toString() ?? 'N/A'),
                                );
                                
                                if (success) {
                                  toastification.show(
                                    context: context,
                                    type: ToastificationType.success,
                                    title: const Text('Download Complete'),
                                    description: const Text('Content has been saved to your device'),
                                  );
                                  // Refresh the downloads list
                                  _loadDeviceDownloads();
                                } else {
                                  toastification.show(
                                    context: context,
                                    type: ToastificationType.error,
                                    title: const Text('Download Failed'),
                                    description: const Text('Could not save content to device'),
                                  );
                                }
                              } catch (e) {
                                toastification.show(
                                  context: context,
                                  type: ToastificationType.error,
                                  title: const Text('Download Error'),
                                  description: Text('Error: $e'),
                                );
                              }
                            },
                          );
                        },
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                      child: CustomText(
                        text: 'No ongoing downloads',
                        color: AppColors.textColor919191,
                        fontsize: 16.sp,
                      ),
                    ),

                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        /// =====================================> My Downloads =====================================>
                        CustomText(
                          text: 'My Downloads',
                          color: AppColors.primaryColorC79235,
                          fontsize: 24.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        const Spacer(),

                        SizedBox(
                          width: 35.w,
                          child: Assets.icons.dot.svg(width: 22.w, height: 22.h),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 15.w),
                    child: Divider(
                      color: AppColors.secondary836531,
                      height: 0.4.h,
                      thickness: 0.6,
                    ),
                  ),

                  SizedBox(height: 11.h),

                  // Actual downloaded content from device storage
                  if (!_isDeviceDownloadsLoading && _downloadedContents.isNotEmpty)
                    SizedBox(
                      height: 400.h,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(), // Disable scrolling for this inner list
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: _downloadedContents.length,
                        separatorBuilder: (context, index) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final content = _downloadedContents[index];
                          return LocalImageListCard(
                            title: content.title,
                            subtitle: content.subtitle,
                            meta: content.meta,
                            hashtags: content.hashtags,
                            imagePath: content.filePath, // Use file path from content
                            isLocalFile: true, // Indicate this is a local file
                            onTap: () {
                              // Option to view the downloaded image
                            },
                            onDelete: () async {
                              bool? confirm = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: AppColors.backgColor20272E,
                                    title:  CustomText(text: 'Delete Download',color: AppColors.textColorFFFFFF,fontsize: 24.sp,),
                                    content: CustomText(
                                        text: 'Are you sure you want to delete "${content.title}"?',
                                      color: AppColors.textColorFFFFFF,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm == true) {
                                try {
                                  bool success = await _downloadService.deleteDownloadedContentByObject(content);
                                  if (success) {
                                    toastification.show(
                                      context: context,
                                      type: ToastificationType.success,
                                      title: const Text('File Deleted'),
                                      description: const Text('The downloaded file has been successfully deleted'),
                                    );
                                    _loadDeviceDownloads(); // Refresh the list
                                  } else {
                                    toastification.show(
                                      context: context,
                                      type: ToastificationType.error,
                                      title: const Text('Delete Failed'),
                                      description: const Text('Could not delete the file'),
                                    );
                                  }
                                } catch (e) {
                                  toastification.show(
                                    context: context,
                                    type: ToastificationType.error,
                                    title: const Text('Delete Error'),
                                    description: Text('Error: $e'),
                                  );
                                }
                              }
                            },
                          );
                        },
                      ),
                    )
                  else if (_isDeviceDownloadsLoading)
                    // Show loading indicator for device downloads
                    Container(
                      height: 400.h,
                      child: const Center(child: CustomLoader()),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                      child: CustomText(
                        text: 'No downloaded files yet',
                        color: AppColors.textColor919191,
                        fontsize: 16.sp,
                      ),
                    ),

                  SizedBox(height: 10.h),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes} B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).round()} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).round()} MB';
    return '${(bytes / (1024 * 1024 * 1024)).round()} GB';
  }
}



