import 'package:flutter/material.dart';
import 'package:maize_doc/Views/welcomepage.dart';

class Common_RustRecommendations extends StatefulWidget {
  final String username;
  const Common_RustRecommendations({Key? key, required this.username}) : super(key: key);

  @override
  _Common_RustRecommendationsState createState() => _Common_RustRecommendationsState();
}

class _Common_RustRecommendationsState extends State<Common_RustRecommendations> {
  double _fontSize = 16.0; // Initial font size
  bool _isDarkMode = false; // Dark mode state

  void _zoomIn() {
    setState(() {
      _fontSize += 2; // Increase font size
    });
  }

  void _zoomOut() {
    setState(() {
      if (_fontSize > 10) _fontSize -= 2; // Decrease font size
    });
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Common Rust Overview',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: _isDarkMode ? Colors.black : Colors.white,
            ),
            onPressed: _toggleDarkMode,
          ),
        ],
      ),
      body: GestureDetector(
        onScaleUpdate: (details) {
          if (details.scale > 1) {
            _zoomIn();
          } else if (details.scale < 1) {
            _zoomOut();
          }
        },
        child: Scrollbar(
          thumbVisibility: true, // Show the scrollbar at all times
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Horizontal image slider
                  SizedBox(
                    height: 120,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Image.asset('image/Corn_Common_Rust (30).jpg', fit: BoxFit.cover),
                        Image.asset('image/Corn_Common_Rust (44).jpg', fit: BoxFit.cover),
                        Image.asset('image/Corn_Common_Rust (75).jpg', fit: BoxFit.cover),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Swipe left or right to view more images',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // New topic tile for common rust disease
                  ExpansionTile(
                    title: Text(
                      'What is Common Rust Disease?',
                      style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : Colors.black),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Common rust disease is caused by the fungus *Puccinia sorghi*, which affects maize (corn) crops. The disease is characterized by the appearance of reddish-brown pustules on the leaves, leading to reduced photosynthesis and ultimately affecting yield.',
                          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontSize: _fontSize),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Collapsible tiles for symptoms
                  ExpansionTile(
                    title: Text(
                      'Symptoms',
                      style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : Colors.black),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '• Reddish-brown pustules on leaves.\n'
                              '• Yellowing of surrounding leaf tissue.\n'
                              '• Premature leaf drop.\n'
                              '• Stunted growth in severe cases.',
                          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontSize: _fontSize),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Control
                  ExpansionTile(
                    title: Text(
                      'Control',
                      style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : Colors.black),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '• Use resistant maize varieties.\n'
                              '• Apply fungicides as needed.\n'
                              '• Practice crop rotation.',
                          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontSize: _fontSize),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Recommendations
                  ExpansionTile(
                    title: Text(
                      'Recommendations',
                      style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : Colors.black),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '• Monitor for early signs of infection.\n'
                              '• Ensure proper spacing between plants.\n'
                              '• Rotate with non-host crops.',
                          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontSize: _fontSize),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Chemicals Needed
                  ExpansionTile(
                    title: Text(
                      'Chemicals Needed',
                      style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : Colors.black),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '• Fungicides such as azoxystrobin and propiconazole.',
                          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontSize: _fontSize),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0), // Extra space at the bottom
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Back',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // Navigate to the homepage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage(username: widget.username)),
            );
          } else if (index == 2) {
            // Go back to the previous screen
            Navigator.pop(context);
          }
        },
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
    );
  }
}