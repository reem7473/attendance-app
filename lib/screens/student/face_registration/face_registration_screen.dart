import 'dart:async';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'bloc/registration_cubit.dart';
import 'bloc/registration_state.dart';
import 'success_screen.dart';
import '../../../shared/functions/network_util.dart'; 

class FaceRegistrationScreen extends StatefulWidget {
  final int student_id;

  const FaceRegistrationScreen({super.key, required this.student_id});
  _FaceRegistrationScreenState createState() => _FaceRegistrationScreenState();
}

class _FaceRegistrationScreenState extends State<FaceRegistrationScreen> {
  CameraController? _cameraController;
  List<String> _capturedImages = [];
  Timer? _timer;
  bool _isCapturing = false;
  bool _isCameraInitialized = false;
  bool _isPreparing = false; 
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

  void _startAutoCapture() async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('لا يوجد اتصال بالإنترنت. يرجى التحقق من الاتصال والمحاولة مرة أخرى.')),
      );
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      if (_capturedImages.length < 1) {
        await _captureImage();
      } else {
        _timer?.cancel();
        context.read<RegistrationCubit>().registerStudentFaceRepresentation(
            widget.student_id, _capturedImages);
        setState(() {
          _isCapturing = false;
        });
      }
    });
  }

  Future<void> _captureImage() async {
    final image = await _cameraController?.takePicture();
    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      setState(() {
        _capturedImages.add(base64Image);
      });
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
      appBar: AppBar(
            title: const Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  child: Text(
                    'إضافة بيانات الوجه',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.switch_camera,
                color: Color.fromARGB(255, 29, 72, 166)),
            onPressed: _toggleCamera,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'أظهر وجهك داخل الإطار',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              if (!_isCameraInitialized)
                Container(
                  height: 300,
                  width: 220,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 29, 72, 166), width: 3),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 80,
                      // color: Colors.blueAccent,
                    ),
                  ),
                )
              else if (_isCameraInitialized &&
                  _cameraController!.value.isInitialized)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 300,
                      width: 220,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 29, 72, 166), width: 3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CameraPreview(_cameraController!),
                    ),
                    if (_isCapturing)
                      const Positioned.fill(
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 4.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 29, 72, 166)),
                          ),
                        ),
                      ),
                  ],
                ),
              SizedBox(height: 20),
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
                            true; // Update state to start preparation
                      });
                    }
                  },
                  child: Text(
                      _isPreparing ? 'تسجيل بصمة الوجه' : 'تشغيل الكاميرا'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              BlocBuilder<RegistrationCubit, RegistrationState>(
                builder: (context, state) {
                  if (state is RegistrationLoading) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 4.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 29, 72, 166)
                              ),
                        ),
                      ),
                    );
                  } else if (state is RegistrationSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuccessScreen(),
                        ),
                      );
                    });
                    return SizedBox
                        .shrink(); 
                  } else if (state is RegistrationFailure) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          state.error,
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
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
