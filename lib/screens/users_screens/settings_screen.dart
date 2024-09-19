import 'package:flutter/material.dart';
import 'package:tripbudgeter/screens/users_screens/user_edit_screen.dart';
import 'package:tripbudgeter/screens/users_screens/user_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../login_screen.dart';
import 'help.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 4, 120, 228),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SettingsTile(icon: Icons.person, title: 'Profile', page: UserProfilePage()),
                SettingsTile(icon: Icons.tune, title: 'General', page: GeneralSettingsPage()),
                Divider(),
                SettingsTile(icon: Icons.privacy_tip, title: 'Privacy', page: PrivacySettingsPage()),
                SettingsTile(icon: Icons.notifications, title: 'Notifications', page: NotificationSettingsPage()),
                SettingsTile(icon: Icons.dark_mode, title: 'Appearance', page: AppearanceSettingsPage()),
                Divider(),
                SettingsTile(icon: Icons.help, title: 'Help', page: HelpPage()),
                SettingsTile(icon: Icons.logout, title: 'Sign Out', page: SignOutPage()),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget page; // Changed to Widget

  SettingsTile({required this.icon, required this.title, required this.page});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Navigate to the provided page
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}

// Similarly, define the rest of the pages used in SettingsTile:
class GeneralSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('General Settings')),
      body: Center(child: Text('General Settings Page')),
    );
  }
}

class PrivacySettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Settings')),
      body: Center(child: Text('Privacy Settings Page')),
    );
  }
}

class NotificationSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notification Settings')),
      body: Center(child: Text('Notification Settings Page')),
    );
  }
}

class AppearanceSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appearance Settings')),
      body: Center(child: Text('Appearance Settings Page')),
    );
  }
}

class CustomizePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customize')),
      body: Center(child: Text('Customize Page')),
    );
  }
}

class SignOutPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();

    // After signing out, navigate to the login screen (or the appropriate screen)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()), // Replace LoginScreen with your actual login page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Out')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _signOut(context);
          },
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}
