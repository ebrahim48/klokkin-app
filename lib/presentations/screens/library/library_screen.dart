import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:video_player/video_player.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/library_controller.dart';
import '../../../controllers/work_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/border_button.dart';
import '../../widgets/custom_network_image.dart';


class LibraryScreen extends StatefulWidget {
  final String videoPath;
   LibraryScreen({super.key,required this.videoPath});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  HomeController homeController = Get.put(HomeController());
  final controller = Get.put(WorkCardController());
  final workController = Get.put(WorkCardLibraryController());



  void initState() {
    super.initState();
    homeController.getWorkingDays();
    // controller.setVideoPath(widget.videoPath);
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
                          style:  const TextStyle(color: AppColors.textColorFFFFFF),
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
                      child: Obx(() {
                        if (workController.isInitialized.value) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              /// Video Player
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: AspectRatio(
                                  aspectRatio:
                                  workController.videoController.value.aspectRatio,
                                  child: VideoPlayer(workController.videoController),
                                ),
                              ),


                              /// Play / Pause Button Only
                              Positioned(
                                bottom: 8.h,
                                right: 8.w,
                                child: GestureDetector(
                                  onTap: workController.togglePlayPause,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black54,
                                    ),
                                    padding: EdgeInsets.all(8.r),
                                    child: Obx(
                                          () => Icon(
                                        workController.isPlaying.value
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: 28.r,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          /// Fallback Image
                          return Container(
                            height: 116.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: CustomNetworkImage(
                              imageUrl: homeController.workingDays.first.mediaUrl?.isNotEmpty == true
                                  ? homeController.workingDays.first.mediaUrl!.first
                                  : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                              width: 82.w,
                              height: 70.h,

                            ),
                          );
                        }
                      }),
                    ),



                    SizedBox(width: 14.w),
                    Expanded(
                      child:

                      Container(
                        width: 82.w,
                        height: 116.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: CustomNetworkImage(
                          imageUrl: homeController.workingDays.first.mediaUrl?.isNotEmpty == true
                              ? homeController.workingDays.first.mediaUrl!.first
                              : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                          width: 82.w,
                          height: 70.h,

                        ),
                      )
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
                        child:Container(
                          width: 82.w,
                          height: 116.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: CustomNetworkImage(
                            imageUrl: homeController.myStory.first.mediaUrl?.isNotEmpty == true
                                ? homeController.myStory.first.mediaUrl!.first
                                : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                            width: 82.w,
                            height: 70.h,

                          ),
                        )


                      // Container(
                      //   height: 116.h,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8.r),
                      //     image: const DecorationImage(
                      //       image: AssetImage("assets/images/imageStory.png"),
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Container(
                        height: 116.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: CustomNetworkImage(
                          imageUrl: homeController.workingDays.first.mediaUrl?.isNotEmpty == true
                              ? homeController.workingDays.first.mediaUrl!.first
                              : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                          width: 82.w,
                          height: 70.h,

                        ),
                      )
                    ),


                  ],
                ),
              ),
              /// =====================================> Image 5 =====================================>
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Container(
                  width: 390,
                  height: 120.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: CustomNetworkImage(
                    imageUrl: homeController.workingDays.first.mediaUrl?.isNotEmpty == true
                        ? homeController.workingDays.first.mediaUrl!.first
                        : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                    width: 82.w,
                    height: 70.h,

                  ),
                )
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
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: CustomNetworkImage(
                          imageUrl: homeController.workingDays.first.mediaUrl?.isNotEmpty == true
                              ? homeController.workingDays.first.mediaUrl!.first
                              : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                          width: 82.w,
                          height: 70.h,

                        ),
                      )
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                        child: Container(
                          width: 82.w,
                          height: 160.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: CustomNetworkImage(
                            imageUrl: homeController.workingDays.first.mediaUrl?.isNotEmpty == true
                                ? homeController.workingDays.first.mediaUrl!.first
                                : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                            width: 82.w,
                            height: 70.h,

                          ),
                        )

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
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: CustomNetworkImage(
                    imageUrl: homeController.workingDays.first.mediaUrl?.isNotEmpty == true
                        ? homeController.workingDays.first.mediaUrl!.first
                        : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                    width: 82.w,
                    height: 70.h,

                  ),
                )
              ),

              SizedBox(height: 21.h),

            ],
          ),
        ),
      ),
    );
  }



}



