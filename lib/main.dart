import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kondir/screens/takePicture.dart';
import './screens/home.dart';

Future<void> main() async {
  final firstCamera = await initCamera();
  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      home: TakePictureScreen(
        camera: firstCamera,
      ),
    ),
  );
}

Future<CameraDescription> initCamera() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  return cameras.first;
}

class EntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kondir',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Kondir'),
    );
  }
}
