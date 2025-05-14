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

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.getBool('rememberMe') ?? false;
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
      if (_rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('username', username);
        prefs.setString('password', password);
        prefs.setBool('rememberMe', true);
      } else {
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('username');
        prefs.remove('password');
        prefs.setBool('rememberMe', false);
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
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: "Enter Username",
                          prefixIcon: Icon(Icons.person_outlined),
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
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          prefixIcon: Icon(Icons.password_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
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
                          const Text("Remember Me", selectionColor: Colors.green,),
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