import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/custom_image_details_widget.dart';
import '../../widgets/custom_imagedetails_progressbar_widget.dart';
import '../../widgets/custom_profile_image.dart';
import '../../widgets/custom_video_details_widget.dart';



class StoryVideoDetailsScreen extends StatefulWidget {
  StoryVideoDetailsScreen({super.key});

  @override
  State<StoryVideoDetailsScreen> createState() => _StoryVideoDetailsScreenState();
}

class _StoryVideoDetailsScreenState extends State<StoryVideoDetailsScreen> {

  @override
  Widget build(BuildContext context) {
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
                    child:  const CustomProfileImageDetailsImage(
                      imageUrl:
                      'https://media.licdn.com/dms/image/v2/C4E03AQGAvYAY6kdVXQ/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1603315936568?e=1758758400&v=beta&t=QeIvlqHz22MKUgXX6U56FSocAyZYGAA5NUi3CMb_alQ',
                    ),
                  ),
                  SizedBox(width: 11.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(text: 'Ebrahim',color: AppColors.textColorFFFFFF,fontsize: 20.sp,fontWeight: FontWeight.w500),
                          SizedBox(width: 130.w),
                          Assets.icons.editImage.svg(
                          ),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: _showDeleteDialog,
                              child: Assets.icons.deleteimage.svg())
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
                child: Image.asset(
                  "assets/images/imageStory.png",
                  height: 200,
                  width: 400,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.h),
              /// ============================================ line ====================================>
              CustomVideoDetailsProgressBar(),








              SizedBox(height: 50.h)
            ],
          ),
        ),
      ),
    );
  }

  // Function to show the delete confirmation dialog
  void _showDeleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: CustomText(
            text: 'Delete this item!',
            color: AppColors.textColorFFFFFF,
            fontsize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
          actions: <Widget>[
            // Done Button
            Center(
              child: Positioned(
                top: 69.h,
                left: 97.w,
                child: Container(
                  width: 85.w,
                  height: 37.h,
                  decoration: BoxDecoration(
                    color: AppColors.backgColor20272E,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: CustomText(
                      textAlign: TextAlign.center,
                      text: 'Done',
                      color: AppColors.primaryColorC79235,
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
          backgroundColor: AppColors.textColor000000,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        );
      },
    );
  }
}








