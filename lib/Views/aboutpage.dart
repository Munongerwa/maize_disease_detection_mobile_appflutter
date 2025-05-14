import 'package:flutter/material.dart';
import 'package:maize_doc/Views/welcomepage.dart'; // Import the WelcomePage

class AboutPage extends StatelessWidget {
  final String username; // Add a username parameter

  const AboutPage({Key? key, required this.username}) : super(key: key); // Constructor updated

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Page", style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white
        ),), // Dynamic title with username
        backgroundColor: Colors.green,
        leading: IconButton( // Custom back button
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage(username: username)), // Pass the username
            );
          },
        ),
      ),
      body: const SingleChildScrollView( // Wrap with SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('image/profilepic.jpg'), // Replace with your image path
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Developer: Batiraishe W Munonengerwa", // Replace with actual developer name
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "GitHub: github.com/johndoe", // Replace with actual GitHub account
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
              SizedBox(height: 10),
              Text(
                "App Version: 1.0.0", // Replace with actual app version
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Built Year: 2025", // Replace with actual built year
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "Purpose of the App:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "This app helps farmers diagnose and manage maize diseases effectively. "
                    "By leveraging image recognition technology, it provides recommendations for treatment, "
                    "aiming to improve crop yield and health.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}