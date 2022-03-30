import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/logger_utils.dart';

/// NOTE : FOR THE NOTIFICATION PARTICULAR SCREEN NAVIGATION ::
///         PASS THE TYPE IN DATA FROM NODE SIDE IN JSON (INPUT)
///         AND GET HERE FROM NOTIFICATION (IN INPUT MAP)

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> getFBDeviceFCMTokenAndUpdate() async {
    try {
      String? token = await _firebaseMessaging.getToken();

      logger.i("FB DEVICE TOKEN : $token");

      if (token != null) {
        /// UPDATE USER DEVICE TOKEN
      } else {
        logger.wtf("FB DEVICE TOKEN IS EMPTY");
      }
    } catch (e) {
      logger.e(e);
      logger.w("FB DEVICE TOKEN IS EMPTY");
    }
  }

  static Future<void> initNotificationConfig() async {
    _initializeLocalNtf();

    /// NOTIFICATION SHOW WHEN APP IS OPEN ::

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        AndroidNotificationDetails andNTFDetails =
            const AndroidNotificationDetails(
          "channel id",
          "channel name",
          icon: '@mipmap/ic_launcher',
          playSound: true,
          importance: Importance.high,
          priority: Priority.high,
        );

        try {
          logger.wtf("MESSAGE LISTENED SUCCESSFULLY");

          /// GET INPUT MAP FROM NOTIFICATION
          /// (FOR CHECK NOTIFICATIONS AND NAVIGATE TO A PARTICULAR SCREEN) ::

          /*String jsonMessage = jsonEncode(message.data);

          Map<String, dynamic> _inputMap = {};

          Map<String, dynamic> internalMap = jsonDecode(jsonMessage);
          if (internalMap.isNotEmpty) {
            if (internalMap['input'] != null) {
              _inputMap = jsonDecode(internalMap['input']);
            }
          }*/

          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: andNTFDetails,
              ));
        } on Exception catch (e) {
          logger.e("NTF ERROR IS : $e");
        }
      }
    });

    /// WHEN TAP ON NOTIFICATION DURING APP IS RUNNING ::

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.wtf("MESSAGE ON OPENED APP");

      _tapNTFNavigation();
    });

    /// TAP ON NOTIFICATION WHEN APP RUNNING IN BACKGROUND ::

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// NAVIGATE FOR PARTICULAR SCREEN ON NOTIFICATION (WHEN APP IS KILLED) ::

    await FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) async {
        if (message != null) {
          _tapNTFNavigation();
        }
      },
    );
  }

  static void clearNotification({required int ntfId}) {
    logger.i(ntfId);

    flutterLocalNotificationsPlugin.cancel(ntfId);

    logger.i("NOTIFICATION REMOVED SUCCESSFULLY FROM NOTIFICATION 12");
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    logger.wtf("MESSAGE ON BACKGROUND");
  }

  static Future<void> _initializeLocalNtf() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("app_icon");
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  static Future onSelectNotification(String? payload) async {}

  static void _tapNTFNavigation() {}
}
