import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninSuccess extends StatelessWidget {
  final String name;
  final String email;
  final String photoUrl;
  final String phoneNumber;
  final String birthDate;

  const SigninSuccess({
    super.key,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.phoneNumber,
    required this.birthDate,
  });


  @override
  Widget build(BuildContext context) {
    print("Photo URL: ${photoUrl}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await GoogleSignIn().signOut(); // Sign out from Google
              await FirebaseAuth.instance.signOut(); // Sign out from Firebase
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
              Navigator.pop(context); // Go back to login screen
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(photoUrl),
            ),
            const SizedBox(height: 16),
            Text("Name: $name", style: const TextStyle(fontSize: 20)),


          const SizedBox(height: 8),
            Text("Email: $email", style: const TextStyle(fontSize: 18)),
            Text("Phone: $phoneNumber", style: const TextStyle(fontSize: 18)),
            Text("DOB: $birthDate", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );

  }
}
