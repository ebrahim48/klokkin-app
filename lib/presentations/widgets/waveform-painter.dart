import 'dart:math';
import 'package:flutter/material.dart';

class RealWaveformPainter extends CustomPainter {
  final double amplitude;
  final bool isRecording;
  static List<double> amplitudeHistory = [];

  RealWaveformPainter(this.amplitude, {this.isRecording = true}) {
    if (isRecording) {

      amplitudeHistory.add(amplitude);
      if (amplitudeHistory.length > 60) {
        amplitudeHistory.removeAt(0);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;

    if (isRecording && amplitudeHistory.isNotEmpty) {
      // Draw real-time waveform during recording
      _drawRealWaveform(canvas, size, centerY);
    } else {
      // Draw static waveform like the image when not recording
      _drawStaticWaveform(canvas, size, centerY);
    }
  }

  void _drawRealWaveform(Canvas canvas, Size size, double centerY) {
    final paint = Paint()
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final barWidth = size.width / 60;

    // Draw animated waveform bars
    for (int i = 0; i < amplitudeHistory.length; i++) {
      final x = i * barWidth + barWidth / 2;
      final barHeight = amplitudeHistory[i] * centerY * 0.9;

      // Create gradient effect from blue to orange
      final progress = i / amplitudeHistory.length;
      paint.color = Color.lerp(
          Colors.blue.shade400.withOpacity(0.6),
          Colors.orange.shade400.withOpacity(1.0),
          progress
      )!;

      // Draw vertical line from center
      canvas.drawLine(
        Offset(x, centerY - barHeight),
        Offset(x, centerY + barHeight),
        paint,
      );
    }
  }

  void _drawStaticWaveform(Canvas canvas, Size size, double centerY) {
    final paint = Paint()
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Create static waveform pattern like the image
    final barWidth = 4.0;
    final spacing = 2.0;
    final totalBars = (size.width / (barWidth + spacing)).floor();

    // Define different height patterns for groups
    final patterns = [
      [0.2, 0.4, 0.6, 0.3, 0.1], // Small group
      [0.1, 0.3, 0.7, 0.9, 0.8, 0.6, 0.4, 0.2], // Medium group
      [0.3, 0.5, 0.8, 1.0, 0.9, 0.7, 0.8, 0.6, 0.4, 0.2, 0.1], // Large group
      [0.2, 0.4, 0.3, 0.1], // Small group
    ];

    int patternIndex = 0;
    int barInPattern = 0;

    // Draw static waveform bars
    for (int i = 0; i < totalBars; i++) {
      final x = i * (barWidth + spacing) + barWidth / 2;

      // Get height from current pattern
      final currentPattern = patterns[patternIndex % patterns.length];
      final heightRatio = currentPattern[barInPattern % currentPattern.length];
      final barHeight = heightRatio * centerY * 0.8;

      // Use orange color for static waveform
      paint.color = Colors.orange.shade400.withOpacity(0.7);

      // Draw vertical line
      canvas.drawLine(
        Offset(x, centerY - barHeight),
        Offset(x, centerY + barHeight),
        paint,
      );

      barInPattern++;
      if (barInPattern >= currentPattern.length) {
        barInPattern = 0;
        patternIndex++;

        // Add some spacing between pattern groups
        i += 2;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}