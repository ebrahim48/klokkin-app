import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/helpers/media_url_helper.dart';
import '../../../widgets/youtube_media_player.dart';

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
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;
  String? _error;
  String? _ytUrl;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  /// Guideline 2.1(a): App Review saw this screen spin forever. Failures used
  /// to be printed and swallowed, leaving the spinner up with no way out. The
  /// URL is now normalised, initialisation has a timeout, and every failure
  /// ends in a visible message with a Retry button.
  Future<void> _initializeVideo() async {
    final rawUrl = widget.videoData['videoUrl'] as String?;

    // A YouTube link is an HTML page, not a media file: handing it to
    // VideoPlayerController leaves the screen spinning forever, which is what
    // App Review saw (2.1(a)). Those stories get the embedded player instead.
    if (MediaUrlHelper.isYoutubeLink(rawUrl)) {
      if (mounted) {
        setState(() {
          _ytUrl = rawUrl;
          _error = null;
        });
      }
      return;
    }

    final uri = MediaUrlHelper.toUri(rawUrl);
    if (uri == null) {
      if (mounted) {
        setState(() {
          _error = 'This video is unavailable.';
          _isInitialized = false;
        });
      }
      return;
    }

    setState(() {
      _error = null;
      _isInitialized = false;
    });

    final previous = _controller;
    _controller = null;
    await previous?.dispose();

    final controller = VideoPlayerController.networkUrl(uri)
      ..addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _controller?.value.isPlaying ?? false;
          });
        }
      });
    _controller = controller;

    try {
      await controller.initialize().timeout(const Duration(seconds: 25));
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _isInitialized = true;
        _error = null;
      });
      // Auto play on load
      await controller.play();
    } catch (e) {
      debugPrint('Error initializing video: $e');
      if (!mounted) return;
      setState(() {
        _isInitialized = false;
        _error = 'This video could not be played. Please check your '
            'connection and try again.';
      });
    }
  }

  void _togglePlayPause() {
    final controller = _controller;
    if (controller == null || !_isInitialized) return;
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
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
    _controller?.dispose();
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
            if (_ytUrl != null)
              Center(child: YoutubeMediaPlayer(url: _ytUrl!))
            else
            Center(
              child: _isInitialized && _controller != null
                  ? GestureDetector(
                onTap: _toggleControls,
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              )
                  : _error != null
                      ? _buildErrorState()
                      : const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColorC79235,
                ),
              ),
            ),

            // Back button stays reachable while loading or after a failure,
            // otherwise the screen would be a dead end.
            if (!_isInitialized || _ytUrl != null)
              Positioned(
                top: 8.h,
                left: 8.w,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

            // Controls Overlay
            if (_showControls && _isInitialized && _ytUrl == null)
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
                              _controller!,
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
                                  text: _formatDuration(_controller!.value.position),
                                  color: Colors.white,
                                  fontsize: 12.sp,
                                ),
                                const Spacer(),
                                CustomText(
                                  text: _formatDuration(_controller!.value.duration),
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

  Widget _buildErrorState() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.white70, size: 48.sp),
          SizedBox(height: 12.h),
          CustomText(
            text: _error ?? 'Something went wrong.',
            color: Colors.white70,
            fontsize: 14.sp,
            maxline: 3,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: _initializeVideo,
            child: CustomText(
              text: 'Retry',
              color: AppColors.primaryColorC79235,
              fontsize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
