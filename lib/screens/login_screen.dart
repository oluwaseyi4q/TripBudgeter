import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripbudgeter/screens/sign_up.dart';
import 'package:tripbudgeter/screens/users_screens/after_logIn.dart';
import 'package:tripbudgeter/screens/users_screens/forgetpassword.dart';
import 'package:tripbudgeter/screens/users_screens/home_screen.dart';

import '../auth/authcontroller/auth_controller.dart';
import '../auth/authcontroller/login_provider/login_provider.dart';
import 'admin_screens/admin_screen.dart';
import 'users_screens/contact_us.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  var previewPassword = false;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  late AuthController _controller;

  String selectedRole = 'User';

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = AuthController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  // Login Function/Method
  void login() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      ref.watch(LoginNotifierProvider.notifier).emailChange(emailController.text);
      ref.watch(LoginNotifierProvider.notifier).passwordChange(passwordController.text);

      try {
        // Attempt to sign in with email and password
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Get User data from firebase
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        if (userDoc.exists) {
          var role = userDoc['role'].toString().trim().toLowerCase();
          var selectedRoleTrimmed = selectedRole.trim().toLowerCase();

          if (role == selectedRoleTrimmed) {
            if (role == 'admin') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminDashboard()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AfterLogin()),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Incorrect role selection. Please choose $role.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found.')),
          );
        }

      } catch (e) {
        // Handle errors here
        String errorMessage = 'An unknown error occurred';

        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'user-not-found':
              errorMessage = 'No user found with this email.';
              break;
            case 'wrong-password':
              errorMessage = 'Incorrect password.';
              break;
            case 'invalid-email':
              errorMessage = 'Invalid email address.';
              break;
            case 'network-request-failed':
              errorMessage = 'Network error. Please try again.';
              break;
            case 'too-many-requests':
              errorMessage = 'Too many requests. Please try again later.';
              break;
            default:
              errorMessage = e.message!;
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  void validateForm() {
    var isValid = formKey.currentState!.validate();
    if (isValid) return formKey.currentState!.save();
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/image3.jpg",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Image and Logo
                    Container(
                      margin: const EdgeInsets.only(top: 100),
                      height: 200,
                      width: 200,
                      child: Image.asset("assets/image2.jpg"),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'TripBudgeter',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'The Smart Way to Travel',
                      style: GoogleFonts.dancingScript(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Login Form
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // Email field
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || !value.contains("@")) {
                                return "Invalid email address";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 219, 219, 219),
                              hintText: 'Enter email',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Password field
                          TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color.fromARGB(255, 219, 219, 219),
                              hintText: 'Enter Password',
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(
                                  _obscureText
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            obscureText: _obscureText,
                          ),
                          const SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                                );
                              },
                              child: const Text('Forget Password?',style:TextStyle(color: Colors.blue)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Role Selection Radio Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: const Text('User'),
                                  leading: Radio<String>(
                                    value: 'User',
                                    activeColor: Colors.blue,
                                    groupValue: selectedRole,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedRole = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: const Text('Admin'),
                                  leading: Radio<String>(
                                    value: 'Admin',
                                    activeColor: Colors.blue,
                                    groupValue: selectedRole,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedRole = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                const Color.fromARGB(255, 4, 120, 228),
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                textStyle: GoogleFonts.poppins(fontSize: 18),
                              ),
                              onPressed: login,
                              child: const Text("Log in"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t Have An Account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text('Create One',style:TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
