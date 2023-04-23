import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class ChatDetailScreen extends StatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL = ":chatId";
  final String chatId;

  const ChatDetailScreen({super.key, required this.chatId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController.addListener(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingController.dispose();
    super.dispose();
  }

  void _onSend() {
    print(_textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: Sizes.size8,
            leading: Stack(
              children: [
                const CircleAvatar(
                  radius: Sizes.size32,
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/124027059?s=400&u=889a09d09354d0abb929fbe4d03e8fc3bc1df98e&v=4"),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: Sizes.size20,
                      height: Sizes.size20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade400,
                        border: Border.all(
                            color: Colors.grey.shade200, width: Sizes.size3),
                      ),
                    ))
              ],
            ),
            title: Text(
              "동규 (${widget.chatId})",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text("Active now"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                FaIcon(
                  FontAwesomeIcons.flag,
                  color: Colors.black,
                  size: Sizes.size20,
                ),
                Gaps.h32,
                FaIcon(
                  FontAwesomeIcons.ellipsis,
                  color: Colors.black,
                  size: Sizes.size20,
                )
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.symmetric(
                  vertical: Sizes.size20, horizontal: Sizes.size14),
              itemBuilder: (context, index) {
                final isMine = index % 2 == 0;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Sizes.size14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(Sizes.size20),
                          topRight: const Radius.circular(Sizes.size20),
                          bottomLeft: isMine
                              ? const Radius.circular(Sizes.size20)
                              : const Radius.circular(Sizes.size5),
                          bottomRight: isMine
                              ? const Radius.circular(Sizes.size5)
                              : const Radius.circular(Sizes.size20),
                        ),
                        color: isMine
                            ? Colors.blue
                            : Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        "This is a meesage.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => Gaps.v10,
              itemCount: 10,
            ),
            Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: BottomAppBar(
                  color: Colors.grey.shade50,
                  child: Row(children: [
                    Gaps.h20,
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(top: Sizes.size20),
                            hintText: "Send a message",
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(top: Sizes.size14),
                              child: FaIcon(FontAwesomeIcons.faceSmile),
                            )),
                      ),
                    ),
                    Gaps.h10,
                    GestureDetector(
                      onTap: _onSend,
                      child: Container(
                        width: Sizes.size40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const FaIcon(FontAwesomeIcons.paperPlane),
                      ),
                    )
                  ]),
                ))
          ],
        ));
  }
}
