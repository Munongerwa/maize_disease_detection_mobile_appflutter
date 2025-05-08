import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import 'package:image_picker/image_picker.dart';
import 'package:maize_doc/Views/Startpage.dart';
import 'dart:developer' as devtools;

import 'package:maize_doc/Views/onboarding.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  File? filePath;
  String label = '';
  double confidence = 0.0;
  bool isDarkMode = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  Future<void> tfLteInit() async{
    String? res = await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false

    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Tflite.close();
  }

  @override
  void initState() {
    super.initState();
    tfLteInit();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 2.0).animate(_controller);
  }
   pickImageGallery() async{
     final ImagePicker picker = ImagePicker();
     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
     if (image == null) return;

     var imageMap = File(image.path);

     setState(() {
       filePath = imageMap;
     });

     var recognitions = await Tflite.runModelOnImage(
         path: image.path,   // required
         imageMean: 0.0,   // defaults to 117.0
         imageStd: 255.0,  // defaults to 1.0
         numResults: 2,    // defaults to 5
         threshold: 0.2,   // defaults to 0.1
         asynch: true      // defaults to true
     );
     if (recognitions == null){
       devtools.log("recognitions is Null");
       return;
     }
     devtools.log(recognitions.toString());
     setState(() {
       confidence = (recognitions[0]['confidence'] * 100);
       label = recognitions[0]['label'].toString();
     });
   }
  pickImageCamera() async{
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    var recognitions = await Tflite.runModelOnImage(
        path: image.path,   // required
        imageMean: 0.0,   // defaults to 117.0
        imageStd: 255.0,  // defaults to 1.0
        numResults: 2,    // defaults to 5
        threshold: 0.2,   // defaults to 0.1
        asynch: true      // defaults to true
    );
    if (recognitions == null){
      devtools.log("recognitions is Null");
      return;
    }
    devtools.log(recognitions.toString());
    setState(() {
      confidence = (recognitions[0]['confidence'] * 100);
      label = recognitions[0]['label'].toString();
    });
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
    title: Text("Disease Detection"),
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
          padding: EdgeInsets.only(top: 120.0),
          child: Center(
            child: Column(
              children: [
                 SizedBox(
                  width: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 12,

                        ),
                        Card(
                          elevation: 20,
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            width: 400,
                            height: 450,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    height: 280,
                                    width: 280,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      image: DecorationImage(image: AssetImage('image/upload.png'),)

                                    ),
                                    child: filePath == null ? const Text('')
                                    : Image.file(filePath!, fit: BoxFit.fill,),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            label,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              backgroundColor: Colors.white,
                                            )
                                            ,),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            "The Accuracy is ${confidence.toStringAsFixed(0)}%",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              backgroundColor: Colors.white,
                                            )
                                            ,)
                                        ],
                                      ),
                                  )
                                ],
                              ),
                            )
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(onPressed: () {
                          pickImageCamera();
                        },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)
                              ),
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white54
                            ),
                            child: Text(
                                   "Take a Photo")
                        ),
                    SizedBox(
                      height: 8,
                    ),
                        ElevatedButton(onPressed: () {
                          pickImageGallery();
                        },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13)
                                ),
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white54
                            ),
                            child: Text(
                                "Pick from Gallery"),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
floatingActionButton: FloatingActionButton(
  onPressed: (){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Startpage()),
    );
  },
  child: Icon(Icons.home),
  backgroundColor: Colors.green,
),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    )
    );
  }
}
