# Klokkin App

A Flutter-based storytelling platform for Android and iOS where users can create, share, and discover stories in audio, audiobook, image, and video formats.

## Features

### Dashboard (Home)
- **Latest Stories Feed** — Browse the newest stories from the community with a paginated feed.
- **My Stories** — View your own uploaded stories with pagination support.
- **Tag Management** — Discover and update tags to personalize your story feed.
- **Announcements** — In-app announcement/banner cards fetched from the server.
- **Working Days & Story Steps** — Guided onboarding data for story creation workflows.

### Create Story
- **Image Stories** — Upload up to 5 images from the gallery or camera with optional thumbnail selection, caption, description, and tags.
- **Audio Stories** — Record audio directly in-app using AAC-LC codec (128kbps, 44100Hz) with real-time waveform visualization, pause/resume/restart, and auto-save to internal storage.
- **Video Stories** — Record video from camera (up to 60 seconds), pick from gallery, and add title/description before publishing.
- **Multi-step Creation Flow** — Guided creation pipeline: Start → Next → Upload → Post Story, with dedicated screens for each media type.
- **Story Editing** — Edit caption and description of existing stories after publishing.

### Story Viewing
- **Audio Player** — Full playback controls (play/pause/seek), playback speed adjustment (0.5X–2X), and progress tracking.
- **Audiobook Player** — Advanced audio book player with `just_audio`, position/duration streams, current index tracking, and pagination for audio/video/image stories.
- **Image Viewer** — Browse image stories with detailed full-screen views.
- **Video Viewer** — Network video playback with play/pause/seek/speed control and detailed view mode.
- **Multiple Video Controllers** — Auto-pause other videos when one plays (work card grid, library cards).

### Library
- **Browse All Stories** — Filter by type: Audio, Video, or Image tabs with pagination and load-more.
- **Bookmarks** — Bookmark/unbookmark stories with a dedicated bookmarks screen.
- **Downloads** — Download stories for offline viewing with metadata persistence (title, subtitle, hashtags, original URL, download date). Save to device gallery via `ImageGallerySaverPlus`.
- **S3 Support** — Auto-detects S3 presigned URLs, handles auth token fallback for private content.
- **Download Management** — List, view, and delete downloaded content. Concurrent download prevention.

### Reports
- **Usage Stats** — View counts and share counts displayed across story cards and library.
- **Feedback** — Submit feedback with optional screenshot/file attachment.

### Notifications
- **Notification Center** — In-app notification screen with paginated list, view status tracking, and total results display.

### Settings
- **System Settings** — Access device and app settings.
- **Permissions Management** — Guided permission setup for camera, microphone, storage, and gallery access.
- **Theme Support** — Light/Dark theme toggle (default: dark).
- **Terms & Conditions** — In-app terms of service page fetched from the server.
- **Privacy Policy** — In-app privacy policy page fetched from the server.
- **About Us** — App information and team details fetched from the server.
- **Help / FAQ** — Question and help screen for user support.
- **Delete Account** — Delete your account and all associated data.

### Authentication
- **Sign Up** — Email and password-based registration with first name, phone, terms acceptance, and email validation.
- **OTP Verification** — Verify account via a PIN code sent to email, with 60-second countdown timer and resend OTP support.
- **Sign In** — Login with email/password, role-based routing (user/admin), and persistent Bearer token storage.
- **Forgot Password** — Request a password reset link via email OTP flow.
- **Reset Password** — Set a new password via a secure reset flow with confirmation.
- **Change Password** — Update your account password from settings.

### Onboarding
- **Splash Screen** — App launch with dependency injection setup and portrait orientation lock.
- **Onboarding Screens** — Multi-step introduction to the app's key features with smooth page indicators.

