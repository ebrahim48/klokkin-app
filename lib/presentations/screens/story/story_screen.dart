import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../core/constants/app_colors.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/custom_profile_image.dart';
import '../../widgets/latest_card_widget.dart';
import '../../widgets/work_card_widget.dart';


class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Assets.icons.storyIcon.svg()),
              SizedBox(height: 7.h),
              Align(
                alignment: Alignment.center,
                child: CustomText(
                  text: 'Story Spark Studio',
                  color: AppColors.textColorFFFFFF,
                  fontsize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomText(
                  textAlign: TextAlign.center,
                  text: 'Every story holds a world within it, waiting to be discovered.Through stories, we live a thousand\n lives in one lifetime.',
                  color: AppColors.textColor919191,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w500,
                  maxline: 2,
                ),
              ),

              /// ==============================> Categories ===================================>
              SizedBox(height: 30.h),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomText(
                  textAlign: TextAlign.start,
                  text: 'Categories of stories',
                  color: AppColors.buttonColorE8A533,
                  fontsize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),


              /// =====================================> Categories Scroll =====================================>

              SizedBox(height: 11.h),
              SizedBox(
                height: 180.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: 6,
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    return LatestCard(
                      title: "Factory Life",
                      caption: "Forging the Future in the Glow of the past",
                      imagePath: "assets/images/unsplash.png",
                      onTap: () {
                        // Example navigation
                        // context.pushNamed(AppRoutes.storyDetails, extra: {...});
                      },
                    );
                  },
                ),
              ),

              // /// =====================================> Working Scroll =====================================>
              // SizedBox(height: 21.h),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 20.w),
              //   child: CustomText(
              //     text: 'The Working Stories',
              //     color: AppColors.textColorFFFFFF,
              //     fontWeight: FontWeight.w500,
              //     fontsize: 20.sp,
              //   ),
              // ),
              // SizedBox(height: 11.h),
              // SizedBox(
              //   height: 180.h,
              //   child: ListView.separated(
              //     scrollDirection: Axis.horizontal,
              //     padding: EdgeInsets.symmetric(horizontal: 20.w),
              //     itemCount: 6,
              //     separatorBuilder: (context, index) => SizedBox(width: 12.w),
              //     itemBuilder: (context, index) {
              //       return WorkCard(
              //         title: "Industry\nLife",
              //         duration: "12 min",
              //         imagePath: "assets/images/unsplashWork.png",
              //         videoPath: "assets/videos/your_video.mp4",
              //         onTap: () {
              //
              //         },
              //       );
              //     },
              //   ),
              // ),
              // SizedBox(height: 5.h),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 20.w),
              //   child: CustomText(
              //     text: 'Every story begins with a step',
              //     color: AppColors.textColorFFFFFF,
              //     fontWeight: FontWeight.w500,
              //     fontsize: 20.sp,
              //   ),
              // ),








              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}



