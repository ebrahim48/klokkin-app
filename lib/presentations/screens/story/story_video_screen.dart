import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import '../../../core/config/app_routes/app_routes.dart';
import '../../widgets/image_story_list_widget.dart';
import '../../widgets/image_story_widget.dart';
import '../../widgets/video_list_widget.dart';
import '../../widgets/video_story_list_widget.dart';





class StoryVideoScreen extends StatefulWidget {
  const StoryVideoScreen({super.key});

  @override
  State<StoryVideoScreen> createState() => _StoryVideoScreenState();
}

class _StoryVideoScreenState extends State<StoryVideoScreen> {

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
                    return VideoStoryCard(
                      title: " The Silent Typists of a Wired Era",
                      imagePath: "assets/images/videoStory.png",
                      timestamp: "4h ago",
                      readingTime: "21m read",
                      onTap: () {
                        context.pushNamed(AppRoutes.storyVideoDetailsScreen);
                        // Example navigation
                        // context.pushNamed(AppRoutes.storyDetails, extra: {...});
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
                  itemCount: 6,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return VideoListCard(
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



