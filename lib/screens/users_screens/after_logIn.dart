import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripbudgeter/screens/users_screens/notification_screen.dart';
import 'package:tripbudgeter/screens/users_screens/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripbudgeter/screens/users_screens/trip_screen.dart';

import '../header_widget.dart';


class AfterLogin extends StatefulWidget {
  const AfterLogin({super.key});

  @override
  State<AfterLogin> createState() => _AfterLoginState();
}

class _AfterLoginState extends State<AfterLogin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;
  bool isLoading = true;
  int _currentIndex = 0; // Track the current page index
  final PageController _pageController = PageController(); // PageController

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      var userId = _auth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavTapped(int index) {
    _pageController.jumpToPage(index); // Navigate to the selected page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        automaticallyImplyLeading: false,
        title: isLoading
            ? const CircularProgressIndicator() // Show a loading indicator
            : userData == null
                ? const Text('No user data available')
                : HeaderWidget(
                    userName: 'Hi, ${userData!['username']}',
                    imagePath: userData!['profileImage'] == null ||
                            userData!['profileImage'].isEmpty
                        ? 'assets/default_profile.png' // Default image path
                        : userData!['profileImage'],
                    onMoreOptions: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingScreen()),
                      );
                    },
                    onNotification:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationScreen()),
                      );
                    } ,
                  ),
        backgroundColor: const Color.fromARGB(255, 4, 120, 228),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          // Your home page content
          const Center(child: Text('Add trips to start budgeting')),
          // The add trip page content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Add New Trips',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TripsScreen()));
                        },
                        child: const Text(
                          'Active trips >',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Search Bar
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Search Trips',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Sort and Filter Options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Sort Dropdown
                      DropdownButton<String>(
                        hint: const Text('Sort by'),
                        items: <String>['Date', 'Destination', 'Budget']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          // Handle sort selection
                        },
                      ),
                      // Filter Dropdown
                      DropdownButton<String>(
                        hint: const Text('Filter'),
                        items: <String>['All', 'Upcoming', 'Past']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          // Handle filter selection
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Trips',
          ),
        ],
      ),
    );
  }
}
