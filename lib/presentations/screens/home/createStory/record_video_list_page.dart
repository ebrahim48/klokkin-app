import 'dart:io';
import 'package:flutter/material.dart';
import 'package:klokkin_app/presentations/screens/home/createStory/record_video_player_screen.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class RecordVideoListPageScreen extends StatefulWidget {
  const RecordVideoListPageScreen({super.key});

  @override
  State<RecordVideoListPageScreen> createState() => _RecordVideoListPageScreenState();
}

class _RecordVideoListPageScreenState extends State<RecordVideoListPageScreen> {
  List<File> _videoFiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideoFiles();
  }

  Future<void> _loadVideoFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync()
          .where((file) => file.path.endsWith('.mp4'))
          .map((file) => File(file.path))
          .toList();

      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      setState(() {
        _videoFiles = files;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getFileName(String filePath) {
    return path.basename(filePath);
  }

  String _getFileSize(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _deleteVideo(File file) async {
    try {
      await file.delete();
      _loadVideoFiles();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete video: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorded Videos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _loadVideoFiles,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _videoFiles.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No videos recorded yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _videoFiles.length,
        itemBuilder: (context, index) {
          final file = _videoFiles[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.play_circle_fill, size: 40),
              title: Text(_getFileName(file.path)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Size: ${_getFileSize(file)}'),
                  Text(
                    'Modified: ${file.lastModifiedSync().toString().substring(0, 19)}',
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteDialog(file),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecordVideoPlayerScreen(videoFile: file),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        tooltip: 'Record New Video',
        child: const Icon(Icons.videocam),
      ),
    );
  }

  void _showDeleteDialog(File file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Video'),
          content: Text('Are you sure you want to delete ${_getFileName(file.path)}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteVideo(file);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
