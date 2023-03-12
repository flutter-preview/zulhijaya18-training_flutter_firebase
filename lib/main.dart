import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_flutter_firebase/src/model/push_notification.dart';
import 'package:training_flutter_firebase/src/service/navigation_service.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings notifSettings = await messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  if (notifSettings.authorizationStatus == AuthorizationStatus.authorized) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );

      FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

      // app_icon needs to be a added as a drawable
      // resource to the Android head project.
      var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
      var ios = const IOSInitializationSettings();

      // initialise settings for both Android and iOS device.
      var settings = InitializationSettings(android: android, iOS: ios);
      flip.initialize(
        settings,
        onSelectNotification: (payload) {
          NavigationService().update('about');
        },
      );
      _showNotificationWithDefaultSound(flip, notification);
    });
  }

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

Future _showNotificationWithDefaultSound(
    FlutterLocalNotificationsPlugin flip, PushNotification message) async {
  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
  );
  var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
  await flip.show(
    0,
    message.title,
    message.body,
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );
}
