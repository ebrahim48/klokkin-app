import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import '../../widgets/custom_text.dart';

class QuestionHelpScreen extends StatefulWidget {
  const QuestionHelpScreen({super.key});

  @override
  State<QuestionHelpScreen> createState() => _QuestionHelpScreenState();
}

class _QuestionHelpScreenState extends State<QuestionHelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: CustomText(
          text: 'Question & help',
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Got a Question?Were Here',
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorFFFFFF,
                    ),
                    SizedBox(height: 15.h),
                    CustomText(
                      textAlign: TextAlign.start,
                      text: 'Klokk-in is a storytelling platform where your voice, expressions, and visuals matter. To help you record and share your stories effortlessly, we may ask for access to your microphone, camera, and storage. These permissions allow you to speak, capture, and save your stories directly within the app. We only request what’s necessary — nothing more. Your comfort and control come first, and every permission is meant to enhance your storytelling experience, never to invade it.',
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorFFFFFF,
                      maxline: 10,
                    ),
                    SizedBox(height: 15.h),
                    CustomText(
                      text: 'In-APP Help Center',
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorFFFFFF,
                    ),
                    SizedBox(height: 15.h),
                    CustomText(
                      textAlign: TextAlign.start,
                      text: 'To bring your voice and expressions to life, Klokk-in needs access to your device’s microphone and camera. This allows you to record audio stories or capture video moments as you tell them. Without this access, you wont be able to use key storytelling features. We do not record anything in the background — only when you choose to start. You’re always in charge of what gets recorded and shared. Your story, your control.',
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorFFFFFF,
                      maxline: 10,
                    ),
                    SizedBox(height: 15.h),
                    CustomText(
                      text: 'Still Need Help?Contact Us',
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorFFFFFF,
                    ),
                    SizedBox(height: 15.h),
                    CustomText(
                      textAlign: TextAlign.start,
                      text: 'Klokk-in may request access to your devices storage to help you save your recordings or upload images and videos to support your stories. This permission allows you to browse your gallery, choose existing media, and save new stories directly to your phone. We never touch or access files unless you select them yourself. Your personal content stays private and secure — and only you decide what’s shared within the app.',
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorFFFFFF,
                      maxline: 10,
                    ),

                    SizedBox(height: 15.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
