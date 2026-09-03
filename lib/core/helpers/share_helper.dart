import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// Single entry point for the system share sheet.
///
/// On iPad the sheet is a popover that must be anchored to a rectangle;
/// `share_plus` throws `sharePositionOrigin` errors when it is missing, and
/// App Review tests on an iPad Pro (guideline 2.1(a)). Routing every share
/// through here guarantees an anchor is always supplied.
class ShareHelper {
  static Future<void> shareText(
    BuildContext context,
    String text, {
    String? subject,
  }) async {
    try {
      await Share.share(
        text,
        subject: subject,
        sharePositionOrigin: _originFor(context),
      );
    } catch (e) {
      debugPrint('Share failed: $e');
    }
  }

  static Rect _originFor(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      return box.localToGlobal(Offset.zero) & box.size;
    }
    final size = MediaQuery.maybeOf(context)?.size ?? const Size(400, 800);
    return Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 1,
      height: 1,
    );
  }
}
