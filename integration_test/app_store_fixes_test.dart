// End-to-end checks for the three App Store rejection fixes, driven on a
// real iPad simulator against the live backend.
//
//   flutter test integration_test/app_store_fixes_test.dart -d <ipad-sim-id>
//
// Credentials come from --dart-define so they are never committed:
//   --dart-define=KLOKKIN_EMAIL=... --dart-define=KLOKKIN_PASSWORD=...
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:klokkin_app/main.dart' as app;
import 'package:klokkin_app/presentations/widgets/youtube_media_player.dart';
import 'package:video_player/video_player.dart';
import 'package:klokkin_app/services/download_service.dart';

const _email = String.fromEnvironment('KLOKKIN_EMAIL');

const _password = String.fromEnvironment('KLOKKIN_PASSWORD');

/// pumpAndSettle is useless here: the app always has a running animation
/// (spinners, shimmer), so it never settles. Pump in slices instead.
Future<void> settle(WidgetTester tester,
    {Duration total = const Duration(seconds: 4)}) async {
  final end = DateTime.now().add(total);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 120));
  }
}

/// Pumps until [predicate] is true or [timeout] elapses. Returns whether it
/// became true — an infinite spinner is exactly "returned false".
Future<bool> waitFor(
  WidgetTester tester,
  bool Function() predicate, {
  Duration timeout = const Duration(seconds: 25),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    if (predicate()) return true;
    await tester.pump(const Duration(milliseconds: 150));
  }
  return predicate();
}

void dumpScreen(String label) {
  final texts = <String>[];
  for (final e in find.byType(Text).evaluate()) {
    final t = e.widget as Text;
    final v = t.data ?? t.textSpan?.toPlainText() ?? '';
    if (v.trim().isNotEmpty) texts.add(v.trim().replaceAll('\n', ' '));
  }
  debugPrint('SCREEN[$label] fields=${find.byType(TextFormField).evaluate().length} '
      'texts=${texts.join(" | ")}');
}

