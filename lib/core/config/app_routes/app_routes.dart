import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/presentations/screens/auth/privacy/privacy.dart';
import 'package:klokkin_app/presentations/screens/auth/terms/terms.dart';
import 'package:klokkin_app/presentations/screens/bottom_navbar/bottom_navbar_screen.dart';
import 'package:klokkin_app/presentations/screens/everystory/every_story_screen.dart';
import 'package:klokkin_app/presentations/screens/home/createStory/create_post_story.dart';
import 'package:klokkin_app/presentations/screens/home/createStory/next_create_story.dart';
import 'package:klokkin_app/presentations/screens/home/createStory/record_screen.dart';
import 'package:klokkin_app/presentations/screens/home/home_screen.dart';
import 'package:klokkin_app/presentations/screens/library/library_screen.dart';
import 'package:klokkin_app/presentations/screens/profile/about_screen.dart';
import 'package:klokkin_app/presentations/screens/profile/feedback_screen.dart';
import 'package:klokkin_app/presentations/screens/profile/system_settings.dart';

import '../../../presentations/screens/auth/forget/forget_password_screen.dart';
import '../../../presentations/screens/auth/reset/reset_pass_screen.dart';
import '../../../presentations/screens/auth/signIn/sign_in_screen.dart';
import '../../../presentations/screens/auth/signup/sign_up_screen.dart';
import '../../../presentations/screens/auth/verification/verification_screen.dart';
import '../../../presentations/screens/home/createStory/audio_record_add_post_details_screen.dart';
import '../../../presentations/screens/home/createStory/record_video_list_page.dart';
import '../../../presentations/screens/home/createStory/start_create_story.dart';
import '../../../presentations/screens/home/createStory/upload_create_story.dart';
import '../../../presentations/screens/home/createStory/video_create_story_screen.dart';
import '../../../presentations/screens/home/createStory/video_record_add_post_details_screen.dart';
import '../../../presentations/screens/library/bookmark_screen.dart';
import '../../../presentations/screens/library/download_screen.dart';
import '../../../presentations/screens/library/download_screen.dart';
import '../../../presentations/screens/notifications/notification_screen.dart';
import '../../../presentations/screens/onboarding/onboarding_screen.dart';
import '../../../presentations/screens/profile/permission_screen.dart';
import '../../../presentations/screens/profile/personal_screen.dart';
import '../../../presentations/screens/profile/personal_screen_update.dart';
import '../../../presentations/screens/profile/profile_screen.dart';
import '../../../presentations/screens/profile/question_help_screen.dart';
import '../../../presentations/screens/splash/splash_screen.dart';
import '../../../presentations/screens/story/story_audio_book_screen.dart';
import '../../../presentations/screens/story/story_audio_screen.dart';
import '../../../presentations/screens/story/story_edit_screen.dart';
import '../../../presentations/screens/story/story_image_details_screen.dart';
import '../../../presentations/screens/story/story_image_screen.dart';
import '../../../presentations/screens/story/story_screen.dart';
import '../../../presentations/screens/story/story_video_details_screen.dart';
import '../../../presentations/screens/story/story_video_screen.dart';
import '../../app_constants/app_constants.dart';
import '../../helpers/prefs_helper.dart';

class AppRoutes {
  static const String splashScreen = "/splashScreen";
  static const String onBoardingScreen = "/onBoardingScreen";

  /// =============================> Auth ================================>

  static const String signUpScreen = "/signUpScreen";
  static const String logInScreen = "/logInScreen";
  static const String forgetPasswordScreen = "/forgetPasswordScreen";
  static const String verifyScreen = "/verifyScreen";
  static const String resetPasswordScreen = "/resetPasswordScreen";
  static const String termsServicesScreen = "/termsServicesScreen";
  static const String privacyPolicyScreen = "/privacyPolicyScreen";

  /// ============================> Home ================================>

