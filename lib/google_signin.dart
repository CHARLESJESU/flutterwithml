import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'google_signin_success.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: size.width < 800 ? double.infinity : 600,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Join Us',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Create an account to continue',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 40),
              const SignUp(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late Widget _signUpWidget;

  @override
  void initState() {
    _signUpWidget = _googleSignUpButton();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _signUpWidget;

  Widget _googleSignUpButton() {
    return ElevatedButton.icon(
      onPressed: _handleSignUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        shadowColor: Colors.grey[600],
        minimumSize: const Size(250, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 6,
      ),
      icon: Image.asset(
        'images/google-logo.png',
        height: 24,
        width: 24,
      ),
      label: Text(
        'Sign up with Google',
        style: GoogleFonts.poppins(fontSize: 16),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    setState(() {
      _signUpWidget = const CircularProgressIndicator();
    });

    try {
      final googleUser = await GoogleSignIn(
        scopes: [
          'email',
          'profile',
          'https://www.googleapis.com/auth/user.birthday.read',
          'https://www.googleapis.com/auth/user.phonenumbers.read',
        ],
      ).signIn();

      if (googleUser == null) {
        setState(() {
          _signUpWidget = _googleSignUpButton();
        });
        return;
      }

      final googleAuth = await googleUser.authentication;

      // 🔥 Fetch extra data from Google People API
      final peopleApiUrl = Uri.parse(
        'https://people.googleapis.com/v1/people/me?personFields=names,emailAddresses,birthdays,phoneNumbers',
      );

      final response = await http.get(
        peopleApiUrl,
        headers: {
          'Authorization': 'Bearer ${googleAuth.accessToken}',
        },
      );

      String? phoneNumber;
      String? birthDate;

      if (response.statusCode == 200) {
        final profileData = json.decode(response.body);

        if (profileData['phoneNumbers'] != null) {
          phoneNumber = profileData['phoneNumbers'][0]['value'];
        }

        if (profileData['birthdays'] != null) {
          final bday = profileData['birthdays'][0]['date'];
          birthDate = "${bday['day']}-${bday['month']}-${bday['year']}";
        }
      } else {
        print("Failed to fetch from People API: ${response.body}");
      }

      // ✅ Firebase sign-in
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signed up as ${userCredential.user!.displayName}')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SigninSuccess(
              name: userCredential.user!.displayName ?? '',
              email: userCredential.user!.email ?? '',
              photoUrl: userCredential.user!.photoURL ?? '',
              phoneNumber: phoneNumber ?? 'Not available',
              birthDate: birthDate ?? 'Not available',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-up failed: $e')),
      );
    }

    setState(() {
      _signUpWidget = _googleSignUpButton();
    });
  }
}
