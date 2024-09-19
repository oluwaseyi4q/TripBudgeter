import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us', style: TextStyle(color: Colors.white,),),
        backgroundColor:  const Color.fromARGB(255, 4, 120, 228),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'We would love to hear from you!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField('Name'),
              const SizedBox(height: 16),
              _buildTextField('Email', keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField('Message', maxLines: 4),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  const Color.fromARGB(255, 4, 120, 228), // Button color
                    padding: const EdgeInsets.symmetric(vertical: 16.0), // Button padding
                    textStyle: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Message sent!')),
                    );
                  },
                  child: const Text('Send Message', style: TextStyle(color:Colors.white ,),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {TextInputType? keyboardType, int maxLines = 1}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 245, 245, 245), // Light background color for the text field
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 16), // Text style inside the field
    );
  }
}
