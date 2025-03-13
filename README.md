# CheckMate

CheckMate is a GPS-based HR attendance tracking system that enables employees to check in/out from designated locations. It provides real-time tracking, reports, and leave management.

## Features
- **GPS-Based Check-In/Out** – Employees can check in only within specified locations.
- **Leaves Management** – Employees can request leaves, and admins can approve/reject.
- **Authentication** – Firebase-based login with Email and Password Sign-In.
- **Live Tracking** – HR managers can monitor attendance in real time.  
- **Localization** – Supports multiple languages for a better user experience.

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
