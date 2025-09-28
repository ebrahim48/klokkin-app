import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/border_button.dart';


class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final AudioBookController controller = Get.put(AudioBookController());



  void initState() {
    super.initState();
    controller.getLibraryStoryData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: CustomText(
          text: "Library",
          color: AppColors.textColor987433,
          fontsize: 20.sp,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ==============================> Search ===================================>
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: AppColors.bgColor,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: const Color(0xFFDF9E2F),
                            width: 1,
                          ),
                        ),
                        child: TextFormField(
                          controller: _searchController,
                          style: const TextStyle(color: AppColors.textColor000000),
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: const TextStyle(color: AppColors.textColorFFFFFF),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(6.w),
                              child: Assets.icons.search.svg(width: 16.w, height: 16.h),
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 57.w),

                    SizedBox(
                      width: 35.w,
                      child: Assets.icons.filter.svg(width: 32.w, height: 32.h),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              /// ==============================> Button ===================================>
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [

                    BorderButton(
                      title: "Download",
                      onPressed: () {
                        context.pushNamed(AppRoutes.downloadScreen);
                      },
                    ),

                    SizedBox(width: 12.w),

                    // Bookmark Button
                    BorderButton(
                      title: "Bookmark",
                      onPressed: () {
                        context.pushNamed(AppRoutes.bookmarkScreen);
                      },
                    ),

                    SizedBox(width: 70.w),

                    SizedBox(
                      width: 35.w,
                      child: Assets.icons.dot.svg(width: 22.w, height: 22.h),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Divider(
                  thickness: 1,
                  color: const Color(0x36D09F48),
                  height: 0.h,
                ),
              ),

              /// =====================================> Image 1 and 2 =====================================>
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 116.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/imagelist.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Assets.icons.play.svg(
                            width: 40.w,
                            height: 40.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Container(
                        height: 116.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/imageStory.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// =====================================> Image 3 and 4 =====================================>
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 116.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/imageStory.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Container(
                        height: 116.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/unsplashWork.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Assets.icons.play.svg(
                            width: 40.w,
                            height: 40.h,
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
              /// =====================================> Image 5 =====================================>
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Container(
                  width: 390.w,
                  height: 102.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/videocreate.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Assets.icons.play.svg(
                      width: 40.w,
                      height: 40.h,
                    ),
                  ),
                ),
              ),

              /// =====================================> Image 6 =====================================>
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 160.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/industry.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Container(
                        height: 160.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/imageStory.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// =====================================> Image 10 =====================================>

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Container(
                  width: 390.w,
                  height: 128.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/usplash1.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 21.h),

            ],
          ),
        ),
      ),
    );
  }



}



