import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';

import '../../../core/config/app_routes/app_routes.dart';
import '../../widgets/audio_book_card.dart';
import '../../widgets/image_story_list_widget.dart';
import '../../widgets/image_story_widget.dart';





class StoryImageScreen extends StatefulWidget {
  const StoryImageScreen({super.key});

  @override
  State<StoryImageScreen> createState() => _StoryImageScreenState();
}

class _StoryImageScreenState extends State<StoryImageScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgColor20272E,
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 250.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: 6,
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    return ImageStoryCard(
                      title: "Innovation Finds Its Space",
                      caption: "In this modern workspace, ideas flow freely.",
                      imagePath: "assets/images/imageStory.png",
                      timestamp: "4h ago",
                      readingTime: "21m read",
                      onTap: () {
                        // Example navigation
                        // context.pushNamed(AppRoutes.storyDetails, extra: {...});
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
                  itemCount: 6,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return ImageListCard(
                      title: "Innovation Finds Its Space",
                      subtitle:
                      "In this modern workspace, ideas flow freely. Every desk holds the start of a new story.",
                      meta: "4h ago • 21m read",
                      hashtags: "#Innovation   #tech   #engineer   #2010s",
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
        ),
      ),
    );
  }


}



