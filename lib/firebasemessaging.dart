// // firebasemessaging.dart
//
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class NotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> init() async {
//     await _fcm.requestPermission();
//
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initSettings =
//     InitializationSettings(android: androidSettings);
//
//     await _flutterLocalNotificationsPlugin.initialize(initSettings);
//   }
//
//   Future<void> showLocalNotification({required String title, required String body}) async {
//     const AndroidNotificationDetails androidDetails =
//     AndroidNotificationDetails('channel_id', 'channel_name',
//         importance: Importance.max, priority: Priority.high);
//
//     const NotificationDetails platformDetails =
//     NotificationDetails(android: androidDetails);
//
//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformDetails,
//     );
//   }
// }
