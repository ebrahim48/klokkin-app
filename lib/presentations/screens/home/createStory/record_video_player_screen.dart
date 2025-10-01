import 'dart:io';
import 'package:flutter/material.dart';
import 'package:klokkin_app/presentations/widgets/custom_loader.dart';
import 'package:path/path.dart' as path;
import 'package:video_player/video_player.dart';

class RecordVideoPlayerScreen extends StatefulWidget {
  final File videoFile;

  const RecordVideoPlayerScreen({super.key, required this.videoFile});

  @override
  State<RecordVideoPlayerScreen> createState() => _RecordVideoPlayerScreenState();
}

class _RecordVideoPlayerScreenState extends State<RecordVideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.file(widget.videoFile);
    await _controller.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(path.basename(widget.videoFile.path)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isInitialized
          ? Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  icon: Icon(
                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _controller.seekTo(Duration.zero);
                    _controller.pause();
                  },
                  icon: const Icon(Icons.stop, size: 32),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.blue,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.black12,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      )
          : const Center(child: CustomLoader()),
    );
  }
}