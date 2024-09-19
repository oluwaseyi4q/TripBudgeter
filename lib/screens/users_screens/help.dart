import 'package:flutter/material.dart';
import 'package:tripbudgeter/screens/admin_screens/about_us.dart';
import 'package:tripbudgeter/screens/users_screens/contact_us.dart';
class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
        centerTitle: true,
        backgroundColor:  const Color.fromARGB(255, 4, 120, 228),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'How can we help you?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          HelpTile(
            icon: Icons.question_answer,
            title: 'FAQ',
            description: 'Find answers to frequently asked questions.',
            page: FAQPage(),
          ),
          HelpTile(
            icon: Icons.contact_mail,
            title: 'Contact Support',
            description: 'Reach out to our support team for help.',
            page: ContactUs(),
          ),
          HelpTile(
            icon: Icons.lock,
            title: 'Privacy Policy',
            description: 'Learn more about how we protect your privacy.',
            page: PrivacyPolicyPage(),
          ),
          HelpTile(
            icon: Icons.info,
            title: 'About Us',
            description: 'Learn more about TripBudgeter and our mission.',
            page: AboutUs(),
          ),
          HelpTile(
            icon: Icons.feedback,
            title: 'Send Feedback',
            description: 'We’d love to hear your thoughts!',
            page: FeedbackPage(),
          ),
          SizedBox(height: 30),
          Center(
            child: Text(
              'Need more assistance?',
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {

              },
              icon: Icon(Icons.phone),
              label: Text('Contact Support'),
            ),
          ),
        ],
      ),
    );
  }
}

class HelpTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget page; // Changed to Widget

  HelpTile({required this.icon, required this.title, required this.description, required this.page});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(description),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}


// PrivacyPolicy
class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Privacy Policy",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Last updated: September 2024",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              "1. Introduction",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "This privacy policy explains how our app collects, uses, and protects your personal information. We value your privacy and are committed to safeguarding your personal data.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "2. Information We Collect",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "We may collect personal data such as your name, email address, location, travel preferences, and other details necessary to provide you with personalized services.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "3. How We Use Your Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Your information is used to provide, improve, and personalize our services, as well as to communicate with you about updates, offers, and notifications related to the app.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "4. Sharing Your Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "We do not share your personal information with third parties, except when required by law or necessary to provide services (such as payment processing).",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "5. Data Security",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "We take appropriate security measures to protect your data from unauthorized access, alteration, disclosure, or destruction. However, no method of data transmission over the internet is 100% secure.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "6. Your Rights",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "You have the right to access, modify, or delete your personal information stored within our app. If you have any concerns or requests, please contact us.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "7. Changes to This Policy",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "We may update this privacy policy from time to time. Any changes will be posted on this page, and we encourage you to review it regularly.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "8. Contact Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "If you have any questions or concerns about this privacy policy, please contact us at support@tripbudgeter.com.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

//Faq


class FAQPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'What is TripBudgeter?',
      'answer': 'TripBudgeter helps you plan and manage your travel budgets efficiently.'
    },
    {
      'question': 'How do I create a budget for my trip?',
      'answer': 'Navigate to the "Create Budget" section, enter your trip details, and add your planned expenses.'
    },
    {
      'question': 'Can I change my currency preferences?',
      'answer': 'Yes, you can change your preferred currency in the settings under "Currency Preferences".'
    },
    {
      'question': 'How do I edit my profile?',
      'answer': 'Go to the "Account" section in the settings, and tap the "Edit" button to update your profile information.'
    },
    {
      'question': 'How do I contact support?',
      'answer': 'You can contact support by navigating to the Help section and clicking on "Contact Support".'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return FAQTile(
            question: faq['question']!,
            answer: faq['answer']!,
          );
        },
      ),
    );
  }
}

class FAQTile extends StatelessWidget {
  final String question;
  final String answer;

  FAQTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question, style: TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(answer),
        ),
      ],
    );
  }
}


//FeedBack


class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  String _feedback = '';

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Here you can handle the feedback submission, e.g., sending it to a server or storing it locally
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted!')),
      );
      // Clear the form
      setState(() {
        _feedback = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'We value your feedback! Please share your thoughts with us.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Your Feedback',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                onSaved: (value) {
                  _feedback = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitFeedback,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
