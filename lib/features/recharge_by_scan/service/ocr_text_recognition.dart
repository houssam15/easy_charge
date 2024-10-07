import "package:camera/camera.dart";
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class OcrTextRecognition{
  TextRecognizer textRecognizer = TextRecognizer();
  Future<bool> recognizeText(
      {required InputImage inputImage,required dynamic onDone,required dynamic onProcess}) async {
    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      RegExp regExp = RegExp(r'(\d\s*){14}');
      Iterable<Match> matches = regExp.allMatches(recognizedText.text);
      String results = matches.map((match) => match.group(0)!.replaceAll(' ', '')).join();
      if (results.isNotEmpty) onDone(results);
      else onProcess(recognizedText.text);

    } catch (e) {
      print('Error: $e');
    }
    return false;
  }

}