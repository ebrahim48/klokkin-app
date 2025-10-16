import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/customMainProfile.dart';
import '../../widgets/custom_profile_listtile.dart';
import '../../widgets/custom_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AudioBookController controller = Get.put(AudioBookController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeController homeController = Get.put(HomeController());

  void initState() {
    super.initState();
    homeController.getProfile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              /// ==============================>  Profile Image with Edit Button ====================================>
              Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Profile Image
                    CustomMainProfileImage(
                      imagePath: homeController.profile.value.profile?.avatar != null &&
                          homeController.profile.value.profile!.avatar!.isNotEmpty
                          ? homeController.profile.value.profile!.avatar!
                          : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                    ),

                    // Positioned Edit Button
                    // Positioned(
                    //   bottom: -0.1.h, // adjust positioning
                    //   child: Container(
                    //     width: 64.w,
                    //     height: 20.h,
                    //     decoration: BoxDecoration(
                    //       color: const Color(0xFFC79235), // button color
                    //       borderRadius: BorderRadius.circular(50.r),
                    //     ),
                    //     child: Center(
                    //       child: CustomText(
                    //         text: "Edit",
                    //         fontsize: 12.sp,
                    //         fontWeight: FontWeight.w500,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),

              // Username
              CustomText(
                text: homeController.profile.value.profile?.nickname ?? 'N/A',
                fontsize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColorFFFFFF,
              ),
              SizedBox(height: 65.h),


              CustomProfileListTile(
                  title: 'Personal',
                  icon: Assets.icons.personal.svg(),
                  onTap: () {
                    context.pushNamed(AppRoutes.personalScreen);
                  }),
              CustomProfileListTile(
                  title: 'System settings',
                  icon: Assets.icons.systemsettings.svg(),
                  onTap: () {
                    context.pushNamed(AppRoutes.systemSettingScreen);
                  }),
              CustomProfileListTile(
                  title: 'Permissions',
                  icon: Assets.icons.permissions.svg(),
                  onTap: () {
                    context.pushNamed(AppRoutes.permissionScreen);
                  }),
              CustomProfileListTile(
                  title: 'Feedback',
                  icon: Assets.icons.feedback.svg(),
                  onTap: () {
                    context.pushNamed(AppRoutes.feedbackScreen);
                  }),
              CustomProfileListTile(
                  title: 'About',
                  icon: Assets.icons.about.svg(),
                  onTap: () {
                    context.pushNamed(AppRoutes.aboutScreen);
                  }),
              CustomProfileListTile(
                  title: 'Questions and help',
                  icon: Assets.icons.questionshelp.svg(),
                  onTap: () {
                    context.pushNamed(AppRoutes.questionHelpScreen);
                  }),


            ],
          ),
        ),
      ),
    );
  }



}

