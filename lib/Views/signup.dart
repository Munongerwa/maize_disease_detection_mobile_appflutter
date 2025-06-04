import 'package:flutter/material.dart';
import 'package:maize_doc/Views/login.dart';
import 'package:maize_doc/Views/database_helper.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? _emailError;

  void _validateAndSignUp() async {
    setState(() {
      _emailError = null;
    });

    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Check for empty fields
    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showDialog("Empty Fields", "Please fill in all fields.");
      return;
    }

    // Validate email format
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        _emailError = 'Please enter a valid email';
      });
      return;
    }

    // Validate password strength
    if (!_isPasswordStrong(password)) {
      _showDialog("Weak Password", "Password must be at least 8 characters long and include a number and a special character.");
      return;
    }

    // Validate password match
    if (password != confirmPassword) {
      _showDialog("Password Mismatch", "Passwords do not match.");
      return;
    }

    // Check if email already exists in the database
    bool emailExists = await _dbHelper.checkEmailExists(email);
    if (emailExists) {
      _showDialog("Email Already Exists", "This email is already registered. Please use a different email.");
      return;
    }

    // Insert the user into the database
    _dbHelper.insertUser(username, email, password).then((_) {
      _showSuccessDialog();
    });
  }

  bool _isPasswordStrong(String password) {
    // Password must be at least 8 characters long, contain at least one number and one special character
    bool hasMinLength = password.length >= 8;
    bool hasNumber = RegExp(r'\d').hasMatch(password);
    bool hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    return hasMinLength && hasNumber && hasSpecialChar;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Registration Successful"),
          content: const Text("You have successfully registered!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
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
                      "Welcome\nCreate Your Account !",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 30.0),
                    Image.asset(
                      'image/maizedoc.png',
                      height: 60.0,
                      width: 60.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 20.0),
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
                          fontSize: 18.0,
                        ),
                      ),
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          hintText: "Enter Username",
                          prefixIcon: Icon(Icons.person_outlined),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Email",
                        style: TextStyle(
                          color: Color(0xFF038836),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Enter Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          errorText: _emailError,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Password",
                        style: TextStyle(
                          color: Color(0xFF038836),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          prefixIcon: const Icon(Icons.password_outlined),
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
                      const SizedBox(height: 8),
                      const Text(
                        "Confirm Password",
                        style: TextStyle(
                          color: Color(0xFF038836),
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true, // Make the password invisible
                        decoration: const InputDecoration(
                          hintText: "Re-Enter Password",
                          prefixIcon: Icon(Icons.password_outlined),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      GestureDetector(
                        onTap: _validateAndSignUp,
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
                              "SIGNUP",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                        },
                        child: const Center(
                          child: Text(
                            "Already have an account? LOGIN IN",
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 15,
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