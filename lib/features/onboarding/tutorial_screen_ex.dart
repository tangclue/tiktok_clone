/// DefaultTapController and TabPageSelector
import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';

import '../../constants/sizes.dart';

class TutorialScreenEx extends StatefulWidget {
  const TutorialScreenEx({Key? key}) : super(key: key);

  @override
  _TutorialScreenExState createState() => _TutorialScreenExState();
}

class _TutorialScreenExState extends State<TutorialScreenEx> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Gaps.v52,
                      Text(
                        "Watch cool videos!",
                        style: TextStyle(
                          fontSize: Sizes.size40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.v20,
                      Text(
                        "Videos are personalized for you based on what you watch, like, and share.",
                        style: TextStyle(fontSize: Sizes.size20),
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Gaps.v52,
                      Text(
                        "Follow the rules!",
                        style: TextStyle(
                          fontSize: Sizes.size40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.v20,
                      Text(
                        "Videos are personalized for you based on what you watch, like, and share.",
                        style: TextStyle(fontSize: Sizes.size20),
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Gaps.v52,
                      Text(
                        "Enjoy the ride!",
                        style: TextStyle(
                          fontSize: Sizes.size40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.v20,
                      Text(
                        "Videos are personalized for you based on what you watch, like, and share.",
                        style: TextStyle(fontSize: Sizes.size20),
                      )
                    ]),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size48,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  TabPageSelector(
                    color: Colors.white,
                    selectedColor: Colors.black38,
                  )
                ]),
          ),
        )),
      ),
    );
  }
}
