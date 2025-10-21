import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../controllers/work_controller.dart';
import '../../../core/config/app_routes/app_routes.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/video_list_widget.dart';
import '../../widgets/video_story_list_widget.dart';





class StoryVideoScreen extends StatefulWidget {
  const StoryVideoScreen({super.key});

  @override
  State<StoryVideoScreen> createState() => _StoryVideoScreenState();
}

class _StoryVideoScreenState extends State<StoryVideoScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final AudioBookController controller = Get.put(AudioBookController());
  WorkCardController workCardController = Get.put(WorkCardController());

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
                      return VideoStoryCard(
                        title: libraryData.caption ?? 'N/A',
                        imagePath: libraryData.mediaUrl != null && libraryData.mediaUrl!.isNotEmpty
                            ? libraryData.mediaUrl!.first
                            : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                        timestamp: "4h ago",
                        readingTime: "21m read",
                        videoPath: libraryData.mediaUrl != null && libraryData.mediaUrl!.isNotEmpty
                            ? libraryData.mediaUrl!.first
                            : "",
                        onTap: () {

                          if (libraryData.mediaUrl != null && libraryData.mediaUrl!.isNotEmpty) {
                            context.pushNamed(
                                AppRoutes.storyVideoDetailsScreen,
                                extra: {
                                  "videoUrl": libraryData.mediaUrl!.first,
                                  "title": libraryData.caption ?? 'N/A',
                                  "timestamp": "4h ago",
                                  "readingTime": "21m read",
                                }
                            );
                          }
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 12.h,),

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
                      return VideoListCard(
                        title: libraryData.caption ?? 'N/A',
                        subtitle: libraryData.description ?? 'N/A',
                        meta: "4h ago • 21m read",
                        hashtags: (libraryData.tags is List)
                            ? (libraryData.tags as List).join(", ")
                            : (libraryData.tags?.toString() ?? 'N/A'),
                        imagePath: "assets/images/imagelist.png",
                        onTap: () {
                          // context.pushNamed(AppRoutes.storyAudioScreen);
                        },
                      );
                    },
                  ),
                ),


                SizedBox(height: 10.h),
              ],
            ),
          );
        })


      ),
    );
  }


}



