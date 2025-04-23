import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';

import 'google_signin_success.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      MediaQuery.of(context).platformBrightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      body: Center(
        child: MediaQuery.of(context).size.width < 800
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 48, horizontal: 16),
              child: Text(
                'Welcome Back',
                style: GoogleFonts.poppins(fontSize: 48),
              ),
            ),
            const SizedBox(height: 24),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48, horizontal: 16),
              child: SignIn(),
            ),
          ],
        )
            : Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 48, horizontal: 16),
                  child: Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 48),
                  ),
                ),
                Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 48, horizontal: 16),
                  child: SignIn(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late Widget wid;

  @override
  void initState() {
    wid = googleSignInButton(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return wid;
  }

  Widget googleSignInButton({required BuildContext context}) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          wid = const CircularProgressIndicator();
        });
        signInWithGoogle();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 300,
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.login),
              const SizedBox(width: 5.0),
              Text(
                'Sign-in with Google',
                style: GoogleFonts.roboto(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        setState(() {
          wid = googleSignInButton(context: context);
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signed in as ${user.displayName}'),
          ),

        );
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => SigninSuccess(),
            ));
      }

      setState(() {
        wid = googleSignInButton(context: context);
      });
    } catch (e) {
      setState(() {
        wid = googleSignInButton(context: context);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in failed: $e'),
        ),
      );
    }
  }
}
