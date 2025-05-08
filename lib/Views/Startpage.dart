import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:maize_doc/Views/homepage.dart';
import 'package:maize_doc/Views/onboarding.dart';
import 'package:maize_doc/Views/settings.dart';
import 'package:maize_doc/Views/profile.dart';
import 'package:maize_doc/Views/aboutpage.dart';
import 'package:maize_doc/Views/recommendations.dart';

class Startpage extends StatefulWidget {
  const Startpage({super.key});

  @override
  State<Startpage> createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  final List<String> images = [
    'assets/slide1.png',
    'assets/slide2.png',
    'assets/slide3.png', // Add more images as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to Maize Doc"),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Custom Drawer Header with Blurred Background Image
            Container(
              color: Colors.green,
              height: 150, // Set height for the header
              child: Stack(
                children: [
                  // Background image
                  Image.asset(
                    'image/maizedoc.png', // Background image
                    fit: BoxFit.cover,
                    height: 150,

                  ),
                  // Blurred effect
                  /*BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black54, // Semi-transparent background
                    ),
                  ),*/
                  // Header text
                  // Header text aligned to the right
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.0), // Add some padding to the right
                      child: Text(
                        'Maize Doc Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.black),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Onboarding()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.black),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.black),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.black),
              title: Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.recommend, color: Colors.black),
              title: Text('Recommendations'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image slider using PageView
              Container(
                height: 200, // Set the height for the image slider
                child: PageView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      images[index],
                      fit: BoxFit.cover, // Adjust the fit as needed
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Welcome to Maize Doc!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "Your go-to app for maize disease detection and recommendations.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the homepage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text("Get Started"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}