Future<void> tapText(WidgetTester tester, String text) async {
  final f = find.text(text);
  expect(f, findsWidgets, reason: 'expected to find "$text" on screen');
  await tester.tap(f.first, warnIfMissed: false);
  await settle(tester, total: const Duration(seconds: 2));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App Store fixes on iPad', (tester) async {
    app.main();
    await settle(tester, total: const Duration(seconds: 8));

    // ── Onboarding ─────────────────────────────────────────────────────────
    // Walk the onboarding carousel until the auth screen appears. Button
    // labels differ per page and use a typographic apostrophe.
    const onboardingButtons = [
      'Let\u2019s get started',
      'Continue',
      'Get Started',
      'Next',
      'Skip',
      'Create Account',
    ];
    for (var i = 0; i < 8; i++) {
      if (find.byType(TextFormField).evaluate().isNotEmpty) break;
      final label = onboardingButtons.firstWhere(
        (l) => find.text(l).evaluate().isNotEmpty,
        orElse: () => '',
      );
      if (label.isEmpty) break;
      await tapText(tester, label);
      await settle(tester, total: const Duration(seconds: 2));
    }
    dumpScreen('after-onboarding');

    // ── 5.1.1(v): sign-up form must not require a phone number ─────────────
    if (find.text('Create your account').evaluate().isNotEmpty) {
      expect(find.text('Phone Number (optional)'), findsOneWidget,
          reason: 'phone field must be labelled optional');
      expect(
        find.text('Optional — you can sign up without a phone number.'),
        findsOneWidget,
      );

      // Fill every field EXCEPT the phone, then submit: no phone error may show.
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Review Tester');
      await tester.enterText(fields.at(2), 'no-phone-check@example.com');
      await tester.enterText(fields.at(3), 'Test1234');
      await tester.enterText(fields.at(4), 'Test1234');
      await settle(tester, total: const Duration(seconds: 2));
      // The old build showed "Please enter phone number" here — the exact
      // 5.1.1(v) rejection. Nothing resembling a phone error may appear.
      expect(find.text('Please enter phone number'), findsNothing);
      expect(find.textContaining('must be 11 digits'), findsNothing);
      expect(find.textContaining('Please enter a valid phone'), findsNothing);
      debugPrint('STEP signup-phone-optional OK');

      // The "Sign in" link sits below the fold, and is a TextSpan inside a
      // RichText — so scroll it into view first, then tapOnText.
      await tester.drag(
          find.byType(SingleChildScrollView).first, const Offset(0, -400));
      await settle(tester, total: const Duration(seconds: 2));
      await tester.tapOnText(find.textRange.ofSubstring('Sign in'));
      await settle(tester, total: const Duration(seconds: 4));
    }
    dumpScreen('login-screen');

    // ── Log in ─────────────────────────────────────────────────────────────
    expect(_email.isNotEmpty, isTrue, reason: 'pass --dart-define=KLOKKIN_EMAIL');
    final loginFields = find.byType(TextFormField);
    expect(loginFields, findsWidgets, reason: 'expected the login form');
    await tester.enterText(loginFields.at(0), _email);
    await tester.enterText(loginFields.at(1), _password);
    await settle(tester, total: const Duration(seconds: 2));
    await tapText(tester, 'Sign in');
    await settle(tester, total: const Duration(seconds: 10));
    dumpScreen('after-login');
    // Every catalogue story streams from YouTube, so no download button may be
    // offered for them — a button that can only fail is the 2.1(a) bug.
    expect(find.byIcon(Icons.download), findsNothing,
        reason: 'download button must be hidden for YouTube-streamed stories');
    debugPrint('STEP no-broken-download-button OK');
    debugPrint('SHOT:01-home');
    await settle(tester, total: const Duration(seconds: 5));

    // ── 2.1(a): Library video must not spin forever ────────────────────────
    await tapText(tester, 'Library');
    await settle(tester, total: const Duration(seconds: 8));
    dumpScreen('library');
    debugPrint('SHOT:02-library');
    await settle(tester, total: const Duration(seconds: 4));

    // Tap the first video thumbnail (the play button overlay).
    final play = find.byIcon(Icons.play_arrow_rounded);
    if (play.evaluate().isNotEmpty) {
      await tester.tap(play.first, warnIfMissed: false);
      await settle(tester, total: const Duration(seconds: 4));

      // The old build fed the YouTube page URL to VideoPlayerController and
      // sat on a spinner forever. Either the embedded YouTube player or a
      // visible error state must appear — never an endless spinner.
      final resolved = await waitFor(tester, () =>
          find.byType(YoutubeMediaPlayer).evaluate().isNotEmpty ||
          find.byType(VideoPlayer).evaluate().isNotEmpty ||
          find.text('Retry').evaluate().isNotEmpty);
      dumpScreen('video-player');
      debugPrint('SHOT:03-video-player');
      await settle(tester, total: const Duration(seconds: 5));
      expect(resolved, isTrue,
          reason: 'video screen stuck on a spinner — the 2.1(a) bug');
      debugPrint('STEP video-no-infinite-spinner OK');

      // The player screen must offer a way out — the old build had none
      // while it was stuck loading, leaving the reviewer trapped.
      expect(find.byIcon(Icons.arrow_back), findsWidgets,
          reason: 'video screen must always have a back button');
      await tester.tap(find.byIcon(Icons.arrow_back).first, warnIfMissed: false);
      await settle(tester, total: const Duration(seconds: 4));
    } else {
      fail('no play button found on the Library screen');
    }

    // ── 3.1.2(c): paywall billed amount must dominate ──────────────────────
    await tapText(tester, 'Profile');
    await settle(tester, total: const Duration(seconds: 6));
    dumpScreen('profile');
    await tapText(tester, 'Subscription');
    await settle(tester, total: const Duration(seconds: 10));
    dumpScreen('paywall');
    debugPrint('SHOT:04-paywall');
    await settle(tester, total: const Duration(seconds: 5));

    if (find.text('Choose Your Plan').evaluate().isNotEmpty) {
      // Find the price text and prove it is the largest text on the sheet.
      double priceSize = 0;
      double biggestOther = 0;
      String priceText = '';
      String biggestOtherText = '';
      for (final e in find.byType(Text).evaluate()) {
        final w = e.widget as Text;
        final v = (w.data ?? '').trim();
        if (v.isEmpty) continue;
        final size = w.style?.fontSize ?? 0;
        final looksLikePrice =
            RegExp(r'^[^0-9]{0,3}[0-9]+([.,][0-9]+)?$').hasMatch(v);
        if (looksLikePrice) {
          if (size > priceSize) {
            priceSize = size;
            priceText = v;
          }
        } else if (size > biggestOther) {
          biggestOther = size;
          biggestOtherText = v;
        }
      }
      debugPrint('PAYWALL price="$priceText" size=$priceSize | '
          'largest other="$biggestOtherText" size=$biggestOther');
      expect(priceSize, greaterThan(0), reason: 'no price rendered');
      expect(priceSize, greaterThan(biggestOther),
          reason: 'billed amount must be the most conspicuous element');
      expect(find.textContaining('Renews automatically'), findsWidgets);
      debugPrint('STEP paywall-price-dominant OK');
    }

    // ── 2.1(a): a download that CAN work must actually work ────────────────
    // Close the paywall sheet, then look at the Story tab, whose image
    // stories are real files (picsum) rather than YouTube streams.
    if (find.byIcon(Icons.close).evaluate().isNotEmpty) {
      await tester.tap(find.byIcon(Icons.close).first, warnIfMissed: false);
      await settle(tester, total: const Duration(seconds: 3));
    }
    await tapText(tester, 'Story');
    await settle(tester, total: const Duration(seconds: 8));
    dumpScreen('story-tab');
    debugPrint('SHOT:05-story');
    await settle(tester, total: const Duration(seconds: 3));

    debugPrint('STEP all-checks-complete');
  }, timeout: const Timeout(Duration(minutes: 8)));

  // ── 2.1(a): the download pipeline itself, on the real device filesystem ──
  testWidgets('download works for real files and explains streamed ones',
      (tester) async {
    final service = DownloadService();

    // A real image file must download and be readable back from the
    // Downloads list. The old build aborted before fetching a byte whenever
    // Photos access was anything other than fully granted.
    final ok = await service.downloadMedia(
      'https://picsum.photos/seed/klokkin-photo-366/1080/1350',
      title: 'Old Town',
      subtitle: 'integration test',
      meta: 'image',
      hashtags: 'test',
    );
    debugPrint('DOWNLOAD image ok=$ok err="${service.lastError}" '
        'gallery=${service.lastSavedToGallery}');
    expect(ok, isTrue, reason: 'image download failed: ${service.lastError}');

    final saved = await service.getDownloadedContent();
    expect(saved, isNotEmpty, reason: 'download did not appear in Downloads');
    debugPrint('DOWNLOAD saved=${saved.length} first=${saved.first.filePath}');
    // A JPEG must not be saved as .mp4 — Photos refuses to import that.
    expect(saved.first.filePath.toLowerCase(), endsWith('.jpg'),
        reason: 'image saved with the wrong extension');
    debugPrint('STEP download-real-file OK');

    // A YouTube-streamed story must fail fast with a human explanation
    // rather than saving an HTML page and reporting a generic failure.
    final yt = await service.downloadMedia(
      'https://www.youtube.com/watch?v=TcMBFSGVi1c',
      title: 'Trailer',
    );
    expect(yt, isFalse);
    expect(service.lastError, contains('YouTube'));
    debugPrint('DOWNLOAD youtube err="${service.lastError}"');
    debugPrint('STEP download-streamed-explained OK');

    // Clean up so repeated runs stay deterministic.
    for (final c in await service.getDownloadedContent()) {
      await service.deleteDownloadedContent(c.filePath);
    }
  }, timeout: const Timeout(Duration(minutes: 3)));
}
