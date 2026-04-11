# Klokkin App

A Flutter-based storytelling platform for Android and iOS where users can create, share, and discover stories in audio, audiobook, image, and video formats.

## Features

- **Auth Flow** — Sign up, email OTP verification, login, forgot/reset password
- **Story Creation** — Upload images, record audio, record video
- **Story Viewing** — Audio, audiobook, image, and video story formats
- **Library** — Bookmark and download stories (S3 support)
- **Profile** — Avatar, nickname, date of birth, gender management
- **Notifications** — In-app notification center
- **Browse** — Explore all stories with tag filtering
- **Offline Awareness** — Network connectivity detection with fallback UI
- **Shimmer Loading** — Skeleton screens for smooth loading experience

## Tech Stack

| Category | Library |
|---|---|
| State Management | [GetX](https://pub.dev/packages/get) v4.6.6 |
| Navigation | [go_router](https://pub.dev/packages/go_router) |
| Responsive UI | [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) (393×852) |
| Media | video_player, camera, record, image_picker, file_picker |
| Network | Custom HTTP client + internet_connection_checker_plus |
| Local Storage | shared_preferences |
| UI Extras | shimmer, lottie, flutter_svg, smooth_page_indicator |

## Architecture

Hybrid MVC/MVVM with GetX:

```
lib/
├── controllers/          # GetX business logic controllers
├── presentations/
│   ├── controller/       # Auth & theme controllers
│   ├── screens/          # All UI screens (37+ screens)
│   └── widgets/          # Reusable widget components
├── models/               # JSON-serializable data models
├── services/             # API client, endpoints, download service
├── core/                 # Routes, themes, constants, helpers
└── global/custom_assets/ # flutter_gen generated asset references
```

## Getting Started

### Prerequisites

- Flutter SDK (Dart `^3.7.0`)
- Android Studio / Xcode

### Setup

```bash
# Clone the repository
git clone https://github.com/your-org/klokkin-app.git
cd klokkin-app

# Install dependencies
flutter pub get

# Generate assets
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## API

- **Base URL:** `https://api.klokkin.com/api/v1`
- **Auth:** Bearer token in `Authorization` header
- All endpoints are defined in `lib/services/api_constants.dart`