### Profile
- **View Profile** — See account email, name, phone, avatar, nickname, about-self, gender, and date of birth.
- **Edit Profile** — Update name, nickname, about-self, gender, date of birth, and profile picture (image picker via multipart PATCH request).
- **Personal Info** — Dedicated screen for viewing and updating personal details.

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | [GetX](https://pub.dev/packages/get) |
| Navigation | [GoRouter](https://pub.dev/packages/go_router) |
| Responsive UI | [Flutter ScreenUtil](https://pub.dev/packages/flutter_screenutil) (393×852) |
| Media | [video_player](https://pub.dev/packages/video_player), [camera](https://pub.dev/packages/camera), [record](https://pub.dev/packages/record), [image_picker](https://pub.dev/packages/image_picker), [file_picker](https://pub.dev/packages/file_picker), [just_audio](https://pub.dev/packages/just_audio) |
| Audio Waveforms | [flutter_audio_waveforms](https://pub.dev/packages/flutter_audio_waveforms) |
| Network | Custom HTTP client + [internet_connection_checker_plus](https://pub.dev/packages/internet_connection_checker_plus) |
| Local Storage | [SharedPreferences](https://pub.dev/packages/shared_preferences) |
| Downloads | [image_gallery_saver_plus](https://pub.dev/packages/image_gallery_saver_plus), [path_provider](https://pub.dev/packages/path_provider) |
| UI Extras | [shimmer](https://pub.dev/packages/shimmer), [lottie](https://pub.dev/packages/lottie), [flutter_svg](https://pub.dev/packages/flutter_svg), [smooth_page_indicator](https://pub.dev/packages/smooth_page_indicator), [pin_code_fields](https://pub.dev/packages/pin_code_fields), [flutter_rating_bar](https://pub.dev/packages/flutter_rating_bar), [flutter_staggered_animations](https://pub.dev/packages/flutter_staggered_animations), [flutter_spinkit](https://pub.dev/packages/flutter_spinkit), [toastification](https://pub.dev/packages/toastification), [quickalert](https://pub.dev/packages/quickalert), [flutter_widget_from_html](https://pub.dev/packages/flutter_widget_from_html) |
| Permissions | [permission_handler](https://pub.dev/packages/permission_handler) |
| Sharing | [share_plus](https://pub.dev/packages/share_plus) |
| HTML Rendering | [flutter_widget_from_html](https://pub.dev/packages/flutter_widget_from_html) |
| Country Picker | [country_pickers](https://pub.dev/packages/country_pickers) |
| Image Caching | [cached_network_image](https://pub.dev/packages/cached_network_image) |
| HTTP | [http](https://pub.dev/packages/http) / [http_parser](https://pub.dev/packages/http_parser) |
| Connectivity | [connectivity_plus](https://pub.dev/packages/connectivity_plus) |

## Architecture

Hybrid MVC/MVVM with GetX:

```
lib/
├── controllers/          # GetX controllers (home, audio, library, download, notifications, etc.)
├── presentations/
│   ├── controller/       # Auth & theme controllers
│   ├── screens/          # All app screens (37+ screens: home, create story, library, auth, profile, etc.)
│   └── widgets/          # Reusable UI components (38 widgets: cards, buttons, audio players, profile UI, etc.)
├── models/               # JSON-serializable data models (9 models)
├── services/             # API client, endpoints, download service
├── core/
│   ├── config/           # Routes, themes
│   ├── constants/        # Colors, app constants, validation rules
│   └── helpers/          # Dependency injection, network monitoring, toast messages, download helpers
└── global/
    └── custom_assets/    # Generated asset references (flutter_gen)
```

## Platform Support

| Platform | Support |
|---|---|
| Android | Full support |
| iOS | Partial |

## Getting Started

### Prerequisites

- Flutter SDK (Dart `^3.7.0`)
- Android Studio or VS Code
- Android device or emulator (API 21+)

### Setup

```bash
# Clone the repository
git clone https://github.com/sparktechagency/klokkin-app.git
cd klokkin-app

# Install dependencies
flutter pub get

# Generate assets
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Required Android Permissions

Grant the following permissions on your Android device for full functionality:

- **Camera** — For photo and video story creation
- **Microphone** — For audio recording
- **Storage / Photos** — For saving downloads to gallery (Android 13+)
- **Notification Permission** — For in-app alerts

## Project Structure

```
lib/
├── controllers/          # GetX controllers (home, audio, library, download, record, notifications, profile, etc.)
├── presentations/
│   ├── controller/       # Auth controller, theme controller
│   ├── screens/          # All app screens (auth, home, create story, story viewing, library, profile, notifications, etc.)
│   └── widgets/          # Reusable UI components (cards, buttons, audio players, profile UI, no-internet screen, etc.)
├── models/               # JSON-serializable data models (tags, stories, profile, notifications, etc.)
├── services/             # API client with multipart upload, endpoint constants, download service with S3 support
├── core/
│   ├── config/           # GoRouter routes (42 named routes), light/dark themes
│   ├── constants/        # App colors, shared constants, validation rules
│   └── helpers/          # Dependency injection, network connectivity monitoring, toast messages, quick alerts, download helper
└── global/
    └── custom_assets/    # Generated asset references (flutter_gen)
```

## API

- **Base URL:** `https://api.klokkin.com/api/v1`
- **Auth:** Bearer token in `Authorization` header (persisted via SharedPreferences)
- **Timeout:** 20 seconds per request
- **Response:** JSON with error parsing and network error detection

### Key Endpoints

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/auth/register` | User registration |
| POST | `/auth/login` | User login |
| POST | `/auth/verify-email` | OTP verification |
| POST | `/auth/forgot-password` | Forgot password with OTP |
| POST | `/auth/reset-password` | Reset password |
| POST | `/auth/resend-otp` | Resend OTP with countdown |
| POST | `/auth/change-password` | Change password |
| GET | `/tag/tags` | Fetch all tags |
| PATCH | `/tag/tags/:id` | Update user tags |
| POST | `/story/story` | Upload new story (multipart) |
| GET | `/story/story` | Latest stories feed |
| GET | `/story/stories?page=X` | My stories (paginated) |
| GET | `/story/story/:id` | Single story detail |
| POST | `/story/bookmark` | Bookmark / unbookmark story |
| GET | `/story/libraryData` | Library data with pagination |
| GET/PATCH/DELETE | `/user/profile` | Fetch / update / delete profile |
| PATCH | `/story/story/:id` | Update story |
| DELETE | `/story/story/:id` | Delete story |
| POST | `/feedback/feedbacks` | Submit feedback |
| GET | `/setting/privacy-policy` | Privacy policy content |
| GET | `/setting/about-us` | About Us content |
| GET | `/setting/terms-conditions` | Terms & Conditions content |
| GET | `/notification/?page=X` | Notifications (paginated) |
