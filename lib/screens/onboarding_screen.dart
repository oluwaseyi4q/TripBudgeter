import 'package:flutter/material.dart';
import 'package:tripbudgeter/screens/users_screens/first.dart';
import 'package:tripbudgeter/screens/users_screens/home_screen.dart';

import 'login_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..forward();

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.5).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const First()),
        );
      }
    });
    //
    //
    // Set a delay for the animation to reverse
    Future.delayed(const Duration(seconds: 2), () {
      if (_controller.isCompleted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Center(
            child: Image.asset('assets/image2.jpg', height: 50, width: 50,),
          ),
        ),
      ),
    );
  }
}
