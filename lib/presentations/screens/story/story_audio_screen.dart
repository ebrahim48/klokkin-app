import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/custom_audio_progress.dart';
import '../../widgets/custom_network_image.dart';




class StoryAudioScreen extends StatefulWidget {
  const StoryAudioScreen({super.key});

  @override
  State<StoryAudioScreen> createState() => _StoryAudioScreenState();
}

class _StoryAudioScreenState extends State<StoryAudioScreen> {
  final AudioBookController controller = Get.put(AudioBookController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    Map routeData = GoRouterState.of(context).extra as Map;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child:  CustomNetworkImage(
                      imageUrl: "${routeData["imagePath"]}",
                      boxShape: BoxShape.circle,
                      height: 110.h,
                      width: 110.w,
                      border: Border.all(color: AppColors.primaryColorC79235)),

                ),
              ),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.center,
                child: CustomText(
                  text: "${routeData["caption"]}",
                  color: AppColors.textColorFFFFFF,
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 6.h),
              Align(
                alignment: Alignment.center,
                child: CustomText(
                  textAlign: TextAlign.center,
                  text: 'Audio 1hr 30m',
                  color: AppColors.textColor4B4B4B,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 35.h),
              /// ==============================> progress ===================================>

              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: CustomAudioProgressBar(),
              ),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }


}



