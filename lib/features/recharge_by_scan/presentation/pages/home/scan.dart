import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:recharge_by_scan/features/recharge_by_scan/presentation/widgets/realtime_text_Recognition.dart';
import '../../widgets/camera_preview.dart';
import "package:recharge_by_scan/features/recharge_by_scan/service/camera.dart";
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraService _cameraService = CameraService();

  @override
  void initState() {
    _cameraService.setRefresh((){
      setState(() {});
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan"),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.back_hand),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: CameraPreviewWidget(
                cameraService:_cameraService
              ),
            ),
            if(_cameraService.isInitialized()==true)
            Expanded(child: RealTimeTextRecognitionWidget(cameraService: _cameraService)), // Pass the camera controller if needed
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraService.getController()?.dispose();
    super.dispose();
  }
}
