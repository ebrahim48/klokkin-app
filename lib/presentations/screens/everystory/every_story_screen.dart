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
import '../../widgets/custom_audio_progressbar_widget.dart';
import '../../widgets/custom_profile_image.dart';



class EveryStoryScreen extends StatefulWidget {
  EveryStoryScreen({super.key});

  @override
  State<EveryStoryScreen> createState() => _EveryStoryScreenState();
}

class _EveryStoryScreenState extends State<EveryStoryScreen> {


  HomeController homeController = Get.put(HomeController());

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
            final isMine = storyId != null &&
                storyId.isNotEmpty &&
                currentUserId != null &&
                currentUserId.isNotEmpty &&
                ownerId == currentUserId;
            if (!isMine) return const SizedBox.shrink();
            return IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: () => _confirmDelete(context, storyId),
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








