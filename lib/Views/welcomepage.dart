import 'package:flutter/material.dart';
import 'package:maize_doc/Views/aboutpage.dart';
import 'package:maize_doc/Views/disease_detection_page.dart';
import 'package:maize_doc/Views/farmingadvice.dart';
import 'package:maize_doc/Views/history.dart';
import 'package:maize_doc/Views/login.dart';
import 'package:maize_doc/Views/profile.dart';

class WelcomePage extends StatelessWidget {
  final String username;

  const WelcomePage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Maize Doc Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        backgroundColor: Colors.white54,
        foregroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, $username",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Welcome to your dashboard!",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(username: username)), // Pass username directly
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DiseaseHistoryPage(username: username,)), // Pass username directly
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                // Assuming there's an AboutPage class
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage(username: username,)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 15.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0DB14A),
                Color(0xFF157C1F),
                Color(0xFF194A12),
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Row(
                  children: [
                    Text(
                      "Welcome,\n$username!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 60.0),
                    Image.asset(
                      'image/maizedoc.png',
                      height: 90.0,
                      width: 90.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: [
                      _buildDashboardIcon(
                        context,
                        'Disease Detection',
                        'image/microscope-icon.png',
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetectionScreen(username: username)), // Pass username
                          );
                        },
                      ),
                      _buildDashboardIcon(
                        context,
                        'Farming Advice',
                        'image/doctor.png',
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FarmingAdvicePage(username: username)), // Pass username
                          );
                        },
                      ),
                      _buildDashboardIcon(
                        context,
                        'Tutorial',
                        'image/tutorial.png',
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetectionScreen(username: username)), // Pass username
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardIcon(BuildContext context, String label, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 60,
              width: 60,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}