import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maize_doc/Views/Common_RustRecommendations.dart';
import 'package:maize_doc/Views/Gray_Leaf_SpotRecommendations.dart';
import 'package:maize_doc/Views/BlightRecommendations.dart';
import 'dart:developer' as devtools;

import 'package:maize_doc/Views/welcomepage.dart';

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

    if (recognitions == null) {
      devtools.log("recognitions is Null");
      return;
    }

    devtools.log(recognitions.toString());
    setState(() {
      confidence = (recognitions[0]['confidence'] * 100);
      label = recognitions[0]['label'].toString();
    });
  }

  void navigateToRecommendations(String diseaseName) {
    Widget recommendationsPage;

    switch (diseaseName) {
      case 'Blight':
        recommendationsPage = BlightRecommendations();
        break;
      case 'Common_Rust':
        recommendationsPage = Common_RustRecommendations();
        break;
      case 'Gray_Leaf_Spot':
        recommendationsPage = Gray_Leaf_SpotRecommendations();
        break;
      default:
        recommendationsPage = Scaffold(
          appBar: AppBar(title: Text('No Recommendations')),
          body: Center(child: Text('No recommendations available for this disease.')),
        );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => recommendationsPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode
          ? ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
        ),
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.white,
        textTheme: TextTheme(headlineMedium: TextStyle(color: Colors.black)),
      )
          : ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
        ),
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        textTheme: TextTheme(headlineMedium: TextStyle(color: Colors.black)),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Disease Detection ", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)), // Include username
          backgroundColor: Colors.green,
          actions: [
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
          ],
        ),
        body: SizedBox(
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
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
                                    SizedBox(height: 16),
                                    Container(
                                      height: 160,
                                      width: 280,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        image: DecorationImage(image: AssetImage('image/upload.png')),
                                      ),
                                      child: filePath == null
                                          ? const Text('')
                                          : Image.file(filePath!, fit: BoxFit.fill),
                                    ),
                                    SizedBox(height: 12),
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
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
                                          SizedBox(height: 1),
                                          Text(
                                            "The Accuracy is ${confidence.toStringAsFixed(0)}%",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                          // Recommendation button
                                          SizedBox(height: 1),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (label.isNotEmpty) {
                                                navigateToRecommendations(label);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: pickImageCamera,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: pickImageGallery,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.green,
                            ),
                            child: Text(
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage(username: widget.username))); // Use widget.username
          },
          child: Icon(Icons.home),
          backgroundColor: Colors.green,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}