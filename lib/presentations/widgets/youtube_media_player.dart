import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/constants/app_colors.dart';
import 'custom_network_image.dart';
import 'custom_text.dart';

/// Plays official YouTube content (movie trailers / artist songs).
///
/// Two modes:
///  - video  (default): the normal embedded YouTube player UI.
///  - audio  ([audioOnly] = true): a music-player look — the song's cover
///    art fills the area with a single play/pause button, and the actual
///    YouTube player is kept mounted but hidden behind the artwork so the
///    audio still streams. This is what makes "songs play as music, not
///    video".
bool isYoutubeUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  final u = url.toLowerCase();
  return u.contains('youtube.com/') || u.contains('youtu.be/');
}

class YoutubeMediaPlayer extends StatefulWidget {
  final String url;
  final bool audioOnly;
  final String? artworkUrl;

  const YoutubeMediaPlayer({
    super.key,
    required this.url,
    this.audioOnly = false,
    this.artworkUrl,
  });

  @override
  State<YoutubeMediaPlayer> createState() => _YoutubeMediaPlayerState();
}

class _YoutubeMediaPlayerState extends State<YoutubeMediaPlayer> {
  YoutubePlayerController? _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _init(widget.url);
  }

  @override
  void didUpdateWidget(covariant YoutubeMediaPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _controller?.removeListener(_onState);
      _controller?.dispose();
      _init(widget.url);
    }
  }

  void _init(String url) {
    final id = YoutubePlayer.convertUrlToId(url);
    if (id != null) {
      _controller = YoutubePlayerController(
        initialVideoId: id,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
        ),
      )..addListener(_onState);
    }
  }

  void _onState() {
    final playing = _controller?.value.isPlaying ?? false;
    if (playing != _isPlaying && mounted) {
      setState(() => _isPlaying = playing);
    }
  }

  void _toggle() {
    final c = _controller;
    if (c == null) return;
    c.value.isPlaying ? c.pause() : c.play();
  }

  @override
  void dispose() {
    _controller?.removeListener(_onState);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return _box(
        child: CustomText(
          text: 'Media unavailable',
          textAlign: TextAlign.center,
          color: AppColors.textColorC2C2C2,
        ),
      );
    }

    final player = YoutubePlayer(
      controller: _controller!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: AppColors.buttonColorE8A533,
      progressColors: const ProgressBarColors(
        playedColor: AppColors.buttonColorE8A533,
        handleColor: AppColors.primaryColorC79235,
      ),
    );

    // Video mode: show the YouTube player as-is.
    if (!widget.audioOnly) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: player,
      );
    }

    // Audio mode: cover art + play/pause; the real player streams the
    // audio from behind the artwork (kept mounted so it keeps playing).
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        height: 220.h,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Mounted but visually covered — drives the audio.
            Positioned.fill(child: player),
            Positioned.fill(
              child: (widget.artworkUrl != null &&
                      widget.artworkUrl!.isNotEmpty)
                  ? CustomNetworkImage(
                      imageUrl: widget.artworkUrl!,
                      width: double.infinity,
                      height: 220.h,
                    )
                  : Container(color: AppColors.backgColor20272E),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.28)),
            ),
            Center(
              child: GestureDetector(
                onTap: _toggle,
                child: Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.buttonColorE8A533,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 36.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _box({required Widget child}) => ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          height: 200.h,
          width: double.infinity,
          color: AppColors.backgColor20272E,
          alignment: Alignment.center,
          child: child,
        ),
      );
}
