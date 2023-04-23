import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_comments.dart';

import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../constants/sizes.dart';
import '../../../../generated/l10n.dart';

class VideoPost extends ConsumerStatefulWidget {
  final Function onVideoFinished;
  final int index;
  final String title;
  const VideoPost(
      {super.key,
      required this.onVideoFinished,
      required this.index,
      required this.title});

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/video1.mp4");

  // late final _videoPlayerController = widget.index % 2 == 0
  //     ? VideoPlayerController.asset("assets/videos/video1.mp4")
  //     : VideoPlayerController.asset("assets/videos/video2.mp4");
  bool _isSeeMore = false;
  bool _isPaused = false;
  // late bool _autoMute = context.read<PlaybackConfigViewModel>().muted;
  late bool _autoMute = ref.read(playbackConfigProvider).muted;
  late bool _isMuted = _autoMute;
  // bool _isMuted = false;

  final Duration _animationDuration = const Duration(milliseconds: 200);
  late final AnimationController _animationController;

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    await _videoPlayerController.initialize();
    // _videoPlayerController.play();

    _videoPlayerController.addListener(_onVideoChange);
    await _videoPlayerController.setLooping(true);
    if (kIsWeb) {
      _videoPlayerController.setVolume(0);
      _autoMute = true;
    }
    setState(() {});
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      // final autoplay = context.read<PlaybackConfigViewModel>().autoplay;
      // if (autoplay)
      if (ref.read(playbackConfigProvider).autoplay) {
        _videoPlayerController.play();
      }
    }
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _onToggleSeeMore() {
    _isSeeMore = !_isSeeMore;
    // print(_isSeeMore);
    setState(() {});
  }

  void _onToggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      if (_isMuted) {
        _videoPlayerController.setVolume(0);
      } else {
        _videoPlayerController.setVolume(1);
      }

      // videoConfig.value = !videoConfig.value;
      // setState(() {});
    });
  }

  void _onSetMute() {
    setState(() {
      if (_isMuted) {
        _videoPlayerController.setVolume(0);
      } else {
        _videoPlayerController.setVolume(1);
      }

      // videoConfig.value = !videoConfig.value;
      // setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );
    // context
    //     .read<PlaybackConfigViewModel>()
    //     .addListener(_onPlaybackConfigChanged);
    _onSetMute();
  }

  void _onPlaybackConfigChanged() {
    if (!mounted) return;
    final muted = _isMuted;
    if (muted) {
      _videoPlayerController.setVolume(0);
    } else {
      _videoPlayerController.setVolume(1);
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();

    super.dispose();
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }
    _isPaused = !_isPaused;
    setState(() {});
  }

  Future<void> _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => const VideoComments(),
        backgroundColor: Colors.transparent);

    _onTogglePause();
    // print("closed");
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned.fill(
              child: GestureDetector(
            onTap: _onTogglePause,
          )),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size48,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              left: 20,
              top: 40,
              child: IconButton(
                icon: FaIcon(
                  _isMuted
                      // context.watch<VideoConfig>().isMuted
                      ? FontAwesomeIcons.volumeOff
                      : FontAwesomeIcons.volumeHigh,
                  color: Colors.white,
                ),
                onPressed: () {
                  _onToggleMute();

                  // context
                  //     .read<PlaybackConfigViewModel>()
                  //     .setMuted(!context.read<PlaybackConfigViewModel>().muted);
                },
              )),
          Positioned(
              bottom: 20,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "@Donggyu",
                    style: TextStyle(
                      fontSize: Sizes.size20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                        color: Colors.white, fontSize: Sizes.size16),
                  ),
                  Gaps.v20,
                  const Text(
                    "This is my roommate!",
                    style:
                        TextStyle(color: Colors.white, fontSize: Sizes.size16),
                  ),
                  Gaps.v10,
                  Row(
                    children: [
                      SizedBox(
                        width: Sizes.size80 + Sizes.size80,
                        child: _isSeeMore
                            ? const Text(
                                "#roommate, #startup, #ZungGGeokMa",
                                style: TextStyle(color: Colors.white),
                              )
                            : const Text(
                                "#roommate, #startup, #ZungGGeokMa",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                      Gaps.h10,
                      GestureDetector(
                        onTap: _onToggleSeeMore,
                        child: Container(
                          color: Colors.transparent,
                          child: const Text(
                            "See more",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )),
          Positioned(
              bottom: 20,
              right: 10,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    // foregroundImage: NetworkImage(
                    //     "https://scontent-ssn1-1.cdninstagram.com/v/t51.2885-19/324069850_698646308656260_4454100793043600374_n.jpg?stp=dst-jpg_s320x320&_nc_ht=scontent-ssn1-1.cdninstagram.com&_nc_cat=100&_nc_ohc=5UpzRwK_TfkAX_gOb6p&edm=AOQ1c0wBAAAA&ccb=7-5&oh=00_AfCoozeRXifrRTyklR0lRveVXFDw3WIYhU7cFUry2hnHMA&oe=63EE42CF&_nc_sid=8fd12b"),
                    child: Text(
                      "Donggyu",
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                  Gaps.v24,
                  VideoButton(
                      icon: FontAwesomeIcons.solidHeart,
                      text: S.of(context).likeCount(3434)),
                  Gaps.v24,
                  GestureDetector(
                      onTap: () {
                        _onCommentsTap(context);
                      },
                      child: VideoButton(
                          icon: FontAwesomeIcons.solidComment,
                          text: S.of(context).commentCount(34343))),
                  Gaps.v24,
                  const VideoButton(
                      icon: FontAwesomeIcons.share, text: "Share"),
                ],
              ))
        ],
      ),
    );
  }
}
