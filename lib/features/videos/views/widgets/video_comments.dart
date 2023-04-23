import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

import '../../../../generated/l10n.dart';

class VideoComments extends StatefulWidget {
  const VideoComments({Key? key}) : super(key: key);

  @override
  State<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends State<VideoComments> {
  bool _isWriting = false;
  void _onClosed() {
    Navigator.of(context).pop();
  }

  void _stopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  void _onStartWriting() {
    _isWriting = true;
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    final size = MediaQuery.of(context).size;
    return Container(
      height: 0.8 * size.height,
      clipBehavior: Clip.hardEdge,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(Sizes.size20)),
      child: Scaffold(
        backgroundColor: isDark ? null : Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: isDark ? null : Colors.grey.shade100,
          automaticallyImplyLeading: false,
          title: Text(
            S.of(context).commentTitle(1, 1),
          ),
          actions: [
            IconButton(
                onPressed: _onClosed,
                icon: const FaIcon(FontAwesomeIcons.xmark)),
          ],
        ),
        body: GestureDetector(
          onTap: _stopWriting,
          child: Stack(children: [
            Scrollbar(
              controller: _scrollController,
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.only(
                    top: Sizes.size10,
                    bottom: Sizes.size96 + Sizes.size20,
                    left: Sizes.size16,
                    right: Sizes.size16),
                separatorBuilder: (context, index) {
                  return Gaps.v20;
                },
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.size16, vertical: Sizes.size10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: isDark ? Colors.grey.shade500 : null,
                          radius: Sizes.size16,
                          child: const Text("동규"),
                        ),
                        Gaps.h8,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "동규",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.size14,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              Gaps.v3,
                              const Text(
                                  "That's not it I've seen the same thing but also in a cave"),
                            ],
                          ),
                        ),
                        Gaps.h10,
                        Column(
                          children: [
                            FaIcon(FontAwesomeIcons.heart,
                                size: Sizes.size20,
                                color: Colors.grey.shade500),
                            Gaps.v2,
                            Text(
                              '52.5K',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              width: size.width,
              child: BottomAppBar(
                // color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size16,
                    vertical: Sizes.size8,
                  ),
                  child: Row(children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      child: Text("동규"),
                    ),
                    Gaps.h10,
                    Expanded(
                        child: SizedBox(
                      height: Sizes.size52,
                      child: TextField(
                        onTap: _onStartWriting,
                        minLines: null,
                        maxLines: null,
                        expands: true,
                        textInputAction: TextInputAction.newline,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(right: Sizes.size14),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.at,
                                      color: isDark
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade900,
                                    ),
                                    Gaps.h10,
                                    FaIcon(
                                      FontAwesomeIcons.gift,
                                      color: isDark
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade900,
                                    ),
                                    Gaps.h10,
                                    FaIcon(
                                      FontAwesomeIcons.faceSmile,
                                      color: isDark
                                          ? Colors.grey.shade200
                                          : Colors.grey.shade900,
                                    ),
                                    Gaps.h10,
                                    if (_isWriting)
                                      GestureDetector(
                                        onTap: _stopWriting,
                                        child: FaIcon(
                                          FontAwesomeIcons.circleArrowUp,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                  ]),
                            ),
                            hintText: "Write a coment...",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(Sizes.size10),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size10,
                                vertical: Sizes.size12)),
                      ),
                    )),
                  ]),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
