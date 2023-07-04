import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_flutter_firebase/src/routing/app_route.dart';

import '../model/push_notification.dart';

class PushNotificationService {
  PushNotificationService(this.ref) {
    _init();
  }

  final Ref ref;
  String? route;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> _init() async {
    NotificationSettings notifSettings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (notifSettings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        final newRoute = message.data['page'];
        ref.read(routesProvider).go(newRoute);
      });
    }
  }

  Future _backgroundHandler(RemoteMessage message) async {
    PushNotification notification = PushNotification(
      title: message.notification?.title,
      body: message.notification?.body,
    );

    FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var settings = InitializationSettings(android: android);
    flip.initialize(settings);
    _showNotificationWithDefaultSound(flip, notification);
  }

  Future _showNotificationWithDefaultSound(
      FlutterLocalNotificationsPlugin flip, PushNotification message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flip.show(
      0,
      message.title,
      message.body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}

final pushNotificationServiceProvider = Provider((ref) {
  return PushNotificationService(ref);
});
