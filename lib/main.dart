import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/app_theme.dart';
import 'package:chat_app/core/app_constants.dart';
import 'package:chat_app/features/auth/presentation/auth_wrapper.dart';
import 'package:chat_app/core/fcm_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:chat_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint('Firebase initialization failed: \$e');
  }

  runApp(
    const ProviderScope(
      child: ChatFlowApp(),
    ),
  );
}

class ChatFlowApp extends ConsumerWidget {
  const ChatFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
    );
  }
}
