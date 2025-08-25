import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../../core/config/app_routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../widgets/custom_button.dart';


class StartCreateStoryScreen extends StatelessWidget {
  StartCreateStoryScreen({super.key});


  @override
  Widget build(BuildContext context) {
    Map routeData = GoRouterState.of(context).extra as Map;
    return Scaffold(
      appBar: CustomAppBar(title: "${routeData["title"]}"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 66.h),

              /// ============================================ Button ====================================>

              CustomButton(title: "Create My Story",
                  onpress: () {
                    context.pushNamed(AppRoutes.verifyScreen, extra: {
                      "title" : "Verification",

                    });
                    // Get.toNamed(AppRoutes.optScreen, arguments: {"screenType" : "Sign up"});
                  }),
              SizedBox(height: 22.h),
              CustomButton(
                title: 'Record Now',
                onpress: () {
                  context.pushNamed(AppRoutes.signUpScreen);

                },
                color: AppColors.textColorFFFFFF,
                titlecolor: AppColors.buttonColorE8A533,
                borderRadius: 8.r,
                borderColor: AppColors.buttonColorE8A533,
              ),
              SizedBox(height: 32.h),
              Align(
                alignment: Alignment.center,
                child: CustomText(
                  text: 'Record your story in the Klokk-in app',
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color:  AppColors.buttonColorE8A533,
                ),
              ),
              SizedBox(height: 115.h),  /// ===================================> START CARDS ====================================>
              SizedBox(
                height: 300.h,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.85),
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: StoryCard(
                        image: story["image"]!,
                        title: story["title"]!,
                        desc: story["desc"]!,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 15.h),
              /// =============================> Page Indicator =============================>
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: index == 1 ? 20.w : 8.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: index == 1
                            ? AppColors.buttonColorE8A533
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    );
                  }),
                ),
              ),


              SizedBox(height: 50.h)
            ],
          ),
        ),
      ),
    );
  }

  final List<Map<String, String>> stories = [
    {
      "image": "assets/images/create.png",
      "title": "Innovation Finds Its Space",
      "desc":
      "In this modern workspace, ideas flow freely. Every desk holds the start of a new story.",
    },
    {
      "image": "assets/images/create.png",
      "title": "Collaboration Zone",
      "desc": "Work together, share ideas, and create something amazing every day.",
    },
    {
      "image": "assets/images/create.png",
      "title": "Creative Hub",
      "desc": "This space fuels creativity and sparks innovation for every team.",
    },
  ];

}




class StoryCard extends StatelessWidget {
  final String image;
  final String title;
  final String desc;

  const StoryCard({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 356.w,
      height: 242.h,
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          /// ================= Image Positioned =================
          Positioned(
            top: 12.h,
            left: 38.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                image,
                width: 160.w,
                height: 120.h,
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// ================= Text + Button =================
          Positioned(
            top: 150.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 6.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    desc,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.h),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppColors.buttonColorE8A533,
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 22.w,
                      vertical: 6.h,
                    ),
                  ),
                  child: Text(
                    "START",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.buttonColorE8A533,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
