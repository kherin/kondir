import 'dart:async';
import './displayPicture.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key key,
    this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    loadModel();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/models/gtsrb_model.lite',
      labels: 'assets/labels/gtsrb_labels.txt',
    );
  }

  Future<List<dynamic>> classifyImage(String imagePath) async {
    var output = Tflite.runModelOnImage(
      path: imagePath,
      numResults: 36,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            var inference = await classifyImage(image.path);
            var rightAnswer;
            if (inference.length > 0) {
              rightAnswer = inference.first['label'];
              print("rightAnswer: $rightAnswer");
            } else {
              print("Inference is empty");
            }
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                  rightAnswer: rightAnswer,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
