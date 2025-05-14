import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maize_doc/Views/database_helper.dart';
import 'package:maize_doc/Views/welcomepage.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String? _email;
  String? _password;
  File? _profileImage; // Variable to hold the profile image

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final users = await _dbHelper.getUsers(); // Fetch all users
    final user = users.firstWhere(
          (user) => user['username'] == widget.username,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      setState(() {
        _email = user['email'];
        _password = user['password'];
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      // Optionally save the image path to the database or locally
      await _saveProfileImagePath(pickedFile.path);
    }
  }

  Future<void> _saveProfileImagePath(String path) async {
    // You can implement saving the image path to the database if needed
    // For example: await _dbHelper.saveProfileImagePath(widget.username, path);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage(username: widget.username)),
        );
        return false; // Prevent the default back action
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "User Profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF0DB14A),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Username:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(widget.username, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              const Text(
                "Email:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(_email ?? 'Loading...', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}