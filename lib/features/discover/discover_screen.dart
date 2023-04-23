import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

import '../../constants/breakpoints.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _textEditingController =
      TextEditingController(text: "Initial Text");

  void _onSearchChanged(String value) {
    print("Searching for: $value");
  }

  void _onSearchSubmitted(String value) {
    print("submitted value: $value");
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onTapTap() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print(width);

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Container(
              constraints: const BoxConstraints(maxWidth: Breakpoints.sm),
              child: CupertinoSearchTextField(
                controller: _textEditingController,
                onChanged: _onSearchChanged,
                onSubmitted: _onSearchSubmitted,
                style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : Colors.black),
              ),
            ),
            elevation: 1,
            bottom: TabBar(
              onTap: (int index) {
                _onTapTap();
              },
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size16),
              isScrollable: true,
              splashFactory: NoSplash.splashFactory,
              // unselectedLabelColor: Colors.grey.shade500,
              // labelColor: Colors.black,
              // indicatorColor: Colors.black,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: Sizes.size16),
              tabs: [
                for (var tab in tabs)
                  Tab(
                    child: Text(tab),
                  ),
              ],
            )),
        body: TabBarView(children: [
          GridView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(Sizes.size6),
            itemCount: 20,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 9 / 20,
              crossAxisCount: width > Breakpoints.lg ? 5 : 2,
              crossAxisSpacing: Sizes.size10,
              mainAxisSpacing: Sizes.size10,
            ),
            itemBuilder: (context, index) => LayoutBuilder(
              builder: (context, constraints) => Column(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.size4)),
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: "assets/images/placeholder.jpeg",
                          image:
                              "https://explorethecanyon.com/wp-content/uploads/2018/01/Secrets-Image-1lr.jpg"),
                    ),
                  ),
                  Gaps.v10,
                  const Text(
                    "it is a very long caption for my tiltok that I'm uploading just now currently",
                    style: TextStyle(
                        fontSize: Sizes.size16 + Sizes.size2,
                        fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gaps.v10,
                  if (constraints.maxWidth < 230 || constraints.maxWidth > 250)
                    DefaultTextStyle(
                      style: TextStyle(
                          color: isDarkMode(context)
                              ? Colors.grey.shade200
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w600),
                      child: Row(
                        children: [
                          const CircleAvatar(radius: Sizes.size12),
                          Gaps.h8,
                          const Expanded(
                              child: Text(
                            "My avatar is going to be very long and on",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          Gaps.h8,
                          FaIcon(
                            FontAwesomeIcons.heart,
                            size: Sizes.size16,
                            color: Colors.grey.shade600,
                          ),
                          Gaps.h2,
                          const Text("2.5M")
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
          for (var tab in tabs.skip(1))
            Center(
              child: Text(tab, style: const TextStyle(fontSize: Sizes.size32)),
            )
        ]),
      ),
    );
  }
}
