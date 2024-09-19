import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/authcontroller/auth_controller.dart';
import '../auth/authcontroller/register_provider/register_provider.dart';
import 'users_screens/contact_us.dart';
import 'login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  var previewPassword = false;
  // Controllers
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController usernameController;
  late final TextEditingController fullnameController;

  late AuthController _controller;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = AuthController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    fullnameController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    fullnameController.dispose();

    super.dispose();
  }

  //Register function
  void register() {
    // validateForm();
    ref
        .watch(registerNotifierProvider.notifier)
        .emailChange(emailController.text);

    ref
        .watch(registerNotifierProvider.notifier)
        .passwordChange(passwordController.text);
    ref
        .watch(registerNotifierProvider.notifier)
        .usernameChange(usernameController.text);
    ref
        .watch(registerNotifierProvider.notifier)
        .fullnameChange(fullnameController.text);

    _controller.handleRegisterWithEmailAndPassword(ref);
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
                    Container(
                      margin: const EdgeInsets.only(
                        top: 50,
                      ),
                      height: 200,
                      width: 200,
                      child: Image.asset(
                        "assets/image2.jpg",
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: const Text(
                        'TripBudgeter',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
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
                    Form(
                      child: Column(
                        children: [
                          // Fullname field
                          TextFormField(
                            validator: (value) {
                              if (value != null) {
                                if(value.length < 6){
                                  return "Fullname invalid";
                                }
                              } else {
                                return "Fullname must not be null";
                              }
                              return null;
                            },
                            controller: fullnameController,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 219, 219, 219),
                              hintText: 'Enter FullName',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //Username Field
                          TextFormField(
                            controller: usernameController,
                            validator: (value) {
                              if (value != null) {
                                if (value.length < 3) {
                                  return "Username must be more than 3";
                                }
                              } else {
                                return "Username Cannot be empty";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 219, 219, 219),
                              hintText: 'Enter UserName',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Password field
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value != null) {
                                if(value.contains("@")){
                                  return "Email must contain @";
                                }
                              } else {
                                return "Email cannot be empty";
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value != null) {
                                if (value.length < 6) {
                                  return "Password must be greater than six characters";
                                }
                              } else {
                                return "Password must not be empty";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 219, 219, 219),
                              hintText: 'Enter Password',
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(_obscureText
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.visibility_off),
                              ),
                            ),
                            obscureText: _obscureText,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 4, 120, 228),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          textStyle: GoogleFonts.poppins(fontSize: 18),
                        ),
                        onPressed: () {
                          register();
                        },
                        child: const Text("Create Account"),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Log In',
                            style:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 90,),
                        Image.asset(
                          'assets/image5.png',
                          height: 35,
                          width: 35,
                        ),
                        const SizedBox(width: 8), // Add some spacing
                        GestureDetector(
                          onTap: () {
                            // Navigate to Contact Us page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ContactUs()),
                            );
                          },
                          child: const Text(
                            'Contact Us',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16),
                          ),
                        ),
                        const Expanded(
                            child:SizedBox()
                        ),
                      ],
                    ),
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
