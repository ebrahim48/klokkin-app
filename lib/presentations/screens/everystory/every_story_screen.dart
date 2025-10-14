import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

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

  @override
  void dispose() {
    homeController.storySingle();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map routeData = GoRouterState.of(context).extra as Map;
    homeController.getStorySingle(id: routeData['storyId']);
    return Scaffold(
      appBar: CustomAppBar(title: "${routeData["title"]}"),
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
                      CustomText(text: 'Ebrahim',color: AppColors.textColorFFFFFF,fontsize: 20.sp,fontWeight: FontWeight.w500),
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








