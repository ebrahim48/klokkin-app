import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../widgets/customMainProfile.dart';
import '../../widgets/custom_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AudioBookController controller = Get.put(AudioBookController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Color textColor = const Color(0xFFC79235);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Image with Edit Button
              Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Profile Image
                    CustomMainProfileImage(
                      imageUrl:
                      'https://media.licdn.com/dms/image/v2/C4E03AQGAvYAY6kdVXQ/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1603315936568?e=1758758400&v=beta&t=QeIvlqHz22MKUgXX6U56FSocAyZYGAA5NUi3CMb_alQ',
                    ),

                    // Positioned Edit Button
                    Positioned(
                      bottom: -0.1.h, // adjust positioning
                      child: Container(
                        width: 64.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC79235), // button color
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Center(
                          child: CustomText(
                            text: "Edit",
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),

              // Username
              CustomText(
                text: "Ebrahim",
                fontsize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColorFFFFFF,
              ),
              SizedBox(height: 65.h),

              // Menu Items
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    menuItem(Icons.person_outline, "Personal", () {
                      context.pushNamed(AppRoutes.personalScreen);

                    }),
                    menuItem(Icons.settings_outlined, "System settings", () {
                      context.pushNamed(AppRoutes.systemSettingScreen);
                    }),
                    menuItem(Icons.lock_outline, "Permissions", () {
                      context.pushNamed(AppRoutes.permissionScreen);
                    }),
                    menuItem(Icons.feedback_outlined, "Feedback", () {
                      context.pushNamed(AppRoutes.feedbackScreen);
                    }),
                    menuItem(Icons.info_outline, "About", () {
                      // Get.to(() => const AboutScreen());
                    }),
                    menuItem(Icons.help_outline, "Questions and help", () {
                      // Get.to(() => const HelpScreen());
                    }),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget menuItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h), // gap: 20px
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: textColor, size: 22.sp),
                SizedBox(width: 12.w),
                CustomText(
                  text: title,
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: textColor, size: 16.sp),
          ],
        ),
      ),
    );
  }

}

