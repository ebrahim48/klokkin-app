import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/bookmark_Innovation_widget.dart';
import '../../widgets/bookmark_factory_widget.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AudioBookController controller = Get.put(AudioBookController());
  List<String> _folders = [];

  @override
  void initState() {
    super.initState();
    controller.getLibraryStoryData();
    _loadFolders();
  }

  // Load existing folders from SharedPreferences
  Future<void> _loadFolders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final folders = prefs.getStringList('bookmark_folders') ?? [];
      if (mounted) {
        setState(() {
          _folders = folders;
        });
      }
      print('📁 Loaded ${folders.length} folders');
    } catch (e) {
      print('Error loading folders: $e');
    }
  }

  // Create new folder
  Future<void> _createFolder(String folderName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> folders = prefs.getStringList('bookmark_folders') ?? [];

      // Check if folder already exists
      if (folders.contains(folderName)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Folder "$folderName" already exists'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // Add new folder
      folders.add(folderName);
      await prefs.setStringList('bookmark_folders', folders);

      // Update local state
      if (mounted) {
        setState(() {
          _folders = folders;
        });
      }

      print('✅ Folder created: $folderName');
    } catch (e) {
      print('Error creating folder: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create folder'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Delete folder
  Future<void> _deleteFolder(String folderName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> folders = prefs.getStringList('bookmark_folders') ?? [];
      folders.remove(folderName);
      await prefs.setStringList('bookmark_folders', folders);

      if (mounted) {
        setState(() {
          _folders = folders;
        });
      }

      print('🗑️ Folder deleted: $folderName');
    } catch (e) {
      print('Error deleting folder: $e');
    }
  }

  void _showCreateFolderDialog() {
    final TextEditingController folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            folderNameController.dispose();
            return true;
          },
          child: AlertDialog(
            backgroundColor: AppColors.backgColor20272E,
            title: CustomText(
              text: 'Create Folder',
              color: AppColors.textColorFFFFFF,
              fontsize: 20.sp,
            ),
            content: TextField(
              controller: folderNameController,
              autofocus: true,
              style: TextStyle(color: AppColors.textColorFFFFFF),
              decoration: InputDecoration(
                hintText: 'Enter folder name',
                hintStyle: TextStyle(color: AppColors.textColor919191),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColorC79235),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColorC79235, width: 2),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  folderNameController.dispose();
                },
                child: Text('Cancel', style: TextStyle(color: AppColors.textColor919191)),
              ),
              TextButton(
                onPressed: () async {
                  final folderName = folderNameController.text.trim();

                  if (folderName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a folder name'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  // Close dialog first
                  Navigator.pop(context);

                  // Create folder
                  await _createFolder(folderName);

                  // Dispose controller
                  folderNameController.dispose();

                  // Show success message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Folder "$folderName" created successfully'),
                        backgroundColor: AppColors.primaryColorC79235,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text('Create', style: TextStyle(color: AppColors.primaryColorC79235)),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // Ensure disposal even if dialog is dismissed
      if (!folderNameController.hasListeners) {
        folderNameController.dispose();
      }
    });
  }

  void _showFoldersMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgColor20272E,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Folders',
                color: AppColors.textColorFFFFFF,
                fontsize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 16.h),

              // Create Folder Button
              ListTile(
                leading: Icon(Icons.create_new_folder, color: AppColors.primaryColorC79235),
                title: CustomText(
                  text: 'Create New Folder',
                  color: AppColors.textColorFFFFFF,
                  fontsize: 16.sp,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showCreateFolderDialog();
                },
              ),

              Divider(color: AppColors.secondary836531),

              // List of existing folders
              if (_folders.isEmpty)
                Padding(
                  padding: EdgeInsets.all(20.h),
                  child: CustomText(
                    text: 'No folders yet',
                    color: AppColors.textColor919191,
                    fontsize: 14.sp,
                  ),
                )
              else
                ..._folders.map((folder) => ListTile(
                  leading: Icon(Icons.folder, color: AppColors.primaryColorC79235),
                  title: CustomText(
                    text: folder,
                    color: AppColors.textColorFFFFFF,
                    fontsize: 16.sp,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                      _showDeleteFolderConfirmation(folder);
                    },
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to folder content
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening folder: $folder'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                )).toList(),

              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteFolderConfirmation(String folderName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.backgColor20272E,
          title: CustomText(
            text: 'Delete Folder',
            color: AppColors.textColorFFFFFF,
            fontsize: 20.sp,
          ),
          content: CustomText(
            text: 'Are you sure you want to delete "$folderName"?',
            color: AppColors.textColorFFFFFF,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: AppColors.textColor919191)),
            ),
            TextButton(
              onPressed: () async {
                await _deleteFolder(folderName);
                Navigator.pop(context);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Folder "$folderName" deleted'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
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
          icon: Icon(Icons.arrow_back, color: AppColors.textColorFFFFFF),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        CustomText(
                          text: 'BookMark',
                          color: AppColors.primaryColorC79235,
                          fontsize: 24.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _showFoldersMenu,
                          child: SizedBox(
                            width: 35.w,
                            child: Assets.icons.dot.svg(width: 22.w, height: 22.h),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Divider(
                      thickness: 1,
                      color: const Color(0x36D09F48),
                      height: 0.h,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// Horizontal List
                  SizedBox(
                    height: 160.h,
                    child: controller.getLibraryStoryLoading.value
                        ? _buildHorizontalShimmer()
                        : controller.libraryStoryData.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: controller.libraryStoryData.length,
                      separatorBuilder: (context, index) => SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        final libraryData = controller.libraryStoryData[index];
                        final isVideo = libraryData.type == 'video';
                        final displayUrl = isVideo
                            ? (libraryData.thumbnail ?? "https://via.placeholder.com/150")
                            : (libraryData.mediaUrl != null && libraryData.mediaUrl!.isNotEmpty
                            ? libraryData.mediaUrl!.first
                            : "https://via.placeholder.com/150");

                        return BookmarkInnovationCard(
                          id: '${libraryData.id}',
                          title: libraryData.caption ?? 'N/A',
                          caption: libraryData.description ?? 'N/A',
                          imagePath: displayUrl,
                          onTap: () {},
                        );
                      },
                    ),
                  ),

                  /// Divider
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 15.h),
                    child: Divider(
                      color: AppColors.secondary836531,
                      height: 0.4.h,
                      thickness: 0.6,
                    ),
                  ),
                  SizedBox(height: 11.h),

                  /// Grid
                  controller.getLibraryStoryLoading.value
                      ? _buildGridShimmer()
                      : controller.libraryStoryData.isEmpty
                      ? _buildEmptyState()
                      : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 140.w / 180.h,
                    ),
                    itemCount: controller.libraryStoryData.length,
                    itemBuilder: (context, index) {
                      final libraryFactoryData = controller.libraryStoryData[index];
                      final isVideo = libraryFactoryData.type == 'video';
                      final displayUrl = isVideo
                          ? (libraryFactoryData.thumbnail ?? "https://via.placeholder.com/150")
                          : (libraryFactoryData.mediaUrl != null &&
                          libraryFactoryData.mediaUrl!.isNotEmpty
                          ? libraryFactoryData.mediaUrl!.first
                          : "https://via.placeholder.com/150");

                      return BookmarkFactoryCard(
                        id: '${libraryFactoryData.id}',
                        title: libraryFactoryData.caption ?? 'N/A',
                        caption: libraryFactoryData.description ?? 'N/A',
                        imagePath: displayUrl,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Horizontal Shimmer
  Widget _buildHorizontalShimmer() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: 4,
      separatorBuilder: (context, index) => SizedBox(width: 12.w),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.textColor919191.withOpacity(0.2),
          highlightColor: AppColors.textColor919191.withOpacity(0.1),
          child: Container(
            width: 104.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  /// Grid Shimmer
  Widget _buildGridShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 140.w / 180.h,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.textColor919191.withOpacity(0.2),
          highlightColor: AppColors.textColor919191.withOpacity(0.1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  /// Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.h),
        child: CustomText(
          text: "No bookmarks yet",
          textAlign: TextAlign.center,
          color: AppColors.textColorC2C2C2,
          fontsize: 16.sp,
        ),
      ),
    );
  }
}