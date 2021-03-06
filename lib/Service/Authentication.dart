import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../Screens/HomeScreen.dart';

class Authentication {
  static Future<User> signInWithGoogle(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          Scaffold.of(context).showSnackBar(
            Authentication.customSnackBar(
              'The account already exists with a different credential',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          Scaffold.of(context).showSnackBar(
            Authentication.customSnackBar(
              'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        Scaffold.of(context).showSnackBar(
          Authentication.customSnackBar(
            'Error occurred using Google Sign In. Try again.',
          ),
        );
      }
    }
    return user;
  }

  static SnackBar customSnackBar(String content) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase(
    BuildContext context,
  ) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(user),
        ),
      );
    }

    return firebaseApp;
  }
}
