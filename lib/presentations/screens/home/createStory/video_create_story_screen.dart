import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../controllers/playback_controller.dart';
import '../../../../core/config/app_routes/app_routes.dart';
import '../../../../global/custom_assets/assets.gen.dart';

class VideoCreateStoryScreen extends StatefulWidget {
  const VideoCreateStoryScreen({super.key});

  @override
  State<VideoCreateStoryScreen> createState() => _VideoCreateStoryScreenState();
}

class _VideoCreateStoryScreenState extends State<VideoCreateStoryScreen> {
  CameraController? _controller;
  bool _isRecording = false;
  bool _isInitialized = false;
  String? _videoPath;
  String _statusMessage = 'Tap to start recording';
  int _recordingDuration = 0;

  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _requestPermissions();

    try {
      cameras = await availableCameras();

      if (cameras.isNotEmpty) {
        _controller = CameraController(
          cameras.first,
          ResolutionPreset.high,
          enableAudio: true,
        );

        await _controller!.initialize();
        setState(() {
          _isInitialized = true;
        });
      } else {
        setState(() {
          _statusMessage = 'No cameras available';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Camera initialization failed: $e';
      });
    }
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();
  }

  Future<void> _startVideoRecording() async {
    if (!_controller!.value.isInitialized) return;

    try {
      await _controller!.startVideoRecording();

      setState(() {
        _isRecording = true;
        _recordingDuration = 0;
        _statusMessage = 'Recording...';
      });

      // Start timer for recording duration
      _startTimer();
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to start recording: $e';
      });
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording && mounted) {
        setState(() {
          _recordingDuration++;
        });
        _startTimer();
      }
    });
  }
