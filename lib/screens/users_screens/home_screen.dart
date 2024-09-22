import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripbudgeter/screens/login_screen.dart';
import '../card_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        automaticallyImplyLeading:
            false, // This removes the default back button
        title: HeaderWidget(
          userName: 'Login/SignUp',
          imagePath: 'assets/image8.png',
          onMoreOptions: () {
            // Add action for the button here
          },
          onNotification: (){
            
          },
        ),
        backgroundColor: const Color.fromARGB(255, 4, 120, 228),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text('Active Trips',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 2),
            Text(
              'Explore Different Places With Managed Expenses',
              style: GoogleFonts.dancingScript(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            // Wrap for boxes
            Wrap(
              spacing: 15, // Space between boxes
              runSpacing: 20, // Space between rows
              children: [
                ImageTextCard(
                  imagePath: 'assets/image7.jpg',
                  text: 'New York City, USA',
                  currency: 'USD',
                  exchangeRate: '1.0',
                  budgetedExpenses: '\$1500',
                  onViewMore: () {},
                ),
                ImageTextCard(
                    imagePath: 'assets/image6.jpg',
                    text: 'The Swiss Alps',
                    currency: 'CHF',
                    exchangeRate: '0.84555',
                    budgetedExpenses: 'CHF3000',
                    onViewMore: () {},)
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Expense Categories',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryBox(Icons.hotel, 'Accommo'),
                _buildCategoryBox(Icons.fastfood, 'Food'),
                _buildCategoryBox(Icons.local_activity, 'Activities'),
                _buildCategoryBox(Icons.local_taxi, 'Transport'),
                _buildCategoryBox(Icons.shopping_cart, 'Shopping'),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add trip',
          ),
        ],
      ),
    );
  }
}

Widget _buildCategoryBox(IconData icon, String label) {
  return Column(
    children: [
      Container(
        width: 60, // Fixed width for each box
        height: 60, // Fixed height for each box
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255), // Background color
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(179, 216, 213, 213),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: const Color.fromARGB(255, 0, 0, 0),
            size: 30, // Adjusted size for better visibility
          ),
        ),
      ),
      const SizedBox(height: 5), // Space between the box and text
      Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 12,
        ),
      ),
    ],
  );
}




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
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: onMoreOptions,
        ),
      ],
    );
  }
}

