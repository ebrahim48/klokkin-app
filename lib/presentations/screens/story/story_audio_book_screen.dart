import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../core/config/app_routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
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

              Obx((){

                if (controller.libraryStoryData.isEmpty) {
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
                    itemCount: controller.libraryStoryData.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final audioBook = controller.libraryStoryData[index];
                      return AudioBookCard(
                        title: audioBook.caption ?? 'N/A',
                        subtitle: audioBook.duration ?? 'N/A',
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
                                "duration": audioBook.duration ??"",
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
              }),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }


}



