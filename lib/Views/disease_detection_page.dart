import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maize_doc/Views/Common_RustRecommendations.dart';
import 'package:maize_doc/Views/Gray_Leaf_SpotRecommendations.dart';
import 'package:maize_doc/Views/BlightRecommendations.dart';
import 'dart:developer' as devtools;
import 'package:maize_doc/Views/welcomepage.dart';
import 'package:maize_doc/Views/database_helper.dart';

class DetectionScreen extends StatefulWidget {
  final String username;

  const DetectionScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> with SingleTickerProviderStateMixin {
  File? filePath;
  String label = '';
  double confidence = 0.0;
  bool isDarkMode = false;

  Future<void> tfLteInit() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  void initState() {
    super.initState();
    tfLteInit();
  }

  Future<void> pickImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    var imageMap = File(image.path);
    setState(() {
      filePath = imageMap;
    });

    await processImage(image.path);
  }

  Future<void> pickImageCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    var imageMap = File(image.path);
    setState(() {
      filePath = imageMap;
    });

    await processImage(image.path);
  }

  Future<void> processImage(String path) async {
    var recognitions = await Tflite.runModelOnImage(
      path: path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );

    if (recognitions == null || recognitions.isEmpty) {
      devtools.log("recognitions is Null");
      return;
    }

    devtools.log(recognitions.toString());
    setState(() {
      confidence = (recognitions[0]['confidence'] * 100);
      label = recognitions[0]['label'].toString();
    });

    // Store the detected disease in the database
    await DatabaseHelper().insertDiseaseHistory(label, confidence);
  }

  void navigateToRecommendations(String diseaseName) {
    Widget recommendationsPage;

    switch (diseaseName) {
      case 'Blight':
        recommendationsPage = BlightRecommendations(username: widget.username);
        break;
      case 'Common_Rust':
        recommendationsPage = Common_RustRecommendations(username: widget.username);
        break;
      case 'Gray_Leaf_Spot':
        recommendationsPage = Gray_Leaf_SpotRecommendations(username: widget.username);
        break;
      default:
        recommendationsPage = Scaffold(
          appBar: AppBar(title: const Text('No Recommendations')),
          body: const Center(child: Text('No recommendations available for this disease.')),
        );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => recommendationsPage),
    );
  }

  Future<void> showDiseaseHistory() async {
    List<Map<String, dynamic>> history = await DatabaseHelper().getDiseaseHistory();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Disease Detection History"),
          content: SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final record = history[index];
                return ListTile(
                  title: Text(record['disease']),
                  subtitle: Text("Confidence: ${record['confidence'].toStringAsFixed(2)}%"),
                  trailing: Text(record['timestamp']),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _onNavigationTapped(int index) {
    switch (index) {
      case 0: // Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage(username: widget.username)),
        );
        break;
      case 1: // Refresh
        setState(() {
          // Reset the state to refresh the page
          filePath = null;
          label = '';
          confidence = 0.0;
        });
        break;
      case 2: // Back
        Navigator.pop(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode
          ? ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
        ),
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.white,
        textTheme: const TextTheme(headlineMedium: TextStyle(color: Colors.black)),
      )
          : ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
        ),
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        textTheme: const TextTheme(headlineMedium: TextStyle(color: Colors.black)),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Disease Detection", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.wb_sunny : Icons.nights_stay,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
          ],
        ),
        body: SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 0),
                          Card(
                            elevation: 20,
                            clipBehavior: Clip.hardEdge,
                            child: SizedBox(
                              width: 500,
                              height: 300,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 16),
                                    Container(
                                      height: 160,
                                      width: 280,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        image: const DecorationImage(image: AssetImage('image/upload.png')),
                                      ),
                                      child: filePath == null
                                          ? const Text('')
                                          : Image.file(filePath!, fit: BoxFit.fill),
                                    ),
                                    const SizedBox(height: 12),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            label,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          Text(
                                            "The Accuracy is ${confidence.toStringAsFixed(0)}%",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (label.isNotEmpty) {
                                                navigateToRecommendations(label);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            ),
                                            child: const Text(
                                              "Get Recommendations",
                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: pickImageCamera,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(23),
                              ),
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.green,
                            ),
                            child: const Text(
                              "Take a Photo",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: pickImageGallery,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.green,
                            ),
                            child: const Text(
                              "Pick from Gallery",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.refresh),
              label: 'Refresh',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_back),
              label: 'Back',
            ),
          ],
          onTap: _onNavigationTapped,
          backgroundColor: Colors.green, // Set background color
          selectedItemColor: Colors.white, // Set selected item color
          unselectedItemColor: Colors.white70, // Set unselected item color
        ),
      ),
    );
  }
}