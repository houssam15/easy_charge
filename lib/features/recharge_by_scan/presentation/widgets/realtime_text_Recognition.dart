import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import "package:recharge_by_scan/features/recharge_by_scan/service/ocr_text_recognition.dart";

import '../../service/camera.dart';

class RealTimeTextRecognitionWidget extends StatefulWidget {
  final CameraService cameraService;
  const RealTimeTextRecognitionWidget({super.key,required this.cameraService});

  @override
  State<RealTimeTextRecognitionWidget> createState() => _RealTimeTextRecognitionWidgetState();
}

class _RealTimeTextRecognitionWidgetState extends State<RealTimeTextRecognitionWidget> {
  String _recognizedText = "";
  bool _stopRecognition = false;

  @override
  void initState() {

    widget.cameraService.getController()?.startImageStream((image) async{
      if (!_stopRecognition) {
        await OcrTextRecognition().recognizeText(
            inputImage: widget.cameraService.getInputImageFromCameraImage(
                image),
            onDone: (String text) {
              _recognizedText = text;
              _stopRecognition = true;
              widget.cameraService.getController()?.dispose();
            },
            onProcess: (String text) {
              _recognizedText = text;
            }
        );
        setState(() {});
      }

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                _recognizedText.isNotEmpty ? _recognizedText : 'Scanning...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:_stopRecognition==true? Colors.green:Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              if(_stopRecognition==true)
                ElevatedButton(onPressed: (){
                  print("found ${_recognizedText}");
                }, child: Text("Next"))
            ],
          ),
        ),
      ),
    );
  }
}
