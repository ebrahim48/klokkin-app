import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../controllers/home_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../../services/api_constants.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/custom_network_image.dart';
import '../../widgets/custom_profile_image.dart';
import '../../widgets/latest_card_widget.dart';
import '../../widgets/work_card_widget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  HomeController homeController = Get.put(HomeController());

  void initState() {
    super.initState();
    homeController.getLatestForm();
    homeController.getMyStory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 80.w,
        leading:  Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: const CustomProfileImage(
                imageUrl:
                'https://media.licdn.com/dms/image/v2/C4E03AQGAvYAY6kdVXQ/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1603315936568?e=1758758400&v=beta&t=QeIvlqHz22MKUgXX6U56FSocAyZYGAA5NUi3CMb_alQ',
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    // context.pushNamed(AppRoutes.locationMapScreen);
                  },
                  child:
                  Assets.icons.notification.svg(
                      width: 32.w,
                      height: 32.h
                  ),
                ),
                SizedBox(width: 6.w),
              ],
            ),
          ),
        ],

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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Divider(
                  thickness: 1,
                  color: const Color(0x36D09F48),
                  height: 0.h,
                ),
              ),

              /// =====================================> Card =====================================>
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SizedBox(
                  width: 391.w,
                  height: 23.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      CustomText(
                        text: 'Create a story',
                        color: AppColors.textColorFFFFFF,
                        fontsize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {

                        },
                        child: CustomText(
                          text: 'View all',
                          color: AppColors.buttonColorE8A533,
                          fontsize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// =====================================> Create Story =====================================>
              SizedBox(height: 16.h),

              /// =====================================> Create Story Section ======================================>
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Obx(() {
                  final hasStories = homeController.myStory.isNotEmpty;

                  return Row(
                    children: [
                      /// =============================> Always Create Story Box
                      Container(
                        width: 100,
                        height: 160,
                        margin: EdgeInsets.only(right: 12.w),
                        decoration: BoxDecoration(
                          color: AppColors.textColorFFFFFF,
                          borderRadius: BorderRadius.circular(4.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x40747474),
                              offset: const Offset(2, 2),
                              blurRadius: 4.r,
                            ),
                            BoxShadow(
                              color: const Color(0x40747474),
                              offset: const Offset(-2, -2),
                              blurRadius: 4.r,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.pushNamed(
                                  AppRoutes.startCreateStoryScreen,
                                  extra: {"title": "Lets get started!"},
                                );
                              },
                              child: Container(
                                width: 71,
                                height: 71,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Center(
                                  child: Assets.icons.plusSquare.svg(
                                    width: 72.w,
                                    height: 72.h,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            CustomText(
                              text: "Create Story",
                              fontsize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor000000,
                            ),
                          ],
                        ),
                      ),

                      /// =============================> Show Story Card only if exists
                      if (hasStories)
                        Container(
                          width: 94.w,
                          height: 146.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF323539),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Container(
                              width: 82.w,
                              height: 126.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF20272E),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
                                    child: CustomNetworkImage(
                                      imageUrl: homeController.myStory.first.mediaUrl?.isNotEmpty == true
                                          ? homeController.myStory.first.mediaUrl!.first
                                          : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                                      width: 82.w,
                                      height: 70.h,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),

                                  /// Title
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                                    child: CustomText(
                                      text: (homeController.myStory.first.tags != null &&
                                          homeController.myStory.first.tags!.isNotEmpty)
                                          ? homeController.myStory.first.tags!.join(", ")
                                          : "N/A",
                                      fontsize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.buttonColorE8A533,
                                      maxline: 1,
                                    ),
                                  ),

                                  /// Description
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                    child: CustomText(
                                      textAlign: TextAlign.start,
                                      text: homeController.myStory.first.description ?? "N/A",
                                      fontsize: 10.sp,
                                      fontWeight: FontWeight.w300,
                                      color: AppColors.textColor919191,
                                      maxline: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),

              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 20.w),
              //   child: Obx(() {
              //     final hasStories = homeController.myStory.isNotEmpty;
              //
              //     if (!hasStories) {
              //       /// ====================================> Create Story Box
              //       return Padding(
              //         padding: EdgeInsets.symmetric(horizontal: 20.w),
              //         child: Container(
              //           width: 100,
              //           height: 160,
              //           decoration: BoxDecoration(
              //             color: AppColors.textColorFFFFFF,
              //             borderRadius: BorderRadius.circular(4.r),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: const Color(0x40747474),
              //                 offset: const Offset(2, 2),
              //                 blurRadius: 4.r,
              //               ),
              //               BoxShadow(
              //                 color: const Color(0x40747474),
              //                 offset: const Offset(-2, -2),
              //                 blurRadius: 4.r,
              //               ),
              //             ],
              //           ),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               GestureDetector(
              //                 onTap: () {
              //                   context.pushNamed(
              //                     AppRoutes.startCreateStoryScreen,
              //                     extra: {"title": "Lets get started!"},
              //                   );
              //                 },
              //                 child: Container(
              //                   width: 71,
              //                   height: 71,
              //                   decoration: BoxDecoration(
              //                     color: Colors.grey.shade400.withOpacity(0.9),
              //                     borderRadius: BorderRadius.circular(4.r),
              //                   ),
              //                   child: Center(
              //                     child: Assets.icons.plusSquare.svg(
              //                       width: 72.w,
              //                       height: 72.h,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               SizedBox(height: 20.h),
              //               CustomText(
              //                 text: "Create Story",
              //                 fontsize: 12.sp,
              //                 fontWeight: FontWeight.w600,
              //                 color: AppColors.textColor000000,
              //               ),
              //             ],
              //           ),
              //         ),
              //       );
              //     } else {
              //       /// ====================================> Story Card
              //
              //       final story = homeController.myStory.first;
              //       return Container(
              //         width: 94.w,
              //         height: 146.h,
              //         decoration: BoxDecoration(
              //           color: const Color(0xFF323539),
              //           borderRadius: BorderRadius.circular(8.r),
              //         ),
              //         child: Center(
              //           child: Container(
              //             width: 82.w,
              //             height: 126.h,
              //             decoration: BoxDecoration(
              //               color: const Color(0xFF20272E),
              //               borderRadius: BorderRadius.circular(4.r),
              //             ),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 /// Image
              //                 ClipRRect(
              //                   borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
              //                   child: CustomNetworkImage(
              //                     imageUrl: story.mediaUrl?.isNotEmpty == true
              //                         ? story.mediaUrl!.first
              //                         : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
              //                     width: 82.w,
              //                     height: 70.h,
              //                   ),
              //                 ),
              //                 SizedBox(height: 6.h),
              //
              //                 /// Title
              //                 Padding(
              //                   padding: EdgeInsets.symmetric(horizontal: 6.w),
              //                   child: CustomText(
              //                     text: (story.tags != null && story.tags!.isNotEmpty)
              //                         ? story.tags!.join(", ")
              //                         : "N/A",
              //                     fontsize: 12.sp,
              //                     fontWeight: FontWeight.w600,
              //                     color: AppColors.buttonColorE8A533,
              //                     maxline: 1,
              //                   ),
              //                 ),
              //
              //                 /// Description
              //                 Padding(
              //                   padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              //                   child: CustomText(
              //                     textAlign: TextAlign.start,
              //                     text: story.description ?? "N/A",
              //                     fontsize: 10.sp,
              //                     fontWeight: FontWeight.w300,
              //                     color: AppColors.textColor919191,
              //                     maxline: 2,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       );
              //     }
              //   }),
              // ),


              /// =====================================> Latest Scroll =====================================>
              SizedBox(height: 19.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomText(
                  text: 'The Latest From Klokk-in',
                  color: AppColors.textColorFFFFFF,
                  fontWeight: FontWeight.w500,
                  fontsize: 20.sp,
                ),
              ),
              SizedBox(height: 11.h),
              Obx((){
                if (homeController.getLatestFormLoading.value) {
                  return const Center(child: CustomLoader());
                }

                if (homeController.latestForm.isEmpty) {
                  return CustomText(
                    text: "Latest Form available",
                    color: AppColors.textColorC2C2C2,
                  );
                }
                return SizedBox(
                  height: 180.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: homeController.latestForm.length,
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final latest = homeController.latestForm[index];
                      return LatestCard(
                        title: latest.caption ?? 'N/A',
                        caption:latest.description ?? 'N/A',
                        imagePath: latest.mediaUrl != null && latest.mediaUrl!.isNotEmpty
                            ? latest.mediaUrl!.first
                            : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                        onTap: () {

                        },
                      );
                    },
                  ),
                );
              }),
          
              /// =====================================> Working Scroll =====================================>
              SizedBox(height: 21.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomText(
                  text: 'The Working Stories',
                  color: AppColors.textColorFFFFFF,
                  fontWeight: FontWeight.w500,
                  fontsize: 20.sp,
                ),
              ),
              SizedBox(height: 11.h),
              SizedBox(
                height: 180.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: 6,
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    return WorkCard(
                      title: "Industry\nLife",
                      duration: "12 min",
                      imagePath: "assets/images/unsplashWork.png",
                      videoPath: "assets/videos/your_video.mp4",
                      onTap: () {

                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomText(
                  text: 'Every story begins with a step',
                  color: AppColors.textColorFFFFFF,
                  fontWeight: FontWeight.w500,
                  fontsize: 20.sp,
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



