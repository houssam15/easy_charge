import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../service/camera.dart';
class CameraPreviewWidget extends StatefulWidget {
  final CameraService cameraService;
  const CameraPreviewWidget({Key? key,required this.cameraService}) : super(key: key);

  @override
  _CameraPreviewWidgetState createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {

  @override
  void initState() {
    widget.cameraService.initializeCamera(
            ()=>setState((){
                widget.cameraService.refresh();
            })
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameraService.isInitialized()==false) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      width: double.infinity,
        child: CameraPreview(widget.cameraService.getController()!,));
  }

  @override
  void dispose() {
    widget.cameraService.getController()?.dispose();
    super.dispose();
  }
}