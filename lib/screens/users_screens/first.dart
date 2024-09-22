import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripbudgeter/screens/sign_up.dart';

import '../login_screen.dart';
import 'home_screen.dart';

class First extends StatelessWidget {
  const First({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 4, 120, 228),
            width: double.infinity,
            height: 500,
            child: Image.asset('assets/Travelers.gif'),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to TripBudgeter',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Transform your travel experience! TripBudgeter offers expert tips, budgeting tools, and inspiration. Sign up now and start traveling smarter.',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                            color: const Color.fromARGB(255, 4, 120, 228),
                            child: const Text('SignUp'),
                            onPressed: () {
                               Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreen()),
                            );
                            }),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: CupertinoButton(
                            color: const Color.fromARGB(255, 4, 120, 228),
                            child: const Text('Skip'),
                            onPressed: () {
                               Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                            }),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
