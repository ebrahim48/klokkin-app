import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../core/config/app_routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/story_libray_data_model.dart';
import '../../widgets/audio_book_card.dart';
import '../../widgets/custom_text.dart';


class StoryAudioBookScreen extends StatefulWidget {
  const StoryAudioBookScreen({super.key});

  @override
  State<StoryAudioBookScreen> createState() => _StoryAudioBookScreenState();
}

class _StoryAudioBookScreenState extends State<StoryAudioBookScreen> {
  final AudioBookController controller = Get.put(AudioBookController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getLibraryStoryData();
    });

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
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomText(
                  text: 'Audio Book',
                  fontsize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.buttonColorE8A533,
                ),
              ),
              SizedBox(height: 25.h),



              Obx(() {
                // Filter only audio type data and keep track of original indices
                final audioBooks = <Map<String, dynamic>>[];
                for (int i = 0; i < controller.libraryStoryData.length; i++) {
                  if (controller.libraryStoryData[i].type?.toLowerCase() == 'audio') {
                    audioBooks.add({
                      'index': i,
                      'data': controller.libraryStoryData[i]
                    });
                  }
                }

                if (audioBooks.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: "Audio Book Data Unavailable",
                      textAlign: TextAlign.center,
                      color: AppColors.textColorC2C2C2,
                    ),
                  );
                }
                return SizedBox(
                  height: 650.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: audioBooks.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final item = audioBooks[index];
                      final originalIndex = item['index'] as int;
                      final audioBook = item['data'] as StoryLibraryDataModel;

                      // Wrap each AudioBookCard in its own Obx to make it reactive to audio state changes
                      return Obx(() {
                        final isCurrentPlaying = controller.currentPlayingIndex.value == originalIndex;

                        return AudioBookCard(
                          title: audioBook.caption ?? 'N/A',
                          subtitle: audioBook.duration ?? 'N/A',
                          currentTime: isCurrentPlaying
                              ? controller.formatDuration(controller.currentPosition.value)
                              : null,
                          imagePath: audioBook.thumbnail ??
                              "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                          isPlaying: isCurrentPlaying && controller.isPlaying.value,
                          onPlayPause: () {
                            final audioUrl = audioBook.mediaUrl != null &&
                                audioBook.mediaUrl!.isNotEmpty
                                ? audioBook.mediaUrl!.first
                                : "";

                            if (audioUrl.isNotEmpty) {
                              controller.toggleAudio(originalIndex, audioUrl);
                            }
                          },
                          onTap: () {
                            context.pushNamed(
                              AppRoutes.storyAudioScreen,
                              extra: {
                                "caption": audioBook.caption ?? "",
                                "duration": audioBook.duration ?? "",
                                "imagePath": audioBook.thumbnail ??
                                    "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                              },
                            );
                          },
                        );
                      });
                    },
                  ),
                );
              }),
              // Obx((){
              //
              //   if (controller.libraryStoryData.isEmpty) {
              //     return Center(
              //       child: CustomText(
              //         text: "Audio Book Data Unavailable",
              //         textAlign: TextAlign.center,
              //         color: AppColors.textColorC2C2C2,
              //       ),
              //     );
              //   }
              //   return SizedBox(
              //     height: 650.h,
              //     child: ListView.separated(
              //       padding: EdgeInsets.symmetric(horizontal: 20.w),
              //       itemCount: controller.libraryStoryData.length,
              //       separatorBuilder: (context, index) => SizedBox(height: 12.h),
              //       itemBuilder: (context, index) {
              //         final audioBook = controller.libraryStoryData[index];
              //         return AudioBookCard(
              //           title: audioBook.caption ?? 'N/A',
              //           subtitle: audioBook.duration ?? 'N/A',
              //           imagePath: audioBook.mediaUrl != null && audioBook.mediaUrl!.isNotEmpty
              //               ? audioBook.mediaUrl!.first
              //               : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
              //           isPlaying: index == 1,
              //           // isPlaying: controller.isPlayingList[index],
              //           onTap: () {
              //             context.pushNamed(
              //                 AppRoutes.storyAudioScreen,
              //                 extra: {
              //                   "caption": audioBook.caption ??"",
              //                   "duration": audioBook.duration ??"",
              //                   "imagePath": audioBook.mediaUrl != null && audioBook.mediaUrl!.isNotEmpty
              //                       ? audioBook.mediaUrl!.first
              //                       : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png" ??"",
              //
              //
              //                 }
              //             );
              //           },
              //         );
              //       },
              //     ),
              //   );
              // }),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }


}



