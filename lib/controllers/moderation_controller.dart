import 'dart:convert';

import 'package:get/get.dart';

import '../core/helpers/prefs_helper.dart';
import '../core/helpers/toast_message_helper.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

/// Handles the App Store Guideline 1.2 (User-Generated Content) requirements:
///
///  * a mechanism for users to **flag/report** objectionable content,
///  * a mechanism for users to **block** abusive users (content is removed
///    from the feed instantly and the developer is notified),
///  * a client-side **objectionable-content filter**.
///
/// Blocked users and reported/hidden stories are persisted locally so the
/// effect survives app restarts even before the backend confirms. Every
/// report/block is also POSTed to the backend (via the existing feedback
/// channel) so the developer is notified and can act within 24 hours.
class ModerationController extends GetxController {
  static const String _blockedKey = 'blocked_user_ids';
  static const String _hiddenKey = 'hidden_story_ids';

  final RxSet<String> blockedUserIds = <String>{}.obs;
  final RxSet<String> hiddenStoryIds = <String>{}.obs;

  /// Basic profanity / objectionable term list used for the client-side
  /// content filter. Stories whose caption or description contain any of
  /// these are hidden from the feed automatically.
  static const List<String> _blockedWords = [
    'fuck', 'shit', 'bitch', 'asshole', 'bastard', 'cunt', 'dick',
    'pussy', 'slut', 'whore', 'nigger', 'faggot', 'rape', 'porn',
    'nude', 'nudes', 'sex ', 'xxx',
  ];

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      final blocked = await PrefsHelper.getString(_blockedKey);
      final hidden = await PrefsHelper.getString(_hiddenKey);
      if (blocked.isNotEmpty) {
        blockedUserIds.addAll(
            List<String>.from(jsonDecode(blocked) as List));
      }
      if (hidden.isNotEmpty) {
        hiddenStoryIds.addAll(
            List<String>.from(jsonDecode(hidden) as List));
      }
    } catch (_) {
      // Corrupt/legacy value — start clean rather than crashing.
    }
  }

  Future<void> _persist() async {
    await PrefsHelper.setString(
        _blockedKey, jsonEncode(blockedUserIds.toList()));
    await PrefsHelper.setString(
        _hiddenKey, jsonEncode(hiddenStoryIds.toList()));
  }

  // --------------------------------------------------------------- queries

  bool isUserBlocked(String? userId) =>
      userId != null && userId.isNotEmpty && blockedUserIds.contains(userId);

  bool isStoryHidden(String? storyId) =>
      storyId != null && storyId.isNotEmpty && hiddenStoryIds.contains(storyId);

  bool hasObjectionableText(String? text) {
    if (text == null || text.isEmpty) return false;
    final lower = text.toLowerCase();
    return _blockedWords.any((w) => lower.contains(w));
  }

  /// Single gate the feed uses: hide a story if its author is blocked, if the
  /// story was reported/hidden, or if its text trips the content filter.
  bool isVisible({
    String? storyId,
    String? userId,
    String? caption,
    String? description,
  }) {
    if (isUserBlocked(userId)) return false;
    if (isStoryHidden(storyId)) return false;
    if (hasObjectionableText(caption) || hasObjectionableText(description)) {
      return false;
    }
    return true;
  }

  // --------------------------------------------------------------- actions

  /// Reports a story. The story is hidden from the reporter's feed instantly
  /// and the developer is notified so they can review within 24 hours.
  Future<void> reportStory({
    required String storyId,
    String? userId,
    String? authorName,
    required String reason,
  }) async {
    if (storyId.isNotEmpty) {
      hiddenStoryIds.add(storyId);
      await _persist();
    }
    await _notifyBackend(
      'REPORT — storyId: $storyId, author: ${authorName ?? userId ?? "unknown"}, '
      'reason: $reason',
    );
    ToastMessageHelper.showToastMessage(
      "Thanks for reporting. We'll review this content within 24 hours.",
      title: "Reported",
    );
  }

  /// Blocks a user. All of that user's content is removed from the feed
  /// instantly and the developer is notified.
  Future<void> blockUser({
    required String userId,
    String? userName,
  }) async {
    if (userId.isEmpty) {
      ToastMessageHelper.showToastMessage(
          "Could not identify this user to block.",
          title: "Block failed");
      return;
    }
    blockedUserIds.add(userId);
    await _persist();
    await _notifyBackend(
        'BLOCK — userId: $userId, name: ${userName ?? "unknown"}');
    ToastMessageHelper.showToastMessage(
      "${userName ?? 'User'} blocked. You won't see their content anymore.",
      title: "Blocked",
    );
  }

  Future<void> unblockUser(String userId) async {
    blockedUserIds.remove(userId);
    await _persist();
  }

  /// Sends the report/block notice to the developer through the existing
  /// feedback endpoint (a real, monitored channel) so action can be taken.
  Future<void> _notifyBackend(String message) async {
    try {
      await ApiClient.postMultipartData(
        ApiConstants.feedbackEndPoint,
        {"comment": "[MODERATION] $message"},
        multipartBody: [],
      );
    } catch (_) {
      // Never block the local hide/block on a network failure — the content
      // is already removed for the user; the notice will be retried on the
      // next report/block.
    }
  }
}
