import 'package:flutter/material.dart';
import 'package:maize_doc/Views/welcomepage.dart';

class Gray_Leaf_SpotRecommendations extends StatefulWidget {
  final String username;
  const Gray_Leaf_SpotRecommendations({Key? key, required this.username}) : super(key: key);

  @override
  _Gray_Leaf_SpotRecommendationsState createState() => _Gray_Leaf_SpotRecommendationsState();
}

class _Gray_Leaf_SpotRecommendationsState extends State<Gray_Leaf_SpotRecommendations> {
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
          'Gray Leaf Spot Overview',
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
                        Image.asset('image/Corn_Gray_Spot (5).jpg', fit: BoxFit.cover),
                        Image.asset('image/Corn_Gray_Spot (19).jpg', fit: BoxFit.cover),
                        Image.asset('image/Corn_Gray_Spot (27).jpg', fit: BoxFit.cover),
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

                  // What is Gray Leaf Spot Disease?
                  _buildExpansionTile(
                    title: 'What is Gray Leaf Spot Disease?',
                    content:
                    'Gray Leaf Spot is caused by the fungus Cercospora zeae-maydis, affecting maize crops. It leads to significant yield losses as it causes leaf blighting and premature leaf drop.',
                  ),
                  const SizedBox(height: 16.0),

                  // Symptoms
                  _buildExpansionTile(
                    title: 'Symptoms',
                    content:
                    '• Grayish lesions on leaves.\n'
                        '• Yellowing of leaf margins.\n'
                        '• Premature leaf drop.\n'
                        '• Reduced photosynthesis leading to stunted growth.',
                  ),
                  const SizedBox(height: 16.0),

                  // Control
                  _buildExpansionTile(
                    title: 'Control',
                    content: '• Use resistant varieties\n• Apply fungicides as necessary',
                  ),
                  const SizedBox(height: 16.0),

                  // Recommendations
                  _buildExpansionTile(
                    title: 'Recommendations',
                    content: '• Monitor humidity levels\n• Improve air circulation in crop fields',
                  ),
                  const SizedBox(height: 16.0),

                  // Chemicals Needed
                  _buildChemicalsNeeded(),
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

  Widget _buildExpansionTile({required String title, required String content, List<Widget>? children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: _isDarkMode ? Colors.grey[850] : Colors.green[200], // Set background color
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : Colors.black),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              content,
              style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontSize: _fontSize),
            ),
          ),
          if (children != null) ...children, // Add children if present
        ],
      ),
    );
  }

  Widget _buildChemicalsNeeded() {
    return _buildExpansionTile(
      title: 'Chemicals Needed',
      content: '',
      children: [
        Padding(
          padding: const EdgeInsets.all(0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChemicalCard('image/Shavitrust.jpg', 'Shavit'),
              const SizedBox(height: 16.0),
              _buildChemicalCard('assets/images/chemical2.jpg', 'Copper-based Solution'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChemicalCard(String imagePath, String chemicalName) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: _isDarkMode ? Colors.grey[850] : Colors.green[200], // Set background color
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Container(
              width: 150, // Set the desired width
              height: 150, // Set the desired height
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              chemicalName,
              style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}