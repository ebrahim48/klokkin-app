import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

import '../../../../core/constants/app_colors.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Map<String, dynamic> videoData;

  const VideoPlayerScreen({
    super.key,
    required this.videoData,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final videoUrl = widget.videoData['videoUrl'] as String;

    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _controller.value.isPlaying;
          });
        }
      });

    try {
      await _controller.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        // Auto play on load
        _controller.play();
      }
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.videoData['title'] as String? ?? 'Video';
    final duration = widget.videoData['duration'] as String? ?? '';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Video Player
            Center(
              child: _isInitialized
                  ? GestureDetector(
                onTap: _toggleControls,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
                  : const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColorC79235,
                ),
              ),
            ),

            // Controls Overlay
            if (_showControls && _isInitialized)
              GestureDetector(
                onTap: _toggleControls,
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Column(
                    children: [
                      // Top Bar
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: title,
                                    color: Colors.white,
                                    fontsize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    maxline: 2,
                                  ),
                                  if (duration.isNotEmpty) ...[
                                    SizedBox(height: 4.h),
                                    CustomText(
                                      text: 'Duration: $duration',
                                      color: Colors.white70,
                                      fontsize: 12.sp,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Center Play/Pause Button
                      Center(
                        child: GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            width: 70.w,
                            height: 70.w,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColorC79235.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 40.sp,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Bottom Controls
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            // Progress Bar
                            VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                playedColor: AppColors.primaryColorC79235,
                                bufferedColor: Colors.white30,
                                backgroundColor: Colors.white10,
                              ),
                            ),
                            SizedBox(height: 8.h),

                            // Time & Controls
                            Row(
                              children: [
                                CustomText(
                                  text: _formatDuration(_controller.value.position),
                                  color: Colors.white,
                                  fontsize: 12.sp,
                                ),
                                const Spacer(),
                                CustomText(
                                  text: _formatDuration(_controller.value.duration),
                                  color: Colors.white,
                                  fontsize: 12.sp,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}