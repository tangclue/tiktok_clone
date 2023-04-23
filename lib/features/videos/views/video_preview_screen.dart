import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tiktok_clone/features/videos/view_models/timeline_view_model.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends ConsumerStatefulWidget {
  final XFile video;
  final bool isPicked;

  const VideoPreviewScreen(
      {Key? key, required this.video, required this.isPicked})
      : super(key: key);

  @override
  VideoPreviewScreenState createState() => VideoPreviewScreenState();
}

class VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
  late final VideoPlayerController _videoPlayerController;
  bool _savedVideo = false;
  Future<void> _initVideo() async {
    _videoPlayerController =
        VideoPlayerController.file(File(widget.video.path));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
    setState(() {});
  }

  void _onUploadPressed() {
    ref.read(timelineProvider.notifier).uploadVideo();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initVideo();
  }

  Future<void> _saveToGallery() async {
    if (_savedVideo) return;
    _savedVideo = true;
    await GallerySaver.saveVideo(widget.video.path, albumName: "TikTok Cline!");

    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          actions: [
            widget.isPicked
                ? const SizedBox()
                : IconButton(
                    onPressed: _saveToGallery,
                    icon: _savedVideo
                        ? const FaIcon(FontAwesomeIcons.check)
                        : const FaIcon(FontAwesomeIcons.download)),
            IconButton(
                onPressed: ref.watch(timelineProvider).isLoading
                    ? () {}
                    : _onUploadPressed,
                icon: ref.watch(timelineProvider).isLoading
                    ? const CircularProgressIndicator()
                    : const FaIcon(FontAwesomeIcons.cloudArrowUp))
          ],
          title: const Text("Preview video"),
        ),
        body: _videoPlayerController.value.isInitialized
            ? VideoPlayer(_videoPlayerController)
            : null);
  }
}
