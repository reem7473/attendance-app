import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'bloc/attendance_cubit.dart';
import 'bloc/attendance_state.dart';

class FingerprintAuthenticationScreen extends StatefulWidget {
  final int attendanceRecordId;

  const FingerprintAuthenticationScreen(
      {super.key, required this.attendanceRecordId});

  @override
  _FingerprintAuthenticationScreenState createState() =>
      _FingerprintAuthenticationScreenState();
}

class _FingerprintAuthenticationScreenState
    extends State<FingerprintAuthenticationScreen> {
  CameraController? _cameraController;
  Timer? _timer;
  bool _isCapturing = false;
  bool _isCameraInitialized = false;
  bool _isPreparing = false;
  bool _isLoading = false; 
  String? _lastImagePath;
  int _cameraIndex = 0; 

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initializeCamera() async {
    await Permission.camera.request();
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController =
          CameraController(cameras[_cameraIndex], ResolutionPreset.medium);
      await _cameraController?.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  void _startAutoCapture() {
    setState(() {
      _isCapturing = true;
      _isLoading = true; 
    });

    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        await _captureImage();
      }
    });
  }

  Future<void> _stopCamera() async {
    _cameraController?.dispose();
    _timer?.cancel();
    setState(() {
      _isCapturing = false;
      _isCameraInitialized = false;
      _isPreparing = false;
      _isLoading = false; 
    });
  }

  Future<void> _deleteLastImage() async {
    if (_lastImagePath != null) {
      final file = File(_lastImagePath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<void> _captureImage() async {
    final image = await _cameraController?.takePicture();
    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      context
          .read<AttendanceCubit>()
          .markAttendance(base64Image, widget.attendanceRecordId);
    }
  }

  Future<void> _toggleCamera() async {
    if (_cameraController != null) {
      final cameras = await availableCameras();
      setState(() {
        _cameraIndex = (_cameraIndex + 1) % cameras.length;
        _cameraController =
            CameraController(cameras[_cameraIndex], ResolutionPreset.medium);
        _initializeCamera();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'من فضلك قف امام الكاميرا',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 300,
                    width: 220,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 29, 72, 166),
                          width: 3),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: _isCameraInitialized &&
                            _cameraController!.value.isInitialized
                        ? CameraPreview(_cameraController!)
                        : Center(
                            child: _isCapturing
                                ? CircularProgressIndicator(
                                    strokeWidth: 4.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        const Color.fromARGB(255, 29, 72, 166)),
                                  )
                                : Icon(
                                    Icons.camera_alt,
                                    size: 80,
                                  ),
                          ),
                  ),
                  IconButton(
                    icon: Icon(Icons.switch_camera),
                    color: Color.fromARGB(255, 29, 72, 166),
                    onPressed: _toggleCamera,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocListener<AttendanceCubit, AttendanceState>(
                  listener: (context, state) {
                    if (state is AttendanceSuccess) {
                      _deleteLastImage();
                      _stopCamera();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FaceRecognitionSuccessScreen(
                            studentName: state.studentName,
                            studentNumber: state.studentNumber,
                          ),
                        ),
                      );
                    } else if (state is AttendanceFailure) {
                      _stopCamera();
                      _deleteLastImage();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FaceRecognitionFailureScreen(
                              message: state.error),
                        ),
                      );
                    }
                  },
                  child: BlocBuilder<AttendanceCubit, AttendanceState>(
                    builder: (context, state) {
                      if (state is AttendanceLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 4.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 29, 72, 166),),
                          ),
                        );
                      }
                      return Center(
                        child: Text(
                          'اضغط على زر التحضير للبدء',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_isCameraInitialized) {
                      await _initializeCamera();
                    }

                    if (_isPreparing) {
                      _startAutoCapture();
                    } else {
                      setState(() {
                        _isPreparing =
                            true; 
                      });
                    }
                  },
                  child: _isLoading
                      ? CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(_isPreparing ? 'بدء التحضير' : 'تشغيل الكاميرا'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timer?.cancel();
    super.dispose();
  }
}

class FaceRecognitionSuccessScreen extends StatelessWidget {
  final String studentName;
  final String studentNumber;

  const FaceRecognitionSuccessScreen(
      {super.key, required this.studentName, required this.studentNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التحقق بنجاح', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            Text('تم التحقق بنجاح',
                style: TextStyle(fontSize: 18, color: Colors.black)),
            Text('اسم الطالب: $studentName',
                style: TextStyle(fontSize: 16, color: Colors.black)),
            Text('الرقم الجامعي: $studentNumber',
                style: TextStyle(fontSize: 16, color: Colors.black)),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('تم'),
            ),
          ],
        ),
      ),
    );
  }
}

class FaceRecognitionFailureScreen extends StatelessWidget {
  final String message;

  const FaceRecognitionFailureScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('فشل في التحقق', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 100),
            Text('فشل في التحقق.. الرجاء اعاده المحاوله',
                style: TextStyle(fontSize: 18, color: Colors.black)),
            Text('$message',style: TextStyle(fontSize: 18, color: Colors.black)),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('الرجاء اعاده المحاوله'),
            ),
          ],
        ),
      ),
    );
  }
}