  static const String homeScreen = "/homeScreen";
  static const String startCreateStoryScreen = "/startCreateStoryScreen";
  static const String nextCreateStoryScreen = "/nextCreateStoryScreen";
  static const String bottomNavbarScreen = "/bottomNavbarScreen";
  static const String everyStoryScreen = "/everyStoryScreen";
  static const String uploadCreateStoryScreen = "/uploadCreateStoryScreen";
  static const String recordStoryScreen = "/recordStoryScreen";
  static const String videoCreateStoryScreen = "/videoCreateStoryScreen";
  static const String storyScreen = "/storyScreen";
  static const String createPostStoryScreen = "/createPostStoryScreen";
  static const String storyAudioScreen = "/storyAudioScreen";
  static const String storyEditScreen = '/story-edit';
  static const String storyAudioBookScreen = "/storyAudioBookScreen";
  static const String storyImageScreen = "/storyImageScreen";
  static const String storyImageDetailsScreen = "/storyImageDetailsScreen";
  static const String storyVideoScreen = "/storyVideoScreen";
  static const String storyVideoDetailsScreen = "/storyVideoDetailsScreen";
  static const String libraryScreen = "/libraryScreen";
  static const String bookmarkScreen = "/bookmarkScreen";
  static const String downloadScreen = "/downloadScreen";
  static const String profileScreen = "/profileScreen";
  static const String personalScreen = "/personalScreen";
  static const String personalScreenUpdate = "/personalScreenUpdate";
  static const String systemSettingScreen = "/systemSettingScreen";
  static const String feedbackScreen = "/feedbackScreen";
  static const String permissionScreen = "/permissionScreen";
  static const String aboutScreen = "/aboutScreen";
  static const String questionHelpScreen = "/questionHelpScreen";
  static const String recordVideoListPageScreen = "/recordVideoListPageScreen";
  static const String recordVideoPlayerScreen = "/recordVideoPlayerScreen";
  static const String audioRecordAddPostDetailsScreen = "/audioRecordAddPostDetailsScreen";
  static const String videoRecordAddPostDetailsScreen = "/videoRecordAddPostDetailsScreen";
  static const String notificationsScreen = "/notificationsScreen";

