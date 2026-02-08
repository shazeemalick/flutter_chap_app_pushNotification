# 📱 Flutter Chat App

A modern, real-time chat application built with Flutter and Firebase, featuring secure authentication, instant messaging, and push notifications.

---

## ✨ Features

- **🔐 Secure Authentication**: Email-based signup and login powered by Firebase Auth.
- **💬 Real-time Messaging**: Instant message delivery and updates using Firebase Realtime Database.
- **🔔 Push Notifications**: Stay updated with new messages via Firebase Cloud Messaging (FCM) and Local Notifications.
- **🖼️ Profile Management**: Upload and manage profile pictures with Firebase Storage.
- **🚀 State Management**: Robust and scalable state management using Flutter Riverpod.
- **🎨 Modern UI**: Clean, intuitive interface with smooth animations and Google Fonts.

---

## 🛠️ Tech Stack

- **Frontend**: [Flutter](https://flutter.dev/) (Dart)
- **Backend/Database**: [Firebase](https://firebase.google.com/)
  - Authentication
  - Realtime Database
  - Cloud Messaging (FCM)
  - Cloud Storage
- **State Management**: [Riverpod](https://riverpod.dev/)
- **Utility Libraries**:
  - `flutter_local_notifications`
  - `cached_network_image`
  - `animate_do`
  - `google_fonts`

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest version recommended)
- Firebase Account
- Android Studio / VS Code with Flutter extensions

### Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone https://github.com/shazeemalick/flutter_chap_app_pushNotification.git
   cd flutter_chap_app_pushNotification
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**:
   - Create a new Project on [Firebase Console](https://console.firebase.google.com/).
   - Add Android/iOS apps and download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
   - Place them in their respective directories (`android/app/` and `ios/Runner/`).
   - Enable Email/Password Auth, Realtime Database, and Storage in Firebase Console.

4. **Run the app**:
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```text
lib/
├── core/           # Core services (FCM, etc.)
├── features/       # Feature-based modules (Auth, Chat)
│   ├── auth/       # Authentication logic and UI
│   └── chat/       # Messaging logic and UI
├── shared/         # Shared widgets and utilities
└── firebase_options.dart # Generated Firebase config
```

---

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Developed with ❤️ by ShahzaibAsif(https://github.com/shazeemalick)**
