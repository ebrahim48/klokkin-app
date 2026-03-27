import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../core/config/app_routes/app_routes.dart';
import 'home_controller.dart';

enum RecordType { audio, video }

class RecordStoryController extends GetxController {
  var selectedType = RecordType.audio.obs;

  void switchTo(RecordType type) => selectedType.value = type;

  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();

  final _recorder = AudioRecorder();
  RxBool isRecording = false.obs;
  RxBool isPaused = false.obs;
  RxString recordPath = ''.obs;

  // Real-time amplitude for waveform
  RxDouble currentAmplitude = 0.0.obs;
  Timer? _amplitudeTimer;

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
    _requestPermission();
    // Pre-populate from pending values set by upload flow
    if (Get.isRegistered<HomeController>()) {
      final homeCtrl = Get.find<HomeController>();
      if (homeCtrl.pendingTitle.value.isNotEmpty) {
        titleCtrl.text = homeCtrl.pendingTitle.value;
      }
      if (homeCtrl.pendingDescription.value.isNotEmpty) {
        descriptionCtrl.text = homeCtrl.pendingDescription.value;
      }
    }
    super.onInit();
  }

  Future<void> _requestPermission() async {
    bool hasPerm = await _recorder.hasPermission();
    if (!hasPerm) {
      Get.snackbar("Permission Required", "Microphone access is needed to record audio.");
    }
  }

  Future<void> startRecording() async {
    bool hasPerm = await _recorder.hasPermission();
    if (!hasPerm) {
      Get.snackbar("Permission Denied", "Please grant microphone permission.");
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.mp4';

      var config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      );

      await _recorder.start(config, path: filePath);
      recordPath.value = filePath;
      isRecording.value = true;
      isPaused.value = false;

      // Start duration timer
      _timer?.cancel();
      _recordDuration.value = 0;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _recordDuration.value++;
      });

      // Start amplitude monitoring for real waveform
      _startAmplitudeMonitoring();

      print("⏺️ Voice recording started: $filePath");
    } catch (e) {
      print('Error starting recording: $e');
      Get.snackbar("Error", "Failed to start recording.");
      isRecording.value = false;
    }
  }

  void _startAmplitudeMonitoring() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (isRecording.value && !isPaused.value) {
        try {
          var amplitude = await _recorder.getAmplitude();
          currentAmplitude.value = amplitude.current.clamp(-160.0, 0.0) / -160.0;
        } catch (e) {
          // Handle any amplitude reading errors silently
        }
      }
    });
  }

  Future<void> pauseRecording() async {
    try {
      await _recorder.pause();
      isRecording.value = false;
      isPaused.value = true;
      _timer?.cancel();
      _amplitudeTimer?.cancel();
      currentAmplitude.value = 0.0;

      print("⏸️ Recording paused");
    } catch (e) {
      print('Error pausing recording: $e');
      Get.snackbar("Error", "Failed to pause recording.");
    }
  }

  Future<void> resumeRecording() async {
    try {
      await _recorder.resume();
      isRecording.value = true;
      isPaused.value = false;

      // Resume timer from where it left off
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _recordDuration.value++;
      });

      // Resume amplitude monitoring
      _startAmplitudeMonitoring();

      print("▶️ Recording resumed");
    } catch (e) {
      print('Error resuming recording: $e');
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
      currentAmplitude.value = 0.0;
      recordPath.value = '';

      // Cancel timers
      _timer?.cancel();
      _amplitudeTimer?.cancel();

      // Small delay then start fresh recording
      await Future.delayed(const Duration(milliseconds: 300));
      await startRecording();

      print("🔄 Recording restarted");
    } catch (e) {
      print('Error with restart/resume: $e');
      Get.snackbar("Error", "Failed to restart/resume recording.");
    }
  }

  Future<void> _stopCurrentRecording() async {
    try {
      await _recorder.stop();
    } catch (e) {
      print('Error stopping current recording: $e');
    }
  }

  Future<void> cancelRecording() async {
    try {
      // Stop recording safely
      if (isRecording.value || isPaused.value) {
        final path = await _recorder.stop();
        if (path != null && path.isNotEmpty) {
          recordPath.value = path;
        }
      }

      // Cancel all timers
      _timer?.cancel();
      _amplitudeTimer?.cancel();

      // Delete the recorded file if it exists
      if (recordPath.value.isNotEmpty) {
        try {
          final file = File(recordPath.value);
          if (await file.exists()) {
            await file.delete();
            print("🗑️ Deleted recording file: ${recordPath.value}");
          }
        } catch (fileError) {
          print('Error deleting file: $fileError');
        }
      }

      // Reset all states
      isRecording.value = false;
      isPaused.value = false;
      _recordDuration.value = 0;
      currentAmplitude.value = 0.0;
      recordPath.value = '';

      print("❌ Recording cancelled successfully");
    } catch (e) {
      print('Error cancelling recording: $e');
      // Force reset states even if error occurs
      try {
        isRecording.value = false;
        isPaused.value = false;
        _recordDuration.value = 0;
        currentAmplitude.value = 0.0;
        recordPath.value = '';
        _timer?.cancel();
        _amplitudeTimer?.cancel();
      } catch (resetError) {
        print('Error resetting states: $resetError');
      }
    }
  }

  Future<void> saveRecording(BuildContext context) async {
    try {
      String? finalPath;

      // Stop recording if active
      if (isRecording.value || isPaused.value) {
        finalPath = await _recorder.stop();
        isRecording.value = false;
        isPaused.value = false;
        _timer?.cancel();
        _amplitudeTimer?.cancel();
        currentAmplitude.value = 0.0;
      }

      if (finalPath != null || recordPath.value.isNotEmpty) {
        String pathToSave = finalPath ?? recordPath.value;
        recordPath.value = pathToSave;

        final file = File(pathToSave);
        final fileSize = await file.length();
        final fileSizeKB = (fileSize / 1024).toStringAsFixed(1);

        await _moveToInternalStorage(pathToSave);

        // ✅ Show snackbar immediately (no delayed)
        if (Get.context != null) {
          Get.snackbar(
            "Voice Recording Saved! ✅",
            "File: ${pathToSave.split('/').last}\n"
                "Size: ${fileSizeKB} KB\n"
                "Duration: $formattedDuration",
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }

        print("💾 Voice recording saved: $pathToSave");

        // ✅ Navigate *after* showing snackbar
        if (context.mounted) {
          context.pushNamed(
            AppRoutes.audioRecordAddPostDetailsScreen,
            extra: {
              "title": "Add Post Details",
              "filePath": pathToSave,
              "size": fileSizeKB,
              "duration": formattedDuration,
              "pendingTitle": titleCtrl.text.trim(),
              "pendingDescription": descriptionCtrl.text.trim(),
            },
          );
        }
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
      // Keep the file in app's internal directory to avoid triggering default apps
      final directory = await getApplicationDocumentsDirectory();
      final fileName = originalPath.split('/').last;
      final newPath = '${directory.path}/saved_recordings/$fileName';

      // Create saved_recordings directory if it doesn't exist
      final savedDir = Directory('${directory.path}/saved_recordings');
      if (!await savedDir.exists()) {
        await savedDir.create(recursive: true);
      }

      // Move file to saved recordings folder
      final originalFile = File(originalPath);
      await originalFile.copy(newPath);

      // Update the record path
      recordPath.value = newPath;

      print("📁 File moved to internal storage: $newPath");
    } catch (e) {
      print('Error moving file to internal storage: $e');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _amplitudeTimer?.cancel();
    _recorder.dispose();
    titleCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }
}