import 'package:flutter/material.dart';
import 'package:maize_doc/Views/welcomepage.dart';

class BlightRecommendations extends StatefulWidget {
  final String username;
  const BlightRecommendations({Key? key, required this.username}) : super(key: key);

  @override
  _BlightRecommendationsState createState() => _BlightRecommendationsState();
}

class _BlightRecommendationsState extends State<BlightRecommendations> {
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
          'Blight Disease Overview',
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
                        Image.asset('image/Corn_Blight (21).jpg', fit: BoxFit.cover),
                        Image.asset('image/Corn_Blight (26).jpg', fit: BoxFit.cover),
                        Image.asset('image/Corn_Blight (27).jpg', fit: BoxFit.cover),
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

                  // New topic tile for maize blight disease
                  ExpansionTile(
                    title: Text(
                      'What is Maize Blight Disease?',
                      style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : Colors.black),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Maize blight disease is caused by various fungal pathogens that affect maize (corn) crops. The disease can lead to significant yield losses due to symptoms such as wilting, yellowing of leaves, and premature leaf drop. Proper identification and management practices, including crop rotation and the use of resistant varieties, are essential for controlling the disease.',
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
                          '• Wilting Leaves: Leaves may appear droopy and lack firmness.\n'
                              '• Brown Spots: Small, dark brown spots can develop on the leaves.\n'
                              '• Yellowing: A general yellowing of the foliage may occur, especially on the lower leaves.\n'
                              '• Premature Leaf Drop: Infected plants may shed leaves earlier than normal.\n'
                              '• Stunted Growth: Overall plant growth may be stunted.\n'
                              '• Fungal Growth: You may observe a white or grayish fungal growth on the leaves.',
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
                          '• Remove infected plants\n• Practice crop rotation',
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
                          '• Increase nitrogen fertilization\n• Improve drainage\n• Monitor for pests',
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
                          '• Fungicides such as chlorothalonil\n• Copper-based solutions',
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