/// ============================================> Add Post Details Next Screen =====================================================>
  Future<void> _stopVideoRecording() async {
    if (!_controller!.value.isRecordingVideo) return;

    try {
      final videoFile = await _controller!.stopVideoRecording();

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final savedPath = path.join(directory.path, fileName);

      await File(videoFile.path).copy(savedPath);

      setState(() {
        _isRecording = false;
        _videoPath = savedPath;
        _statusMessage = 'Video saved successfully';
        _recordingDuration = 0;
      });

      if (mounted) {
        context.pushNamed(
            AppRoutes.videoRecordAddPostDetailsScreen,
          extra: {
            "title": "Add Post Details",
            "videoPath": savedPath
          }
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to stop recording: $e';
        _isRecording = false;
        _recordingDuration = 0;
      });
    }
  }

  String _formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            _statusMessage,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full screen camera preview
          Positioned.fill(
            child: CameraPreview(_controller!),
          ),

          // Top bar with time and back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                // CustomText(
                //   '12:00',
                //   style: const TextStyle(
                //     color: Colors.white,
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor:  Color(0xFF0D0D0D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      builder: (context) {
                        return Container(
                          width: 430.w,
                          height: 300.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// Playback Speed
                              GestureDetector(
                                onTap: () {
                                  _showPlaybackSpeedSheet(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Assets.icons.playCircle.svg(width: 32.w, height: 32.h),
                                        SizedBox(width: 12.w),
                                        CustomText(
                                          text: "Playback Speed",
                                          color: AppColors.textColorFFFFFF,
                                          fontWeight: FontWeight.w500,
                                          fontsize: 20.sp,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CustomText(
                                          text: "1X",
                                          color: AppColors.textColor8B8B8B,
                                          fontWeight: FontWeight.w500,
                                          fontsize: 20.sp,
                                        ),
                                        SizedBox(width: 6.w),
                                        Assets.icons.greater.svg(
                                          width: 18.w,
                                          height: 18.h,
                                          color: AppColors.textColor8B8B8B,
                                        ),
                                      ],
                                    )

                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),

                              /// Caption
                              Row(
                                children: [
                                  Assets.icons.caption.svg(width: 32.w, height: 32.h),
                                  SizedBox(width: 12.w),
                                  CustomText(text: "Caption",
                                    color: AppColors.textColorFFFFFF,
                                    fontWeight: FontWeight.w500,
                                    fontsize: 20.sp,),
                                ],
                              ),
                              SizedBox(height: 10.h),

                              /// Lock Screen
                              Row(
                                children: [
                                  Assets.icons.lockKey.svg(width: 32.w, height: 32.h),
                                  SizedBox(width: 12.w),
                                  CustomText(text: "Lock Screen",
                                    color: AppColors.textColorFFFFFF,
                                    fontWeight: FontWeight.w500,
                                    fontsize: 20.sp,),
                                ],
                              ),


                              /// Stable Volume (Switch)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Assets.icons.volume.svg(width: 32.w, height: 32.h),
                                      SizedBox(width: 12.w),
                                      CustomText(text: "Stable Volume",
                                          color: AppColors.textColorFFFFFF,
                                          fontWeight: FontWeight.w500,
                                          fontsize: 20.sp),
                                    ],
                                  ),
                                  Switch(
                                    value: true,
                                    activeColor: Colors.orange,
                                    onChanged: (val) {},
                                  ),
                                ],
                              ),


                              /// Help & Feedback
                              Row(
                                children: [
                                  Assets.icons.help.svg(width: 32.w, height: 32.h),
                                  SizedBox(width: 12.w),
                                  CustomText(text: "Help & feedback",
                                    color: AppColors.textColorFFFFFF,
                                    fontWeight: FontWeight.w500,
                                    fontsize: 20.sp,),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Assets.icons.settings.svg(
                    color: AppColors.textColorFFFFFF,
                  ),
                )
              ],
            ),
          ),

          // Recording timer (shows when recording)
          if (_isRecording)
            Positioned(
              bottom: 140,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _formatDuration(_recordingDuration),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ),

          // Bottom controls
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel/Close button
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),

                // Record button
                GestureDetector(
                  onTap: _isRecording ? _stopVideoRecording : _startVideoRecording,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _isRecording ? Colors.red : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.videocam,
                      color: _isRecording ? Colors.white : AppColors.primaryColorC79235,
                      size: 40,
                    ),
                  ),
                ),

                // Done/Check button
                GestureDetector(
                  onTap: _isRecording ? _stopVideoRecording : _startVideoRecording,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _videoPath != null
                          ? Colors.green.withOpacity(0.8)
                          : Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  void _showPlaybackSpeedSheet(BuildContext context) {
    final controller = Get.put(PlaybackController());

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D0D0D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) {
        return Obx(() {
          return Container(
            width: 430.w,
            height: 161.h,
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                /// Slider Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.speed.value > 0.25) {
                          controller.speed.value -= 0.25;
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: AppColors.textColor323539,
                        child: Icon(Icons.remove, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: controller.speed.value,
                        min: 0.25,
                        max: 2.0,
                        divisions: 7,
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        onChanged: (value) {
                          controller.speed.value = value;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (controller.speed.value < 2.0) {
                          controller.speed.value += 0.25;
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: AppColors.textColor323539,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                /// Speed Options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _speedChip("0.25X", controller),
                    _speedChip("0.5X", controller),
                    _speedChip("1.0X", controller),
                    _speedChip("1.5X", controller),
                    _speedChip("2.0X", controller),
                  ],
                ),

                SizedBox(height: 10.h),
                CustomText(
                  text: controller.speed.value == 1.0 ? "Normal" : "",
                  color: Colors.white,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          );
        });
      },
    );
  }


  Widget _speedChip(String text, PlaybackController controller) {
    final value = double.parse(text.replaceAll("X", ""));
    return GestureDetector(
      onTap: () => controller.speed.value = value,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: controller.speed.value == value ? Colors.white24 : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: controller.speed.value == value ? Colors.white : Colors.grey,
          ),
        ),
        child: CustomText(
          text: text,
          color: controller.speed.value == value ? Colors.white : Colors.grey,
          fontsize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}