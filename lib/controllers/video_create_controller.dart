import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';

class VideoCreateController extends GetxController {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;

  RxBool isRecording = false.obs;
  RxBool isPaused = false.obs;
  RxString videoPath = ''.obs;
  RxBool isInitialized = false.obs;

  // Timer to track recording duration
  Timer? _timer;
  RxInt _recordDuration = 0.obs;

  // Formatted duration string (HH:MM:SS)
  String get formattedDuration {
    int seconds = _recordDuration.value % 60;
    int minutes = (_recordDuration.value ~/ 60) % 60;
    int hours = _recordDuration.value ~/ 3600;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onInit() {
    _initializeCamera();
    super.onInit();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras!.isNotEmpty) {
        final backCamera = cameras!.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras!.first,
        );

        _cameraController = CameraController(
          backCamera,
          ResolutionPreset.high,
          enableAudio: true,
        );

        await _cameraController!.initialize();

        isInitialized.value = true;
        update();

        print("📷 Camera initialized successfully");
      }
    } catch (e) {
      print('Error initializing camera: $e');
      Get.snackbar("Camera Error", "Failed to initialize camera.");
    }
  }

  Future<void> startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      Get.snackbar("Camera Error", "Camera not initialized.");
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';

      await _cameraController!.startVideoRecording(); // 🔴 FIX: Actually pass filePath in latest versions
      // In newer `camera` versions, startVideoRecording() does NOT take file path,
      // it returns an XFile when you stop recording. That's why your old code broke.

      videoPath.value = filePath;
      isRecording.value = true;
      isPaused.value = false;

      // Start timer
      _timer?.cancel();
      _recordDuration.value = 0;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _recordDuration.value++;
      });

      print("⏺️ Video recording started");
    } catch (e) {
      print('Error starting video recording: $e');
      Get.snackbar("Error", "Failed to start video recording.");
      isRecording.value = false;
    }
  }

  Future<void> stopRecording() async {
    try {
      if (_cameraController != null &&
          _cameraController!.value.isRecordingVideo) {
        final videoFile = await _cameraController!.stopVideoRecording();
        videoPath.value = videoFile.path;

        isRecording.value = false;
        isPaused.value = false;
        _timer?.cancel();

        print("🎬 Video recording stopped: ${videoFile.path}");
      }
    } catch (e) {
      print('Error stopping video recording: $e');
      Get.snackbar("Error", "Failed to stop recording.");
    }
  }



  Future<void> pauseRecording() async {
    try {
      await _cameraController?.pauseVideoRecording();
      isRecording.value = false;
      isPaused.value = true;
      _timer?.cancel();

      print("⏸️ Video recording paused");
    } catch (e) {
      print('Error pausing video recording: $e');
      Get.snackbar("Error", "Failed to pause recording.");
    }
  }

  Future<void> resumeRecording() async {
    try {
      await _cameraController?.resumeVideoRecording();
      isRecording.value = true;
      isPaused.value = false;

      // Resume timer from where it left off
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _recordDuration.value++;
      });

      print("▶️ Video recording resumed");
    } catch (e) {
      print('Error resuming video recording: $e');
      Get.snackbar("Error", "Failed to resume recording.");
    }
  }



  Future<void> restartRecording() async {
    try {
      // If currently recording or paused, resume from where it stopped
      if (isPaused.value) {
        await resumeRecording();
        return;
      }

      // If currently recording, pause it first
      if (isRecording.value) {
        await pauseRecording();
        return;
      }

      // If no recording is active, start fresh recording
      await _stopCurrentRecording();

      // Reset all states for completely new recording
      isRecording.value = false;
      isPaused.value = false;
      _recordDuration.value = 0;
      videoPath.value = '';

      // Cancel timers
      _timer?.cancel();

      // Small delay then start fresh recording
      await Future.delayed(const Duration(milliseconds: 300));
      await startRecording();

      print("🔄 Video recording restarted");
    } catch (e) {
      print('Error with restart/resume: $e');
      Get.snackbar("Error", "Failed to restart/resume recording.");
    }
  }

  Future<void> _stopCurrentRecording() async {
    try {
      if (_cameraController != null && _cameraController!.value.isRecordingVideo) {
        await _cameraController!.stopVideoRecording();
      }
    } catch (e) {
      print('Error stopping current recording: $e');
    }
  }

  Future<void> cancelRecording() async {
    try {
      // Stop recording safely
      if (isRecording.value || isPaused.value) {
        await _stopCurrentRecording();
      }

      // Cancel all timers
      _timer?.cancel();

      // Delete the recorded file if it exists
      if (videoPath.value.isNotEmpty) {
        try {
          final file = File(videoPath.value);
          if (await file.exists()) {
            await file.delete();
            print("🗑️ Deleted video file: ${videoPath.value}");
          }
        } catch (fileError) {
          print('Error deleting file: $fileError');
        }
      }

      // Reset all states
      isRecording.value = false;
      isPaused.value = false;
      _recordDuration.value = 0;
      videoPath.value = '';

      print("❌ Video recording cancelled successfully");
    } catch (e) {
      print('Error cancelling recording: $e');
      // Force reset states even if error occurs
      try {
        isRecording.value = false;
        isPaused.value = false;
        _recordDuration.value = 0;
        videoPath.value = '';
        _timer?.cancel();
      } catch (resetError) {
        print('Error resetting states: $resetError');
      }
    }
  }

  Future<void> saveRecording() async {
    try {
      String? finalPath;

      // If currently recording, stop it first
      if (isRecording.value || isPaused.value) {
        await _stopCurrentRecording();
        finalPath = videoPath.value;
        isRecording.value = false;
        isPaused.value = false;
        _timer?.cancel();
      }

      // Use the final path or existing recorded path
      if (finalPath != null && finalPath.isNotEmpty || videoPath.value.isNotEmpty) {
        String pathToSave = finalPath ?? videoPath.value;
        videoPath.value = pathToSave;

        // Get file info
        final file = File(pathToSave);
        final fileSize = await file.length();
        final fileSizeKB = (fileSize / 1024).toStringAsFixed(1);

        // Save to app's internal storage
        await _moveToInternalStorage(pathToSave);

        Get.snackbar(
          "Video Recording Saved! ✅",
          "File: ${pathToSave.split('/').last}\nSize: ${fileSizeKB} KB\nDuration: $formattedDuration",
          duration: Duration(seconds: 5),
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        print("💾 Video recording saved: $pathToSave");

      } else {
        Get.snackbar(
          "No Recording Found",
          "Please record something first.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error saving recording: $e');
      Get.snackbar("Error", "Failed to save recording.");
    }
  }

  Future<void> _moveToInternalStorage(String originalPath) async {
    try {
      // Keep the file in app's internal directory
      final directory = await getApplicationDocumentsDirectory();
      final fileName = originalPath.split('/').last;
      final newPath = '${directory.path}/saved_videos/$fileName';

      // Create saved_videos directory if it doesn't exist
      final savedDir = Directory('${directory.path}/saved_videos');
      if (!await savedDir.exists()) {
        await savedDir.create(recursive: true);
      }

      // Move file to saved videos folder
      final originalFile = File(originalPath);
      await originalFile.copy(newPath);

      // Update the video path
      videoPath.value = newPath;

      print("📁 File moved to internal storage: $newPath");
    } catch (e) {
      print('Error moving file to internal storage: $e');
    }
  }

  // Switch between front and back camera
  Future<void> switchCamera() async {
    if (cameras == null || cameras!.length < 2) return;

    try {
      final currentDirection = _cameraController?.description.lensDirection;
      final newCamera = cameras!.firstWhere(
            (camera) => camera.lensDirection != currentDirection,
      );

      await _cameraController?.dispose();
      _cameraController = CameraController(
        newCamera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _cameraController!.initialize();
      update();

      print("📷 Camera switched");
    } catch (e) {
      print('Error switching camera: $e');
    }
  }

  // Get camera preview widget
  Widget? getCameraPreview() {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      return CameraPreview(_cameraController!);
    }
    return null;
  }

  @override
  void onClose() {
    _timer?.cancel();
    _cameraController?.dispose();
    super.onClose();
  }
}