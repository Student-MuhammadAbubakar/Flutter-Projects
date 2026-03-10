
# Notes — Flutter Notes App

Simple, fully-featured notes application built with Flutter. Create, edit, delete, search, and organize notes with optional Firebase sync and local persistence.

**Features**
- **Create / Edit / Delete**: Add new notes, update existing ones, and remove notes.
- **Search & Sort**: Find notes quickly and sort by date or title.
- **Offline Support**: Notes persist locally and sync to cloud when available.
- **Sync (Firebase)**: Optional Firestore synchronization (project includes Firebase config files).
- **Cross-platform**: Works on Android, iOS, web, Windows, macOS and Linux.

**Tech stack**
- Flutter (Dart)
- Firebase (Cloud Firestore) — optional

**Quick Start**

Prerequisites:
- Install Flutter: https://flutter.dev/docs/get-started/install
- Android Studio or Xcode for mobile platforms (optional for web/desktop)

1. Clone the repo

```bash
git clone <your-repo-url>
cd notes
```

2. Install dependencies

```bash
flutter pub get
```

3. Configure Firebase (optional)
- For Android: place `google-services.json` in `android/app/` (the repo already includes a `google-services.json` placeholder).
- For iOS: add `GoogleService-Info.plist` to the Xcode project under `Runner`.
- Enable Firestore in your Firebase console if you want cloud sync.

4. Run the app

- Android

```bash
flutter run -d android
```

- iOS

```bash
flutter run -d ios
```

- Web

```bash
flutter run -d chrome
```

- Desktop (Windows/macOS/Linux)

```bash
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

**Build Release**

```bash
flutter build apk    # Android
flutter build ios    # iOS
flutter build web    # Web
flutter build windows # Windows
```

**Testing**

Run unit/widget tests:

```bash
flutter test
```

**Project structure**
- `lib/main.dart` — App entrypoint
- `lib/add_notes.dart` — Note creation / editing UI
- `lib/` — App source code
- `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/` — Platform folders

**Contributing**
- Fork the repo, create a feature branch, open a pull request.
- Keep changes focused and add tests where appropriate.

**Notes & Next Steps**
- If you plan to enable cloud sync, create a Firebase project and replace the placeholder config files with your own.
- You can add authentication, tags, or rich-text editing as enhancements.

**License**
- MIT (or change to your preferred license)

---

If you'd like, I can add screenshots, CI steps, or a Firebase setup walkthrough next.
