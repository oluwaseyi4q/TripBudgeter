import 'package:flutter/material.dart';
import 'package:tripbudgeter/screens/users_screens/user_profile_screen.dart';

class HeaderWidget extends StatelessWidget {
  final String userName;
  final String imagePath;
  final VoidCallback onMoreOptions;
  final VoidCallback onNotification;

  const HeaderWidget({
    super.key,
    required this.userName,
    required this.imagePath,
    required this.onMoreOptions,
    required this.onNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            imagePath,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserProfilePage()),
            );
          },
          child: Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Colors.white,
            size: 30,
          ),
          onPressed: onNotification ,
        ),
        const SizedBox(
          width: 10,
        ),
        IconButton(
          icon: const Icon(
            Icons.menu_rounded,
            color: Colors.white,
            size: 30,
          ),
          onPressed: onMoreOptions,
        ),
      ],
    );
  }
}
