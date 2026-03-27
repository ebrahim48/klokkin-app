import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_button.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:intl/intl.dart';
import '../../../controllers/home_controller.dart';
import '../../widgets/personal_avatar.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  final Color goldColor = const Color(0xFFC79235);
  final Color darkBg = const Color(0xFF1E1E1E);
  final Color fieldBg = const Color(0xFF2A2A2A);


  HomeController homeController = Get.put(HomeController());

  void initState() {
    super.initState();
    homeController.getProfile();
  }
  final TextEditingController dobController = TextEditingController();
  String? selectedGender;

   TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Personal',
          fontsize: 24.sp,
          fontWeight: FontWeight.w600,
          color: goldColor,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Obx(()=>
           SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Avatar",
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorFFFFFF,
                    ),
                    CustomProfileAvatarImage(
                      imagePath: homeController.profile.value.profile?.avatar != null &&
                          homeController.profile.value.profile!.avatar!.isNotEmpty
                          ? homeController.profile.value.profile!.avatar!
                          : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                    ),
                  ],
                ),
                Divider(color: goldColor, thickness: 1, height: 24.h),

                // Nickname
                CustomText(
                  text: "Nickname",
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorFFFFFF,
                ),
                SizedBox(height: 8.h),
                inputBox(homeController.profile.value.profile?.nickname ?? 'N/A'),
                Divider(color: goldColor, thickness: 1, height: 24.h),

                // About
                CustomText(
                  text: "About",
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorFFFFFF,
                ),
                SizedBox(height: 8.h),
                inputBox(homeController.profile.value.profile?.aboutself?? 'N/A', maxLines: 4),
                Divider(color: goldColor, thickness: 1, height: 24.h),

                // Date of Birth
                CustomText(
                  text: "Date of Birth",
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorFFFFFF,
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: dobController,
                  readOnly: true,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: homeController.profile.value.profile?.dateofBirth != null
                        ? DateFormat("d MMMM yyyy").format(
                      DateTime.parse('${homeController.profile.value.profile!.dateofBirth!}'),
                    )
                        : 'N/A',
                    hintStyle:
                    TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
                    filled: true,
                    fillColor: fieldBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                Divider(color: goldColor, thickness: 1, height: 24.h),

                // Gender
                CustomText(
                  text: "Gender",
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorFFFFFF,
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: dobController,
                  readOnly: true,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: homeController.profile.value.profile?.gender?? 'N/A',
                    hintStyle:
                    TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
                    filled: true,
                    fillColor: fieldBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 50.h),

                Center(
                  child: CustomButton(
                    title: 'Edit Profile',
                    onpress: () {
                      context.pushNamed(AppRoutes.personalScreenUpdate,
                        extra: {
                          "avatar": homeController.profile.value.profile?.avatar?.isNotEmpty == true
                              ? homeController.profile.value.profile!.avatar!
                              : "",
                          "aboutself": homeController.profile.value.profile?.aboutself ?? '',
                          "dateofBirth": homeController.profile.value.profile?.dateofBirth?.toIso8601String() ?? '',
                          "gender": homeController.profile.value.profile?.gender,
                          "nickname": homeController.profile.value.profile?.nickname ?? '',
                        }
                      );
                    },
                    width: 245.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable dark input field
  Widget inputBox(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
        filled: true,
        fillColor: fieldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
