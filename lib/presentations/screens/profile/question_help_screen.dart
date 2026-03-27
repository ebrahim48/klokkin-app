import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import '../../../controllers/profile_controller.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/custom_text.dart';

class QuestionHelpScreen extends StatefulWidget {
  const QuestionHelpScreen({super.key});

  @override
  State<QuestionHelpScreen> createState() => _QuestionHelpScreenState();
}

class _QuestionHelpScreenState extends State<QuestionHelpScreen> {

  ProfileController profileController = Get.put(ProfileController());

  void initState() {
    super.initState();
    profileController.termsCondition();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: CustomText(
          text: 'Terms & Conditions',
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
              profileController.getTermsConditionLoading.value
                  ?  CustomLoader(top: 20.h)
                  : profileController.terms.isEmpty
                  ? Center(child: CustomText(text: "No Data Found!", top: 600.h))
                  :
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      HtmlWidget(
                          profileController.terms.value,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColorFFFFFF,
                            fontSize: 14.h,
                          )),

                      // CustomText(
                      //   textAlign: TextAlign.start,
                      //   text: '${profileController.terms.value}',
                      //   fontsize: 16.sp,
                      //   fontWeight: FontWeight.w500,
                      //   color: AppColors.textColorFFFFFF,
                      //   maxline: 10,
                      // ),


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
