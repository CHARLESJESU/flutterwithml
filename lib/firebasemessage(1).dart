// // firebase_message_screen.dart
//
// import 'package:flutter/material.dart';
// import 'firebasemessaging.dart'; // where NotificationService is defined
//
// class FirebaseMessageScreen extends StatelessWidget {
//   final NotificationService _notificationService = NotificationService();
//
//   FirebaseMessageScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Firebase Message')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             _notificationService.showLocalNotification(
//               title: "Test Notification",
//               body: "This is a Firebase message!",
//             );
//           },
//           child: const Text("Send Message"),
//         ),
//       ),
//     );
//   }
// }
