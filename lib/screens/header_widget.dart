import 'package:flutter/material.dart';

import 'login_screen.dart';

class HeaderWidget extends StatelessWidget {
  final String userName;
  final String imagePath;
  final VoidCallback onMoreOptions;

  const HeaderWidget({
    Key? key,
    required this.userName,
    required this.imagePath,
    required this.onMoreOptions,
  }) : super(key: key);

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
              MaterialPageRoute(builder: (context) => const LoginScreen()),
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
            Icons.view_list_sharp,
            color: Colors.white,
          ),
          onPressed: onMoreOptions,
        ),
      ],
    );
  }
}
