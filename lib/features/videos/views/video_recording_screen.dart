import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/views/video_preview_screen.dart';

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = "postVideo";
  static const String routeURL = "/upload";
  const VideoRecordingScreen({Key? key}) : super(key: key);

  @override
  _VideoRecordingScreenState createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final bool _noCamera = kDebugMode && Platform.isIOS;
  bool _hasPermission = false;
  bool _isSelfieMode = false;
  late CameraController _cameraController;
  late FlashMode _flashMode;
  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 200,
    ),
  );
  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 10,
    ),
    lowerBound: 0.0,
    upperBound: 1.0,
  );
  late double _maxZoomLevel;
  late final Animation<double> _buttonAnimation =
      Tween(begin: 1.0, end: 1.3).animate(_buttonAnimationController);
  double zoom = 1.0;

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    print(cameras);
    if (cameras.isEmpty) {
      return;
    }
    _cameraController = CameraController(
        cameras[_isSelfieMode ? 1 : 0], ResolutionPreset.ultraHigh,
        enableAudio: false);

    await _cameraController.initialize();
    await _cameraController.prepareForVideoRecording();

    _maxZoomLevel = await _cameraController.getMaxZoomLevel();

    _flashMode = _cameraController.value.flashMode;
    setState(() {});
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final camraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!camraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    if (!_noCamera) {
      initPermissions();
    } else {
      setState(() {
        _hasPermission = true;
      });
    }
    WidgetsBinding.instance.addObserver(this);
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _startRecording() async {
    if (_cameraController.value.isRecordingVideo) {
      return;
    }
    await _cameraController.startVideoRecording();
    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController.stopVideoRecording();

    if (!mounted) return;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPreviewScreen(
            video: video,
            isPicked: false,
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _buttonAnimationController.dispose();
    if (!_noCamera) {
      _cameraController.dispose();
    }

    _progressAnimationController.dispose();

    super.dispose();
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (video == null) return;

    if (!mounted) return;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPreviewScreen(
            video: video,
            isPicked: true,
          ),
        ));
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_noCamera) return;
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      await initCamera();
      setState(() {});
    }
  }

  Future<void> _setZoom(DragUpdateDetails details) async {
    zoom = zoom + (-0.005) * details.localPosition.dy;
    zoom = max(zoom, 1);
    zoom = min(zoom, _maxZoomLevel);

    await _cameraController.setZoomLevel(zoom);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: !_hasPermission
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Requesting permissions...",
                      style: TextStyle(
                          color: Colors.white, fontSize: Sizes.size20),
                    ),
                    Gaps.v20,
                    CircularProgressIndicator.adaptive(),
                  ],
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!_noCamera && _cameraController.value.isInitialized)
                      CameraPreview(_cameraController),
                    const Positioned(
                        top: Sizes.size40,
                        left: Sizes.size20,
                        child: CloseButton(
                          color: Colors.white,
                        )),
                    if (!_noCamera)
                      Positioned(
                        top: Sizes.size20,
                        right: Sizes.size20,
                        child: Column(
                          children: [
                            IconButton(
                              color: Colors.white,
                              onPressed: _toggleSelfieMode,
                              icon: const Icon(Icons.cameraswitch),
                            ),
                            Gaps.v10,
                            IconButton(
                                onPressed: () => _setFlashMode(FlashMode.off),
                                color: _flashMode == FlashMode.off
                                    ? Colors.yellow
                                    : Colors.white,
                                icon: const Icon(Icons.flash_off_rounded)),
                            Gaps.v10,
                            IconButton(
                                onPressed: () =>
                                    _setFlashMode(FlashMode.always),
                                color: _flashMode == FlashMode.always
                                    ? Colors.yellow
                                    : Colors.white,
                                icon: const Icon(Icons.flash_on_rounded)),
                            Gaps.v10,
                            IconButton(
                                onPressed: () => _setFlashMode(FlashMode.auto),
                                color: _flashMode == FlashMode.auto
                                    ? Colors.yellow
                                    : Colors.white,
                                icon: const Icon(Icons.flash_auto_rounded)),
                            Gaps.v10,
                            IconButton(
                                color: _flashMode == FlashMode.torch
                                    ? Colors.yellow
                                    : Colors.white,
                                onPressed: () => _setFlashMode(FlashMode.torch),
                                icon: const Icon(Icons.flashlight_on_rounded))
                          ],
                        ),
                      ),
                    Positioned(
                        bottom: Sizes.size40,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            const Spacer(),
                            GestureDetector(
                              onVerticalDragUpdate: (details) =>
                                  _setZoom(details),
                              onTapDown: (details) => _startRecording(),
                              onTapUp: (details) => _stopRecording(),
                              child: ScaleTransition(
                                scale: _buttonAnimation,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: Sizes.size80 + Sizes.size14,
                                      height: Sizes.size80 + Sizes.size14,
                                      child: CircularProgressIndicator(
                                        color: Colors.red.shade400,
                                        strokeWidth: Sizes.size6,
                                        value:
                                            _progressAnimationController.value,
                                      ),
                                    ),
                                    Container(
                                      width: Sizes.size80,
                                      height: Sizes.size80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: IconButton(
                                    onPressed: _onPickVideoPressed,
                                    icon: const FaIcon(
                                      FontAwesomeIcons.image,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
        ));
  }
}
