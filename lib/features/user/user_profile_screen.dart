import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';
import 'package:tiktok_clone/features/user/widgets/persistent_tab_bar.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({
    Key? key,
    required this.username,
    required this.tab,
  }) : super(key: key);
  final String username;
  final String tab;
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  void _onGearPressed() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SettingsScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          initialIndex: widget.tab == "likes" ? 1 : 0,
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  // backgroundColor: Colors.black,
                  title: Text(widget.username),
                  actions: [
                    IconButton(
                      onPressed: _onGearPressed,
                      icon: const FaIcon(
                        FontAwesomeIcons.gear,
                        size: Sizes.size20,
                      ),
                    )
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(children: [
                    Gaps.v20,
                    const CircleAvatar(
                      radius: 50,
                      foregroundImage: NetworkImage(
                          "https://avatars.githubusercontent.com/u/124027059?s=400&u=889a09d09354d0abb929fbe4d03e8fc3bc1df98e&v=4"),
                    ),
                    Gaps.v20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "@${widget.username}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Sizes.size18),
                        ),
                        Gaps.h5,
                        FaIcon(
                          FontAwesomeIcons.solidCircleCheck,
                          size: Sizes.size16,
                          color: Colors.blue.shade500,
                        )
                      ],
                    ),
                    Gaps.v24,
                    SizedBox(
                      height: Sizes.size48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "10M",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Gaps.v3,
                              Text(
                                "Followers",
                                style: TextStyle(color: Colors.grey.shade500),
                              )
                            ],
                          ),
                          VerticalDivider(
                            width: Sizes.size32,
                            thickness: Sizes.size1,
                            color: Colors.grey.shade400,
                            indent: Sizes.size14,
                            endIndent: Sizes.size14,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "97",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Gaps.v3,
                              Text(
                                "Following",
                                style: TextStyle(color: Colors.grey.shade500),
                              )
                            ],
                          ),
                          VerticalDivider(
                            width: Sizes.size32,
                            thickness: Sizes.size1,
                            color: Colors.grey.shade400,
                            indent: Sizes.size14,
                            endIndent: Sizes.size14,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "194.3M",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Gaps.v3,
                              Text(
                                "Likes",
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gaps.v14,
                    FractionallySizedBox(
                      widthFactor: 0.33,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(Sizes.size4))),
                          child: const Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: Sizes.size14),
                            child: Text(
                              "Follow",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                    Gaps.v14,
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.size32),
                      child: Text(
                        "All highlights and where to watch live mathces on FIFA+ I wonder how it would look bad",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Gaps.v14,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.link,
                          size: Sizes.size12,
                        ),
                        Gaps.h4,
                        Text("https://susulearn.co.kr")
                      ],
                    ),
                    Gaps.v20,
                  ]),
                ),
                SliverPersistentHeader(
                  delegate: PersistentTabBar(),
                  pinned: true,
                )
              ];
            },
            body: TabBarView(children: [
              GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: 20,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 9 / 14,
                  crossAxisCount: size.width > Breakpoints.lg ? 5 : 3,
                  crossAxisSpacing: Sizes.size2,
                  mainAxisSpacing: Sizes.size2,
                ),
                itemBuilder: (context, index) {
                  return Stack(children: [
                    AspectRatio(
                      aspectRatio: 9 / 14,
                      child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: "assets/images/placeholder.jpeg",
                          image:
                              "https://explorethecanyon.com/wp-content/uploads/2018/01/Secrets-Image-1lr.jpg"),
                    ),
                    Positioned.directional(
                      textDirection: TextDirection.ltr,
                      bottom: Sizes.size10,
                      start: Sizes.size10,
                      child: Row(
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.white,
                            size: Sizes.size14,
                          ),
                          Gaps.h5,
                          Text(
                            "4.1M",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ]);
                },
              ),
              const Center(
                child: Text("Page 2"),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
