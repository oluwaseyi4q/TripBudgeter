import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';

class ImageTextCard extends StatelessWidget {
  final String imagePath;
  final String text;
  final String currency;
  final String exchangeRate;
  final String budgetedExpenses;
  final VoidCallback onViewMore; // Callback for the button

  const ImageTextCard({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.currency,
    required this.exchangeRate,
    required this.budgetedExpenses,
    required this.onViewMore, // Initialize the callback
  }) : super(key: key);

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          title: Text(text, style: const TextStyle(fontWeight: FontWeight.bold),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Icon(Icons.close, color: Colors.red,),
            ),
          ],
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children:[
              Text('Discover $text, the vibrant city that never sleeps, where iconic landmarks, diverse neighborhoods, and world-class culture await.', style: const TextStyle(fontSize: 20,),),
              const SizedBox(height: 30,),
              Text('Currency: $currency',style: const TextStyle(fontSize: 20,),),
              Text('Exchange Rate: $exchangeRate',style: const TextStyle(fontSize: 20,),),
              Text("Budgeted Expences : $budgetedExpenses",style: const TextStyle(fontSize: 20,),),
              const SizedBox(height: 10,),
              TextButton(onPressed: (){
                Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
              }, child: const Text("Sign In To Enjoy Premium Feature"))
            ],
          ),
          
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 170, // Fixed height
                width: 130, // Fixed width
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath), // Background image
                    fit: BoxFit.cover,
                  ),
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(15)),
                ),
              ),
              Expanded(
                child: Container(
                  height: 170, // Fixed height
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(162, 214, 213, 213),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: GoogleFonts.luckiestGuy(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Currency: $currency',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Exchange Rate: $exchangeRate',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Budgeted Expenses: $budgetedExpenses',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(), // Pushes the button to the bottom
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            onPressed: () =>
                                _showDialog(context), // Show dialog on press
                            icon:
                                const Icon(Icons.keyboard_arrow_right_rounded),
                            iconSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
