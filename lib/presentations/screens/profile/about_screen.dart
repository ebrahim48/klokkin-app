import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import '../../../controllers/profile_controller.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/custom_text.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  ProfileController profileController = Get.put(ProfileController());

  void initState() {
    super.initState();
    profileController.aboutUs();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: CustomText(
          text: 'About',
          fontsize:24.sp,
          color: AppColors.primaryColorC79235,
          fontWeight: FontWeight.w400,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Obx(()=>
              profileController.getAboutUsLoading.value
                  ?  CustomLoader(top: 20.h)
                  : profileController.about.isEmpty
                  ? Center(child: CustomText(text: "No Data Found!", top: 600.h))
                  :
               Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HtmlWidget(
                          profileController.about.value,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColorFFFFFF,
                            fontSize: 14.h,
                          )),
                    // CustomText(
                    //     textAlign: TextAlign.start,
                    //     text: profileController.about.value,
                    //     fontsize: 16.sp,
                    //     fontWeight: FontWeight.w500,
                    //     color: AppColors.textColorFFFFFF,
                    //     maxline: 10,
                    //   ),
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
