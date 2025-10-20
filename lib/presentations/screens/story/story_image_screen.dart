import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../core/config/app_routes/app_routes.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/image_story_list_widget.dart';
import '../../widgets/image_story_widget.dart';





class StoryImageScreen extends StatefulWidget {
  const StoryImageScreen({super.key});

  @override
  State<StoryImageScreen> createState() => _StoryImageScreenState();
}

class _StoryImageScreenState extends State<StoryImageScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AudioBookController controller = Get.put(AudioBookController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getLibraryStoryData();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgColor20272E,
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Obx((){
          if (controller.getLibraryStoryLoading.value) {
            return const Center(child: CustomLoader());
          }

          if (controller.libraryStoryData.isEmpty) {
            return Center(
              child: CustomText(
                text: "Data Unavailable",
                textAlign: TextAlign.center,
                color: AppColors.textColorC2C2C2,
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  height: 250.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: controller.libraryStoryData.length,
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final libraryData = controller.libraryStoryData[index];
                      return ImageStoryCard(
                        title: libraryData.caption ?? 'N/A',
                        caption: libraryData.description ?? 'N/A',
                        imagePath: libraryData.mediaUrl != null && libraryData.mediaUrl!.isNotEmpty
                            ? libraryData.mediaUrl!.first
                            : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                        timestamp: libraryData.duration ?? 'N/A',
                        onTap: () {
                          context.pushNamed(
                              AppRoutes.storyImageDetailsScreen,
                              extra: {
                                "id": libraryData.id ?? "",
                                "caption": libraryData.caption ??"",
                                "duration": libraryData.description ??"",
                                "imagePath": libraryData.mediaUrl != null && libraryData.mediaUrl!.isNotEmpty
                                    ? libraryData.mediaUrl!.first
                                    : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png" ??"",


                              }
                          );
                        },
                      );
                    },
                  ),
                ),

                Padding(
                  padding:  EdgeInsets.only(left: 20.w,right: 15.h),
                  child: Divider(
                    color: AppColors.secondary836531,
                    height: 0.4.h,
                    thickness: 0.6,
                  ),
                ),

                SizedBox(height: 16.h),

                SizedBox(
                  height: 400.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: controller.libraryStoryData.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final libraryData = controller.libraryStoryData[index];
                      return ImageListCard(
                        title:  libraryData.caption ?? 'N/A',
                        subtitle:  libraryData.description ?? 'N/A',
                        meta: libraryData.duration ?? 'N/A',
                        hashtags: (libraryData.tags is List)
                            ? (libraryData.tags as List).join(", ")
                            : (libraryData.tags?.toString() ?? 'N/A'),
                        imagePath: libraryData.mediaUrl != null && libraryData.mediaUrl!.isNotEmpty
                            ? libraryData.mediaUrl!.first
                            : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                        onTap: () {

                        },
                      );
                    },
                  ),
                ),


                SizedBox(height: 10.h),
              ],
            ),
          );
        }

        ),
      ),
    );
  }


}



