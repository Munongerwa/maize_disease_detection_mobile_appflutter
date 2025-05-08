import 'package:flutter/material.dart';
import 'package:maize_doc/Views/login.dart';
import 'package:maize_doc/Views/signup.dart';
import 'package:maize_doc/Components/colors.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("WELCOME BACK \nLOGIN YOUR MAIZE DOC ACCOUNT", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
              Image.asset("image/login.png", height: 200, width: 200,)
            ],
          ),
        ),
      );
  }
}
