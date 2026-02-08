import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';

// Top-level background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

class FCMService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final AuthRepository _authRepository;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  FCMService(this._authRepository);

  Future<void> init() async {
    // 1. Request permissions
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
      
      // 2. Initialize Local Notifications for Foreground
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      
      // Positional argument is used for version 17.x
      await _localNotifications.initialize(initializationSettings);

      // 3. Get the token
      String? token = await _fcm.getToken();
      if (token != null) {
        await _authRepository.updatePushToken(token);
      }

      // 4. Listen for token refreshes
      _fcm.onTokenRefresh.listen((newToken) {
        _authRepository.updatePushToken(newToken);
      });

      // 5. Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Foreground Message: ${message.notification?.title}');
        
        if (message.notification != null) {
          _showLocalNotification(message);
        }
      });

      // 6. Handle background/terminated state when app is opened via notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('App opened via notification: ${message.data}');
      });
      
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'chat_messages',
      'Chat Messages',
      channelDescription: 'Notifications for new chat messages',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    // Positional arguments for show() in version 17.x
    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }
}
