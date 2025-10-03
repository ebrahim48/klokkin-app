import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../controllers/home_controller.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/custom_image_details_widget.dart';
import '../../widgets/custom_imagedetails_progressbar_widget.dart';
import '../../widgets/custom_network_image.dart';
import '../../widgets/custom_profile_image.dart';



class StoryImageDetailsScreen extends StatefulWidget {
  StoryImageDetailsScreen({super.key});

  @override
  State<StoryImageDetailsScreen> createState() => _StoryImageDetailsScreenState();
}

class _StoryImageDetailsScreenState extends State<StoryImageDetailsScreen> {


  HomeController homeController = Get.put(HomeController());


  void initState() {
    super.initState();
    homeController.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    Map routeData = GoRouterState.of(context).extra as Map;
    return Scaffold(
      appBar: const CustomAppBar(),
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
                    child:   CustomProfileImageDetailsImage(
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
                      Row(
                        children: [
                          CustomText(
                              text: homeController.profile.value.fname ?? 'N/A',
                              color: AppColors.textColorFFFFFF,fontsize: 20.sp,fontWeight: FontWeight.w500),
                         SizedBox(width: 130.w),
                          Assets.icons.editImage.svg(
                          ),
                          SizedBox(width: 10.w),
                          Assets.icons.deleteimage.svg()
                        ],
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
              /// ============================================ Image ====================================>
              SizedBox(height: 40.h),
              Positioned.fill(
                child: CustomNetworkImage(
                    imageUrl: "${routeData["imagePath"]}",
                    boxShape: BoxShape.rectangle,
                    height: 200.h,
                    width: 400.w),

              ),
              SizedBox(height: 16.h),
              /// ============================================ line ====================================>
              CustomImageDetailsProgressBar(),








              SizedBox(height: 50.h)
            ],
          ),
        ),
      ),
    );
  }


}








