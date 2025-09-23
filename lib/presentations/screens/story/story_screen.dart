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
import '../../widgets/custom_loader.dart';



class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final AudioBookController controller = Get.put(AudioBookController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    controller.getLibraryStoryData();
  }

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
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(AppRoutes.storyVideoScreen);
                  },
                  child: CustomText(
                    text: 'Story Spark Studio',
                    color: AppColors.textColorFFFFFF,
                    fontsize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
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
              Obx((){
                if (controller.getLibraryStoryLoading.value) {
                  return const Center(child: CustomLoader());
                }

                if (controller.libraryStoryData.isEmpty) {
                  return CustomText(
                    text: "Library Story Data Unavailable",
                     textAlign: TextAlign.center,
                    color: AppColors.textColorC2C2C2,
                  );
                }
                return SizedBox(
                  height: 120.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: controller.libraryStoryData.length,
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final library = controller.libraryStoryData[index];

                      final subtitleText = () {
                        switch (library.type) {
                          case "audio":
                            return "${controller.audioMeta.value?.total ?? 0} Stories";
                          case "video":
                            return "${controller.videoMeta.value?.total ?? 0} Stories";
                          case "image":
                            return "${controller.imageMeta.value?.total ?? 0} Stories";
                          default:
                            return "0 Stories";
                        }
                      }();

                      final imagePath = () {
                        switch (library.type) {
                          case "audio":
                            return "assets/images/audioimage.png";
                          case "video":
                            return "assets/images/videoimage.png";
                          case "image":
                            return "assets/images/imageworld.png";
                          default:
                            return "assets/images/default.png";
                        }
                      }();

                      return CategoryCard(
                        title: library.type ?? 'N/A',
                        subtitle: subtitleText,
                        imagePath: imagePath,
                        onTap: () {
                          context.pushNamed(AppRoutes.storyAudioScreen);
                        },
                      );
                    },
                  ),
                );


              }),
              SizedBox(height: 27.h),

              /// =====================================> Audio Book Scroll =====================================>

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

              Obx((){
                // if (controller.getLibraryStoryLoading.value) {
                //   return const Center(child: CustomLoader());
                // }

                if (controller.libraryStoryData.isEmpty) {
                  return CustomText(
                    text: "Audio Book Data Unavailable",
                    textAlign: TextAlign.center,
                    color: AppColors.textColorC2C2C2,
                  );
                }
               return SizedBox(
                  height: 400.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: controller.libraryStoryData.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final audioBook = controller.libraryStoryData[index];
                      return AudioBookCard(
                        title: audioBook.caption ?? 'N/A',
                        subtitle: "Audio 1hr 30m",
                        imagePath: audioBook.mediaUrl != null && audioBook.mediaUrl!.isNotEmpty
                            ? audioBook.mediaUrl!.first
                            : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                        isPlaying: index == 1,
                        // isPlaying: controller.isPlayingList[index],
                        onTap: () {
                          context.pushNamed(
                              AppRoutes.storyAudioScreen,
                            extra: {
                                "caption": audioBook.caption ??"",
                              "imagePath": audioBook.mediaUrl != null && audioBook.mediaUrl!.isNotEmpty
                                  ? audioBook.mediaUrl!.first
                                  : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png" ??"",


                            }
                          );
                        },
                      );
                    },
                  ),
                );
              }

              ),




              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }


}



