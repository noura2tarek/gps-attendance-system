# CheckMate

CheckMate is a GPS-based HR attendance tracking system that enables employees to check in/out from designated locations. It provides real-time tracking, reports, and leave management.

## Features
- **GPS-Based Check-In/Out** Employees can check in only within specified locations.
- **Leaves Management** Employees can request leaves, and admins can approve/reject.
- **Authentication** Firebase-based login with Email and Password.
- **Live Tracking** HR managers can monitor attendance in realtime.  
- **Localization** Supports multiple languages for a better user experience.
- **Register New User** Admin can register new employee and add his role.
- **Leave Balance** Admin can check the leave balance for each employee.

## Tech-stack
- **Frontend:** Flutter (Dart)
- **Backend:** Firebase (Firestore, Authentication)
- **State Management:** BLoC
- **GPS Services:** Google Maps API 

## Getting Started

There is 3 flavors for this app:
- staging
- development
- production

# staging
$ flutter run --flavor staging --target lib/main_staging.dart

# development
$ flutter run --flavor development --target lib/main_development.dart

# production
$ flutter run --flavor production --target lib/main_production.dart

# Packages
This project uses the following **Flutter packages**:

### ✅ Core Dependencies
- [`bloc`](https://pub.dev/packages/bloc) - State management using BLoC pattern.
- [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) - Integration of BLoC with Flutter widgets.
- [`equatable`](https://pub.dev/packages/equatable) - Simplifies state comparisons in BLoC.
- [`firebase_core`](https://pub.dev/packages/firebase_core) - Connects the app to Firebase.
- [`firebase_auth`](https://pub.dev/packages/firebase_auth) - Handles user authentication.
- [`cloud_firestore`](https://pub.dev/packages/cloud_firestore) - NoSQL database for storing app data.
- [`shared_preferences`](https://pub.dev/packages/shared_preferences) - Local storage for lightweight data.
- [`intl`](https://pub.dev/packages/intl) - Internationalization and date formatting.
- [`uuid`](https://pub.dev/packages/uuid) - Generates unique IDs.

### 📍 Location & Maps
- [`geolocator`](https://pub.dev/packages/geolocator) - Access user location and GPS data.
- [`google_maps_flutter`](https://pub.dev/packages/google_maps_flutter) - Embeds Google Maps into the app.

### 🎨 UI & Utilities
- [`calendar_timeline`](https://pub.dev/packages/calendar_timeline) - Displays a horizontal calendar widget.
- [`skeletonizer`](https://pub.dev/packages/skeletonizer) - Shows loading skeleton placeholders.

### 🛠 Development & Testing
- [`bloc_test`](https://pub.dev/packages/bloc_test) - Testing utilities for BLoC.
- [`mocktail`](https://pub.dev/packages/mocktail) - Mocking framework for unit tests.
- [`build_runner`](https://pub.dev/packages/build_runner) - Code generation utilities.
- [`very_good_analysis`](https://pub.dev/packages/very_good_analysis) - Linting and best practices enforcement.
- [`flutter_test`](https://pub.dev/packages/flutter_test) - Built-in Flutter testing framework.