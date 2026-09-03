import '../../services/api_constants.dart';

/// Normalises the media URLs that come back from the API before they are
/// handed to `VideoPlayerController` / `http`.
///
/// Apple rejected the app under 2.1(a) because a video "loaded indefinitely".
/// A malformed URL (a relative path, a raw space in the file name, or a plain
/// `http://` link that ATS blocks) makes `initialize()` hang or throw, and the
/// screens used to sit on a spinner forever. Cleaning the URL here removes the
/// most common causes; the players handle the rest with a timeout + retry.
class MediaUrlHelper {
  /// Returns an absolute, percent-encoded, https URL — or `null` when the
  /// input cannot be turned into something playable.
  static String? normalize(String? raw) {
    if (raw == null) return null;

    var url = raw.trim();
    if (url.isEmpty) return null;

    // Relative path from the API (e.g. "/uploads/story/abc.mp4").
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      final base = ApiConstants.imageBaseUrl;
      url = url.startsWith('/') ? '$base$url' : '$base/$url';
    }

    // App Transport Security blocks plain http on iOS; every klokkin asset is
    // available over TLS, so upgrade instead of failing silently.
    if (url.startsWith('http://')) {
      url = 'https://${url.substring('http://'.length)}';
    }

    // Encode spaces and other raw characters that make Uri.parse produce a
    // URI the native player refuses to open.
    if (url.contains(' ')) {
      url = Uri.encodeFull(url);
    }

    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) return null;

    return uri.toString();
  }

  /// Same as [normalize] but returns a parsed [Uri], or `null`.
  static Uri? toUri(String? raw) {
    final normalized = normalize(raw);
    return normalized == null ? null : Uri.tryParse(normalized);
  }

  /// File extension for a media URL, falling back to [fallback] when the URL
  /// carries no usable one (query strings and presigned params stripped).
  static String extensionOf(String url, {String fallback = '.mp4'}) {
    final path = Uri.tryParse(url)?.path ?? url.split('?').first;
    final dot = path.lastIndexOf('.');
    if (dot == -1 || dot == path.length - 1) return fallback;
    final ext = path.substring(dot).toLowerCase();
    // Guard against a "." that is part of a folder name rather than the file.
    if (ext.length > 6 || ext.contains('/')) return fallback;
    return ext;
  }

  static bool isVideoUrl(String url) {
    const videoExts = {'.mp4', '.mov', '.m4v', '.avi', '.mkv', '.webm', '.3gp'};
    return videoExts.contains(extensionOf(url, fallback: ''));
  }

  /// A story whose media is a YouTube link cannot be fed to a
  /// `VideoPlayerController` (it hangs on the HTML page forever) and cannot be
  /// downloaded. Callers use this to pick the embedded YouTube player instead.
  static bool isYoutubeLink(String? url) {
    if (url == null || url.isEmpty) return false;
    final u = url.toLowerCase();
    return u.contains('youtube.com/') || u.contains('youtu.be/');
  }

  static bool isImageUrl(String url) {
    const imageExts = {'.jpg', '.jpeg', '.png', '.gif', '.webp', '.heic', '.bmp'};
    return imageExts.contains(extensionOf(url, fallback: ''));
  }
}
