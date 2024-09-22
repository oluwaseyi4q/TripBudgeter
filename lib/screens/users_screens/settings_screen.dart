import 'package:flutter/material.dart';
import 'package:tripbudgeter/screens/users_screens/user_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../login_screen.dart';
import 'help.dart';
import 'notification_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 4, 120, 228),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                const SettingsTile(
                    icon: Icons.person,
                    title: 'Profile',
                    page: UserProfilePage()),
                const SettingsTile(
                    icon: Icons.tune,
                    title: 'General',
                    page: GeneralSettingsPage()),
                const Divider(),
                const SettingsTile(
                    icon: Icons.privacy_tip,
                    title: 'Privacy',
                    page: PrivacySettingsPage()),
                const SettingsTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    page: NotificationScreen()),
                const SettingsTile(
                    icon: Icons.dark_mode,
                    title: 'Appearance',
                    page: AppearanceSettingsPage()),
                const Divider(),
                SettingsTile(icon: Icons.help, title: 'Help', page: HelpPage()),
                SettingsTile(
                    icon: Icons.logout, title: 'Sign Out', page: SignOutPage()),
              ],
            ),
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

  const SettingsTile(
      {super.key, required this.icon, required this.title, required this.page});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Navigate to the provided page
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({super.key});

  @override
  _GeneralSettingsPageState createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  bool _isMetric = true;
  String _selectedLanguage = 'English';
  String _selectedTimeZone = 'UTC';

  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];
  final List<String> _timeZones = ['UTC', 'GMT', 'EST', 'PST'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('General Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_selectedLanguage),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              items: _languages
                  .map((lang) => DropdownMenuItem<String>(
                value: lang,
                child: Text(lang),
              ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Time Zone'),
            subtitle: Text(_selectedTimeZone),
            trailing: DropdownButton<String>(
              value: _selectedTimeZone,
              items: _timeZones
                  .map((zone) => DropdownMenuItem<String>(
                value: zone,
                child: Text(zone),
              ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTimeZone = newValue!;
                });
              },
            ),
          ),
          SwitchListTile(
            title: const Text('Use Metric System'),
            value: _isMetric,
            onChanged: (bool value) {
              setState(() {
                _isMetric = value;
              });
            },
          ),
        ],
      ),
    );
  }
}


class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _shareLocation = true;
  bool _shareUsageData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Share Location'),
            subtitle: const Text('Allow the app to access your location'),
            value: _shareLocation,
            onChanged: (bool value) {
              setState(() {
                _shareLocation = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Share Usage Data'),
            subtitle: const Text('Allow sharing anonymous usage statistics'),
            value: _shareUsageData,
            onChanged: (bool value) {
              setState(() {
                _shareUsageData = value;
              });
            },
          ),
          ListTile(
            title: const Text('Delete Account'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteAccountDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account? This action is irreversible.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Code to delete the account goes here
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}


class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  _AppearanceSettingsPageState createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  bool _darkMode = false;
  double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (bool value) {
              setState(() {
                _darkMode = value;
                // Implement logic to change theme based on the mode
              });
            },
          ),
          ListTile(
            title: const Text('Font Size'),
            subtitle: Slider(
              value: _fontSize,
              min: 12.0,
              max: 24.0,
              divisions: 6,
              label: _fontSize.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _fontSize = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}


class SignOutPage extends StatelessWidget {
  SignOutPage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();

    // After signing out, navigate to the login screen (or the appropriate screen)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) =>
              const LoginScreen()), // Replace LoginScreen with your actual login page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Out')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _signOut(context);
          },
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
