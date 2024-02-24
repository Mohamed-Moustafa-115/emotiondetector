import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_lite_flutter/tensorflow_lite_flutter.dart';

import 'main.dart';

class Detector extends StatefulWidget {
  const Detector({Key? key}) : super(key: key);

  @override
  State<Detector> createState() => _DetectorState();
}

class _DetectorState extends State<Detector> {
  CameraController? cameracontroller;
  String output = '';
  runModel(CameraImage img) async {
    dynamic recognitions = await Tflite.runModelOnFrame(
        bytesList: img.planes.map((plane) {
          return plane.bytes;
        }).toList(), // required
        imageHeight: img.height,
        imageWidth: img.width,
        imageMean: 127.5, // defaults to 127.5
        imageStd: 127.5, // defaults to 127.5
        rotation: 90, // defaults to 90, Android only
        numResults: 2, // defaults to 5
        threshold: 0.1, // defaults to 0.1
        asynch: true // defaults to true
        );
    for (var element in recognitions) {
      setState(() {
        var con = element['confidence'] * 100;
        output = "${element['label']}\nConfidence: $con%";
      });
    }
  }

  loadCamera() {
    cameracontroller = CameraController(cams![0], ResolutionPreset.veryHigh);
    cameracontroller!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameracontroller!.startImageStream((image) {
            runModel(image);
          });
        });
      }
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "asstes/model_unquant.tflite",
      labels: "asstes/labels.txt",
    );
  }

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCamera();
    loadModel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameracontroller!.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 500,
              height: 500,
              child: CameraPreview(cameracontroller!),
            ),
            SizedBox(
              height: 100,
            ),
            Text(
              "$output",
              style: TextStyle(color: Colors.black, fontSize: 32),
            ),
          ],
        ),
      ),
    );
  }
}
