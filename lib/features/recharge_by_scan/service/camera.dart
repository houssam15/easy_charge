import 'package:camera/camera.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
class CameraService{
  CameraController? _cameraController;
  dynamic _refresh;
  void setController(CameraController controller){
    _cameraController = controller;
  }

  bool isInitialized(){
    return _cameraController?.value.isInitialized??false;
  }

  CameraController? getController(){
    return _cameraController;
  }

  Future<void> initializeCamera(dynamic onInitialized) async{
    try{
      final cameras = await availableCameras();
      if(cameras.isEmpty) return;
      setController(
        CameraController(
           cameras[0],
           ResolutionPreset.high,
           enableAudio: false,
           imageFormatGroup:Platform.isAndroid?ImageFormatGroup.nv21:ImageFormatGroup.bgra8888
        )
      );
      await _cameraController?.initialize();
    }catch(err){
      print(err);
    }
    onInitialized();
  }

  InputImage getInputImageFromCameraImage(CameraImage cameraImage) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    // Determine image rotation here based on camera settings
    InputImageRotation rotation = InputImageRotation.rotation0deg; // Change as needed
    // Create metadata
    final metadata = InputImageMetadata(
      size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
      rotation: rotation,
      format: Platform.isAndroid?InputImageFormat.nv21:InputImageFormat.bgra8888,
      bytesPerRow: cameraImage.planes[0].bytesPerRow, // Assuming using the first plane
    );

    // Create and return the InputImage
    return InputImage.fromBytes(
      bytes: bytes,
      metadata: metadata, // Add the metadata here
    );
  }

  void setRefresh(Function refresh){
    _refresh = refresh;
  }

  void refresh(){
    if(_refresh is Function) _refresh();
  }

}