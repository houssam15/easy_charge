import "package:camera/camera.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "../../service/camera.dart";
import "../../service/ocr_text_recognition.dart";

class ScanAlertContentWidget extends StatefulWidget {
  ScanAlertContentWidget({super.key,required this.onDone,required this.codeLength});
  dynamic onDone;
  String? codeLength;

  @override
  State<ScanAlertContentWidget> createState() => _ScanAlertContentWidgetState();
}

class _ScanAlertContentWidgetState extends State<ScanAlertContentWidget> {
  CameraService _cameraService = CameraService();
  OcrTextRecognition _ocrTextRecognition = OcrTextRecognition();
  late Future<void> _initializeControllerFuture;
  //this is true when we get the result in onDone callback , it used to avoid listening plateform frames after stream is closed.
  bool isDone = false;
  bool isFlashOn = false;

  _toggleFlash(){
      _cameraService.getController()?.setFlashMode(isFlashOn?FlashMode.off:FlashMode.torch);
      isFlashOn = !isFlashOn;
      setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture =  _cameraService.initializeCamera();
  }

  _startDetection() async{
    if(_cameraService.getController()==null || _cameraService.isStreamingImages()==true) return;
    _cameraService.startCameraControllerImageStream(
      controller: _cameraService.getController()!,
      listener: _myListener
    );
    _cameraService.streamingStarted();
    setState(() {});
  }

  _myListener(image){
    OcrTextRecognition().recognizeText(
        codeLength: widget.codeLength,
        inputImage: _cameraService.getInputImageFromCameraImage(image),
        onDone: (String text) {
          if(kDebugMode) print("FOUNT $text");
          _ocrTextRecognition.stopRecognization = true;
          _stopDetection();
          if(isDone){
            widget.onDone(context,text);
          }else{
            isDone = true;
          }
          setState(() {});
        },
        onProcess: (String text) {
          if(kDebugMode) print("PROCESSING $text");
        }
    );
  }

  _stopDetection() async{
    if(_cameraService.isStreamingImages()==false) return;
    await _cameraService.getController()?.stopImageStream();
    _cameraService.streamingStoped();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            return Container(
              height: MediaQuery.of(context).size.height*2/4,
              child: Column(
                children: [
                  CameraPreview(
                      _cameraService.getController()!,
                      child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "make ${widget.codeLength} code here",
                                          style: TextStyle(
                                            color: _cameraService.isStreamingStarted?Theme.of(context).colorScheme.error:Theme.of(context).colorScheme.primary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width*3/5,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            border:Border.all(
                                              color: _cameraService.isStreamingStarted?Theme.of(context).colorScheme.error:Theme.of(context).colorScheme.primary,
                                              width: 3.0
                                            ),
                                            color: Colors.transparent
                                          ),
                                        ),
                                      ],
                                    )
                      )
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: ()=>_toggleFlash(),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: isFlashOn?Theme.of(context).colorScheme.primary:Colors.grey,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child:const Icon(Icons.flash_on,color: Colors.white),
                          )
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:WidgetStateProperty.all(
                                  _cameraService.isStreamingStarted?Theme.of(context).colorScheme.error:Theme.of(context).colorScheme.primary
                              )
                          ),
                          onPressed: (){
                            if(_cameraService.isStreamingStarted){
                              _stopDetection();
                            } else {
                              _startDetection();
                            }
                          },
                          child:Text(
                            _cameraService.isStreamingStarted?"Stop detection":"Start detection",
                            style:const TextStyle(
                                color: Colors.white,
                            ),
                          )
                      )
                    ],
                  )
                ],
              ),
            );
          }else{
            return const Center(child: CircularProgressIndicator());
          }
        },
    );
  }

  @override
  void dispose() {
    _cameraService.dispose();
    if(kDebugMode) print("is disposed ${_cameraService.isCameraDisposed}");
    super.dispose();
  }

}






