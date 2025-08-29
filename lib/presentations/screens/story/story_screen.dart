import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/audio_book_card.dart';
import '../../widgets/category_widget.dart';



class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final AudioBookController controller = Get.put(AudioBookController());
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
                height: 120.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: 12,
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      title: index.isEven ? "Image Story World" : "Audio Story",
                      subtitle: "100 Stories",
                      imagePath: "assets/images/category.png",
                      onTap: () {
                        context.pushNamed(AppRoutes.storyImageScreen);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 27.h),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomText(
                  text: 'Audio Book',
                  fontsize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.buttonColorE8A533,
                ),
              ),
              SizedBox(height: 9.h),
              /// =====================================> Audio Book Scroll =====================================>

              SizedBox(
                height: 400.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: 6,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return AudioBookCard(
                      title: "Stories from the Desk",
                      subtitle: "Audio 1hr 30m",
                      imagePath: "assets/images/stories.png",
                      isPlaying: index == 1,
                      // isPlaying: controller.isPlayingList[index],
                      onTap: () {
                        context.pushNamed(AppRoutes.storyAudioScreen);
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }


}



