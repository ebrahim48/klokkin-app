import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../core/app_constants/app_constants.dart';
import '../../../core/helpers/prefs_helper.dart';
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

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Row(
            children: [
              CustomText(
                text: 'Are you sure to ',
                color: AppColors.textColorFFFFFF,
                fontsize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              CustomText(
                text: 'sign out?',
                color: AppColors.primaryColorC79235,
                fontsize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    await PrefsHelper.remove(AppConstants.role);
                    await PrefsHelper.remove(AppConstants.isLogged);
                    await PrefsHelper.remove(AppConstants.bearerToken);
                    await PrefsHelper.remove(AppConstants.name);
                    await PrefsHelper.remove(AppConstants.image);
                    await PrefsHelper.remove(AppConstants.userId);
                    await PrefsHelper.remove(AppConstants.email);
                    await PrefsHelper.remove(AppConstants.phone);
                    await PrefsHelper.remove(AppConstants.emailValidator);
                    Get.delete<ProfileController>(force: true);
                    if (ctx.mounted) {
                      ctx.go(AppRoutes.logInScreen);
                    }
                  },
                  child: CustomText(
                    text: 'Confirm',
                    color: AppColors.primaryColorC79235,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 20.w),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: CustomText(
                    text: 'Cancel',
                    color: AppColors.textColor919191,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          backgroundColor: AppColors.textColor323539,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          actionsPadding: EdgeInsets.only(bottom: 16.h),
        );
      },
    );
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
                  title: 'Subscription',
                  icon: const Icon(
                    Icons.workspace_premium,
                    color: AppColors.primaryColorC79235,
                  ),
                  onTap: () {
                    context.pushNamed(AppRoutes.subscriptionScreen);
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
                  title: 'Terms & Conditions',
                  icon: Assets.icons.questionshelp.svg(),
                  onTap: () {
                    context.pushNamed(AppRoutes.questionHelpScreen);
                  }),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GestureDetector(
                  onTap: () => _showSignOutDialog(context),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColorC79235,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: CustomText(
                        text: 'Logout',
                        fontsize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColorFFFFFF,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }



}

