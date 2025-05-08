import 'package:flutter/material.dart';
import 'package:maize_doc/Components/colors.dart';

class Button extends StatelessWidget {
  final String label;
  final VoidCallback press;
  const Button({super.key, required this.label, required this.press});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width *.9,
      height: 55,
      decoration: BoxDecoration(
        color: primaryColor,
      ),

      child: TextButton(
        onPressed: press,
        child: Text(label,style: const TextStyle(color: Colors.white),),
      ),

    );
  }
}
