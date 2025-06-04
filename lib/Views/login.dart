import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maize_doc/Views/signup.dart';
import 'package:maize_doc/Components/colors.dart';
import 'package:maize_doc/Views/database_helper.dart';
import 'package:maize_doc/Views/welcomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  List<String> _savedCredentials = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedCredentials = prefs.getStringList('credentials') ?? [];
    });
  }

  void _validateAndLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showDialog("Fill all fields", "Please enter both username and password.");
      return;
    }

    List<Map<String, dynamic>> users = await _dbHelper.getUserByUsernameAndPassword(username, password);

    if (users.isEmpty) {
      _showDialog("Login Failed", "Username or password is incorrect.");
    } else {
      // Save credentials if "Remember Me" is checked
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        _savedCredentials.add('$username:$password');
        prefs.setStringList('credentials', _savedCredentials);
      } else {
        prefs.remove('credentials');
      }

      // Navigate to WelcomePage if login is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage(username: username)),
      );
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showSavedCredentials() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Saved Credentials"),
          content: SizedBox(
            height: 200,
            width: 300,
            child: ListView.builder(
              itemCount: _savedCredentials.length,
              itemBuilder: (context, index) {
                final credential = _savedCredentials[index].split(':');
                return ListTile(
                  title: Text(credential[0]), // Display only the username
                  subtitle: const Text('Password: *****'), // Placeholder for password
                  onTap: () {
                    _usernameController.text = credential[0];
                    _passwordController.text = credential[1]; // Autofill password
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 50.0),
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
                    const Text(
                      "Hello\nLogin !",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 60.0),
                    Image.asset(
                      'image/maizedoc.png',
                      height: 100.0,
                      width: 120.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Username",
                        style: TextStyle(
                          color: Color(0xFF038836),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: _showSavedCredentials, // Show saved credentials on tap
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: "Enter Username",
                            prefixIcon: Icon(Icons.person_outlined),
                          ),
                          onTap: _showSavedCredentials, // Show saved credentials on tap
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Password",
                        style: TextStyle(
                          color: Color(0xFF038836),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: true, // Always obscure the password
                        decoration: const InputDecoration(
                          hintText: "Enter Password",
                          prefixIcon: Icon(Icons.password_outlined),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                          const Text("Remember Me", selectionColor: Colors.green),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      GestureDetector(
                        onTap: _validateAndLogin,
                        child: Container(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 7.0),
                          margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            border: Border.all(color: Colors.white, width: 4.0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Signup()));
                        },
                        child: const Center(
                          child: Text(
                            "Don't have an account? SIGN UP",
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
}