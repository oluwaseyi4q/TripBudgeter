
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripbudgeter/screens/login_screen.dart';
import 'package:tripbudgeter/screens/onboarding_screen.dart';
import 'package:tripbudgeter/screens/sign_up.dart';
import 'package:tripbudgeter/screens/users_screens/trip_screen.dart';
import 'package:tripbudgeter/screens/users_screens/user_edit_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: App()));
}

final navKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(),
      navigatorKey: navKey,
    );
  }
}
