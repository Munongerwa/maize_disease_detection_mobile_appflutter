import 'package:flutter/material.dart';

class Common_RustRecommendations extends StatelessWidget {
  const Common_RustRecommendations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendations for Common_Rust'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(child: ListTile(title: Text('1. Increase nitrogen fertilization.'))),
            Card(child: ListTile(title: Text('2. Improve drainage.'))),
            Card(child: ListTile(title: Text('3. Monitor for pests.'))),
          ],
        ),
      ),
    );
  }
}