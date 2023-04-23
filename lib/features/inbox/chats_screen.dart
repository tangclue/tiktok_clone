import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';

import 'chat_detail_screen.dart';

class ChatsScreen extends StatefulWidget {
  static const String routeName = "chats";
  static const String routeURL = "/chats";
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();
  final List<int> _items = [];

  final Duration _duration = const Duration(milliseconds: 300);

  void _deleteItem(int index) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Container(
            color: Colors.red,
            child: _makeTile(index),
          ),
        ),
        duration: _duration,
      );

      _items.removeAt(index);
      print(_items);
      setState(() {});
    }
  }

  void _addItem() {
    if (_key.currentState != null) {
      _key.currentState!.insertItem(
        _items.length,
        duration: const Duration(milliseconds: 500),
      );
      _items.add(_items.length);
      print(_items);
      setState(() {});
      // print(_key);
      // print(_key.currentState);
    }
  }

  void _onChatTap(int index) {
    print(index);
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {"chatId": "$index"},
    );
  }

  Widget _makeTile(int index) {
    return ListTile(
      onLongPress: () {
        _deleteItem(index);
      },
      onTap: () => _onChatTap(index),
      leading: const CircleAvatar(
        foregroundImage: NetworkImage(
            "https://avatars.githubusercontent.com/u/124027059?s=400&u=889a09d09354d0abb929fbe4d03e8fc3bc1df98e&v=4"),
        radius: 30,
        child: Text('동규'),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Lynn ($index)",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            "2:16 AM",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Sizes.size14,
            ),
          ),
        ],
      ),
      subtitle: const Text("자니?"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("Direct Message"),
        actions: [
          IconButton(
              onPressed: _addItem,
              icon: const FaIcon(
                FontAwesomeIcons.plus,
                color: Colors.black,
              ))
        ],
      ),
      body: AnimatedList(
        key: _key,
        initialItemCount: 0,
        itemBuilder: (context, index, animation) {
          return SizeTransition(
            sizeFactor: animation,
            child: FadeTransition(
                key: UniqueKey(), opacity: animation, child: _makeTile(index)),
          );
        },
      ),

      // padding: const EdgeInsets.symmetric(vertical: Sizes.size10),
    );
  }
}
