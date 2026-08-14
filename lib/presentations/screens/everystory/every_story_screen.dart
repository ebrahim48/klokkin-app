import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

import '../../../controllers/audio_book_controller.dart';
import '../../../controllers/audio_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/moderation_controller.dart';
import '../../widgets/custom_audio_progressbar_widget.dart';
import '../../widgets/custom_profile_image.dart';



class EveryStoryScreen extends StatefulWidget {
  EveryStoryScreen({super.key});

  @override
  State<EveryStoryScreen> createState() => _EveryStoryScreenState();
}

class _EveryStoryScreenState extends State<EveryStoryScreen> {


  HomeController homeController = Get.put(HomeController());
  final ModerationController moderation = Get.put(ModerationController());

  Future<void> _reportStory(
    BuildContext context, {
    required String storyId,
    String? ownerId,
    String? authorName,
  }) async {
    const reasons = [
      'Nudity or sexual content',
      'Hate speech or harassment',
      'Violence or dangerous acts',
      'Spam or misleading',
      'Other objectionable content',
    ];
    final reason = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.textColor323539,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            CustomText(
              text: 'Report this content',
              color: AppColors.textColorFFFFFF,
              fontsize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 8.h),
            ...reasons.map(
              (r) => ListTile(
                title: CustomText(
                  text: r,
                  color: AppColors.textColorFFFFFF,
                  fontsize: 15.sp,
                ),
                onTap: () => Navigator.pop(ctx, r),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
    if (reason == null || !mounted) return;
    await moderation.reportStory(
      storyId: storyId,
      userId: ownerId,
      authorName: authorName,
      reason: reason,
    );
    // Remove the reported story from feeds and leave the screen.
    await homeController.getLatestForm();
    if (mounted) context.pop();
  }

  Future<void> _blockUser(
    BuildContext context, {
    required String ownerId,
    String? authorName,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.textColor323539,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Container(
          width: 286.w,
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: 'Block ${authorName ?? 'this user'}? '
                    'You will no longer see their content.',
                color: AppColors.textColorFFFFFF,
                fontsize: 16.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                maxline: 3,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx, false),
                    child: Container(
                      width: 100.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: AppColors.textColor6B6B6B,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Center(
                        child: CustomText(
                          text: 'Cancel',
                          color: AppColors.textColorFFFFFF,
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx, true),
                    child: Container(
                      width: 100.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Center(
                        child: CustomText(
                          text: 'Block',
                          color: AppColors.textColorFFFFFF,
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed != true || !mounted) return;
    await moderation.blockUser(userId: ownerId, userName: authorName);
    // Blocked user's content leaves the feed instantly.
    await homeController.getLatestForm();
    if (mounted) context.pop();
  }

  Future<void> _confirmDelete(BuildContext context, String storyId) async {
    if (storyId.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.textColor323539,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          width: 286.w,
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: 'Are you sure you want to delete this story?',
                color: AppColors.textColorFFFFFF,
                fontsize: 16.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                maxline: 2,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx, false),
                    child: Container(
                      width: 100.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: AppColors.textColor6B6B6B,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Center(
                        child: CustomText(
                          text: 'Cancel',
                          color: AppColors.textColorFFFFFF,
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx, true),
                    child: Container(
                      width: 100.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Center(
                        child: CustomText(
                          text: 'Delete',
                          color: AppColors.textColorFFFFFF,
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed != true || !mounted) return;
    final audioBookController = Get.put(AudioBookController());
    await audioBookController.deleteStory(storyId);
    // Refresh home feeds so the deleted story disappears from lists.
    await homeController.getLatestForm();
    if (mounted) context.pop();
  }

  @override
  void dispose() {
    // Stop and release the player when leaving so audio/video doesn't keep
    // running in the background and the next story starts clean.
    if (Get.isRegistered<AudioController>()) {
      Get.find<AudioController>().onClose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: do NOT fetch here. build() runs on every rebuild, so calling
    // getStorySingle here re-hit the API constantly (that's why the same
    // story took the same load time every single time). The fetch happens
    // exactly once in AudioProgressBar.initState.
    Map routeData = GoRouterState.of(context).extra as Map;
    return Scaffold(
      appBar: CustomAppBar(
        title: "${routeData["title"]}",
        actions: [
          Obx(() {
            final story = homeController.storySingle.value;
            final currentUserId = homeController.profile.value.id;
            final ownerId = story.user?.id;
            final storyId = story.id;
            final authorName = story.user?.fname;
            final isMine = storyId != null &&
                storyId.isNotEmpty &&
                currentUserId != null &&
                currentUserId.isNotEmpty &&
                ownerId == currentUserId;
            if (isMine) {
              return IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () => _confirmDelete(context, storyId),
              );
            }
            // Someone else's content: offer Report + Block (Guideline 1.2).
            return PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: AppColors.textColor323539,
              onSelected: (value) {
                if (value == 'report') {
                  _reportStory(
                    context,
                    storyId: storyId ?? '',
                    ownerId: ownerId,
                    authorName: authorName,
                  );
                } else if (value == 'block' &&
                    ownerId != null &&
                    ownerId.isNotEmpty) {
                  _blockUser(context,
                      ownerId: ownerId, authorName: authorName);
                }
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 'report',
                  child: Row(
                    children: [
                      const Icon(Icons.flag_outlined, color: Colors.white, size: 20),
                      SizedBox(width: 10.w),
                      CustomText(
                        text: 'Report content',
                        color: AppColors.textColorFFFFFF,
                        fontsize: 14.sp,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'block',
                  child: Row(
                    children: [
                      const Icon(Icons.block, color: Colors.red, size: 20),
                      SizedBox(width: 10.w),
                      CustomText(
                        text: 'Block user',
                        color: Colors.red,
                        fontsize: 14.sp,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 28.h),

              /// ============================================ profile ====================================>

              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child:   CustomProfileImage(
                      imagePath: homeController.profile.value.profile?.avatar != null &&
                          homeController.profile.value.profile!.avatar!.isNotEmpty
                          ? homeController.profile.value.profile!.avatar!
                          : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                    ),
                  ),
                  SizedBox(width: 11.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: homeController.profile.value.profile?.nickname ?? 'N/A',
                        color: AppColors.textColorFFFFFF,
                        fontsize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomText(
                          text: 'Bangladesh',
                          color: AppColors.textColorC2C2C2,
                          fontsize: 16.sp,
                          fontWeight: FontWeight.w500),
                    ],
                  )
                ],
              ),
              SizedBox(height: 16.h),
              /// ============================================ line ====================================>
              const AudioProgressBar(),








              SizedBox(height: 50.h)
            ],
          ),
        ),
      ),
    );
  }


}








