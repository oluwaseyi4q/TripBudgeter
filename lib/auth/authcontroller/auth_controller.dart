
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tripbudgeter/auth/authcontroller/register_provider/register_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../main.dart';
import '../../screens/admin_screens/admin_screen.dart';
import '../../screens/users_screens/home_screen.dart';
import '../../screens/login_screen.dart';

class AuthController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  // LOGIN IMPLEMENTATION
  void handleLoginWithEmailAndPassword(WidgetRef ref) async {
    var state = ref.read(registerNotifierProvider);
    try {
      var credential = await _auth.signInWithEmailAndPassword(
          email: state.email, password: state.password);

      if (credential.user == null) return;

      // Retrieving user details from the database(firebase)
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .get();
      // Get Role
      String role = userDoc.get('role');

      ScaffoldMessenger.of(navKey.currentContext!).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          width: 300,
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
          content: Text('Login successful'),
        ),
      );

      // Navigate based on user role
      if (role == 'admin') {
        navKey.currentState!.pushReplacement(
            MaterialPageRoute(builder: (_) => AdminDashboard()));
      } else if (role == 'user') {
        navKey.currentState!.pushReplacement(
            MaterialPageRoute(builder: (_) => HomePage()));
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(navKey.currentContext!).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          width: 300,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1),
          content: Text(error.message ?? 'An error occurred'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(navKey.currentContext!).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          width: 300,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
          content: Text('An unexpected error occurred'),
        ),
      );
    }
  }

  // REGISTER IMPLEMENTATION
  Future<void> handleRegisterWithEmailAndPassword(WidgetRef ref) async {
    var state = ref.read(registerNotifierProvider);


    try {
      final email = ref.watch(registerNotifierProvider).email;
      final password = ref.watch(registerNotifierProvider).password;
      final username = ref.watch(registerNotifierProvider).username;
      final fullname = ref.watch(registerNotifierProvider).fullname;

      // Create a new user with Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user data to Firestore, including the role
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'Username:': username,
        'fullname':fullname,
        'email': email,
        'address': '',
        'age': '',
        'gender': 'Male',
        'preferredCurrency': 'USD',
        'travelPreferences': '',
        'profileImage': '',
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _auth.currentUser!.sendEmailVerification();

      ScaffoldMessenger.of(navKey.currentContext!).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          width: 300,
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
          content: Text('A verification message has been sent'),
        ),
      );

      navKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()));
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(navKey.currentContext!).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          width: 300,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1),
          content: Text(error.message ?? 'An error occurred'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(navKey.currentContext!).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          width: 300,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
          content: Text('An unexpected error occurred'),
        ),
      );
    }
  }

  handleGoogleSignIn(WidgetRef ref) async {
    final GoogleSignInAccount? guser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await guser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
