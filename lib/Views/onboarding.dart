import 'package:flutter/material.dart';
import 'package:maize_doc/Views/login.dart';
import 'package:maize_doc/Views/signup.dart';


class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 120.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [
          Color(0xFF11823B),
          Color(0xFF48BF53),
          Color(0xFF91F086),
        ], begin: Alignment.topLeft, end: Alignment.topRight)),
        child: Column(
          children: [
            Image.asset("image/maizedoc.png",
              height: 200, width: 200, fit: BoxFit.cover,
            ),
            Text("MAIZE DOCTOR", style: TextStyle(color: Colors.white, fontSize: 30.0),),
            SizedBox(height: 50.0,),
            Text("", style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 90.0,),
            GestureDetector(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
              },
              child: Container(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 4.0), borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(
                    "LOGIN",
                      style: TextStyle(color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500 ),),
                  ),
              ),
            ),
            SizedBox(height: 40.0,),
            GestureDetector(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()));
              },

              child: Container(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white,  borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500 ),),
                ),
              ),
            )

          ],
        ),
      ),

    );
  }
}
