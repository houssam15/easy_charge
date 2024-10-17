import "package:camera/camera.dart";
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class OcrTextRecognition{
  TextRecognizer textRecognizer = TextRecognizer();
  bool _stopRecognization = false;

  bool get stopRecognization => _stopRecognization;

  set stopRecognization(bool v){
    _stopRecognization = v;
  }

  Future<void> recognizeText(
      {required InputImage inputImage,required dynamic onDone,required dynamic onProcess,String? codeLength}) async {
    try {
      if(stopRecognization) return;
      final recognizedText = await textRecognizer.processImage(inputImage);
      RegExp regExp = RegExp(r'(\d\s*){' + codeLength.toString() + '}');
      Iterable<Match> matches = regExp.allMatches(recognizedText.text);
      String results = matches.map((match) => match.group(0)!.replaceAll(' ', '')).join();
      if (results.isNotEmpty) onDone(results);
      else onProcess(recognizedText.text);
    } catch (e) {
      if(kDebugMode) print('Error: $e');
    }
  }

}