  static final GoRouter goRouter = GoRouter(
    initialLocation: splashScreen,
    routes: [
      GoRoute(
        path: splashScreen,
        name: splashScreen,
        builder: (context, state) => const SplashScreen(),
        // redirect: (context, state) {
        //   Future.delayed(const Duration(seconds: 3), () async {
        //     var role = await PrefsHelper.getString(AppConstants.role);
        //     var token = await PrefsHelper.getString(AppConstants.bearerToken);
        //     if (token != "") {
        //       /// ===============Role Check =============>>>
        //       if (role == "user") {
        //         AppRoutes.goRouter.replaceNamed(AppRoutes.bottomNavbarScreen);
        //       }
        //     }
        //     else {
        //       AppRoutes.goRouter.replaceNamed(AppRoutes.onBoardingScreen);
        //     }
        //   });
        //
        //   return;
        // },
      ),

      ///<<<=============>>> ONBOARDING SCREEN <<<===============>>>
      GoRoute(
        path: onBoardingScreen,
        name: onBoardingScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(OnboardingScreen(), state),
      ),

      /// =============================================================> Auth  =================================================>

      ///<<<=============>>> Sign Up SCREEN <<<===============>>>
      GoRoute(
        path: signUpScreen,
        name: signUpScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(SignUpScreen(), state),
      ),

      ///<<<=============>>> Log In <<<===============>>>
      GoRoute(
        path: logInScreen,
        name: logInScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(LoginScreen(), state),
      ),

      ///<<<=============>>> Forget Password Screen  <<<===============>>>
      GoRoute(
        path: forgetPasswordScreen,
        name: forgetPasswordScreen,
        builder: (context, state) {
          String email = state.extra as String;
          return ForgetPasswordScreen(email: email);
        },
        // pageBuilder: (context, state) =>
        //     _customTransitionPage(ForgetPasswordScreen(), state),
      ),

      ///<<<=============>>> Verify Screen  <<<===============>>>
      GoRoute(
        path: verifyScreen,
        name: verifyScreen,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final screenType = extra['screenType']?.toString() ?? '';
          final email = extra['email']?.toString() ?? '';
          final token = extra['token']?.toString() ?? '';
          return VerifyScreen(
            screenType: screenType,
            email: email,
            token: token,
          );
        },
      ),

      ///<<<=============>>> Reset Password Screen  <<<===============>>>
      GoRoute(
        path: resetPasswordScreen,
        name: resetPasswordScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(ResetPasswordScreen(), state),
      ),

      ///<<<=============>>> Terms Services Screen  <<<===============>>>
      GoRoute(
        path: termsServicesScreen,
        name: termsServicesScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(TermsServicesScreen(), state),
      ),

      ///<<<=============>>> Privacy Policy Screen  <<<===============>>>
      GoRoute(
        path: privacyPolicyScreen,
        name: privacyPolicyScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(PrivacyPolicyScreen(), state),
      ),

      /// =============================================================> Home =================================================>

      ///<<<=============>>>  Home Screen  <<<===============>>>
      GoRoute(
        path: homeScreen,
        name: homeScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(HomeScreen(), state),
      ),

      ///<<<=============>>>  Start Create Story Screen <<<===============>>>
      GoRoute(
        path: startCreateStoryScreen,
        name: startCreateStoryScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(StartCreateStoryScreen(), state),
      ),

      ///<<<=============>>>  Next Create Story Screen <<<===============>>>
      GoRoute(
        path: nextCreateStoryScreen,
        name: nextCreateStoryScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(NextCreateStoryScreen(), state),
      ),

      ///<<<=============>>> Bottom Navbar Screen <<<===============>>>
      GoRoute(
        path: bottomNavbarScreen,
        name: bottomNavbarScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(BottomNavBar(), state),
      ),

      ///<<<=============>>>Every Story Screen  <<<===============>>>
      GoRoute(
        path: everyStoryScreen,
        name: everyStoryScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(EveryStoryScreen(), state),
      ),

      ///<<<=============>>> Upload Create Story Screen  <<<===============>>>
      GoRoute(
        path: uploadCreateStoryScreen,
        name: uploadCreateStoryScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(UploadCreateStoryScreen(), state),
      ),

      //<<<=============>>> Record Story Screen  <<<===============>>>
      GoRoute(
        path: recordStoryScreen,
        name: recordStoryScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(RecordStoryScreen(), state),
      ),


      //<<<=============>>> Record Story Screen  <<<===============>>>

      GoRoute(
        path: recordVideoListPageScreen,
        name: recordVideoListPageScreen,
        pageBuilder:
            (context, state) =>
            _customTransitionPage(RecordVideoListPageScreen(), state),
      ),

      //<<<=============>>> Audio Record Add Post DetailsScreen  <<<===============>>>
      GoRoute(
        path: audioRecordAddPostDetailsScreen,
        name: audioRecordAddPostDetailsScreen,
        pageBuilder:
            (context, state) =>
            _customTransitionPage(AudioRecordAddPostDetailsScreen(), state),
      ),
      GoRoute(
        path: videoRecordAddPostDetailsScreen,
        name: videoRecordAddPostDetailsScreen,
        pageBuilder:
            (context, state) =>
            _customTransitionPage(VideoRecordAddPostDetailsScreen(), state),
      ),


      // GoRoute(
      //   path: recordVideoPlayerScreen,
      //   name: recordVideoPlayerScreen,
      //   pageBuilder:
      //       (context, state) =>
      //       _customTransitionPage(RecordVideoPlayerScreen(videoFile: null,), state),
      // ),

      //<<<=============>>> Video Story Screen  <<<===============>>>
      GoRoute(
        path: videoCreateStoryScreen,
        name: videoCreateStoryScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(VideoCreateStoryScreen(), state),
      ),

      //<<<=============>>>  Story Screen  <<<===============>>>
      GoRoute(
        path: storyScreen,
        name: storyScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(StoryScreen(), state),
      ),

      //<<<=============>>>  Story Audio Screen  <<<===============>>>
      GoRoute(
        path: storyAudioScreen,
        name: storyAudioScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(StoryAudioScreen(), state),
      ),

      GoRoute(
        path: AppRoutes.storyEditScreen,
        name: AppRoutes.storyEditScreen,
        builder: (context, state) =>  StoryEditScreen(),
      ),

      //<<<=============>>>  Story Audio Book Screen  <<<===============>>>
      GoRoute(
        path: storyAudioBookScreen,
        name: storyAudioBookScreen,
        pageBuilder:
            (context, state) =>
            _customTransitionPage(StoryAudioBookScreen(), state),
      ),


      //<<<=============>>>  Story Image Screen  <<<===============>>>
      GoRoute(
        path: storyImageScreen,
        name: storyImageScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(StoryImageScreen(), state),
      ),

      //<<<=============>>>  Story Image Screen  <<<===============>>>
      GoRoute(
        path: storyImageDetailsScreen,
        name: storyImageDetailsScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(StoryImageDetailsScreen(), state),
      ),
      //<<<=============>>>  Story Video Screen  <<<===============>>>
      GoRoute(
        path: storyVideoScreen,
        name: storyVideoScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(StoryVideoScreen(), state),
      ),

      //<<<=============>>>  Story Video Details Screen  <<<===============>>>
      GoRoute(
        path: storyVideoDetailsScreen,
        name: storyVideoDetailsScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(StoryVideoDetailsScreen(), state),
      ),

      //<<<=============>>>  Library Screen  <<<===============>>>
      GoRoute(
        path: libraryScreen,
        name: libraryScreen,
        pageBuilder: (context, state) {
          final videoPath = state.extra as String? ?? "";
          return _customTransitionPage(
            LibraryScreen(videoPath: videoPath),
            state,
          );
        },
      ),


      //<<<=============>>>  Bookm arkScreen Screen  <<<===============>>>
      GoRoute(
        path: bookmarkScreen,
        name: bookmarkScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(BookmarkScreen(), state),
      ),

      //<<<=============>>>  Download  Screen  <<<===============>>>
      GoRoute(
        path: downloadScreen,
        name: downloadScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(DownloadScreen(), state),
      ),

      //<<<=============>>>  Profile  Screen  <<<===============>>>
      GoRoute(
        path: profileScreen,
        name: profileScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(ProfileScreen(), state),
      ),

      //<<<=============>>>  PersonalScreenUpdate<<<===============>>>
      GoRoute(
        path: personalScreen,
        name: personalScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(PersonalScreen(), state),
      ),
      GoRoute(
        path: personalScreenUpdate,
        name: personalScreenUpdate,
        pageBuilder:
            (context, state) => _customTransitionPage(PersonalScreenUpdate(), state),
      ),

      //<<<=============>>>  Personal  Screen  <<<===============>>>
      GoRoute(
        path: systemSettingScreen,
        name: systemSettingScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(SystemSettingScreen(), state),
      ),

      //<<<=============>>>  Personal  Screen  <<<===============>>>
      GoRoute(
        path: feedbackScreen,
        name: feedbackScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(FeedbackScreen(), state),
      ),
      //<<<=============>>>  Permission  Screen  <<<===============>>>
      GoRoute(
        path: permissionScreen,
        name: permissionScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(PermissionScreen(), state),
      ),
      //<<<=============>>>  About  Screen  <<<===============>>>
      GoRoute(
        path: aboutScreen,
        name: aboutScreen,
        pageBuilder:
            (context, state) => _customTransitionPage(AboutScreen(), state),
      ),
      //<<<=============>>>  Question Help Screen  <<<===============>>>
      GoRoute(
        path: questionHelpScreen,
        name: questionHelpScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(QuestionHelpScreen(), state),
      ),

      //<<<=============>>>  Create PostStory Screen  <<<===============>>>
      GoRoute(
        path: createPostStoryScreen,
        name: createPostStoryScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(CreatePostStoryScreen(), state),
      ),

      //<<<=============>>>  Notifications Screen  <<<===============>>>

      GoRoute(
        path: notificationsScreen,
        name: notificationsScreen,
        pageBuilder:
            (context, state) =>
                _customTransitionPage(NotificationsScreen(), state),
      ),





    ],
  );

  static Page<dynamic> _customTransitionPage(
    Widget child,
    GoRouterState state,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
