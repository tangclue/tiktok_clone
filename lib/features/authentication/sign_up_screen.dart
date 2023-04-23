import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/authentication/viewmodel/social_auth_view_model.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';

import '../../generated/l10n.dart';

class SignUpScreen extends ConsumerWidget {
  static const routeURL = "/";
  static const routeName = "signUp";
  const SignUpScreen({Key? key}) : super(key: key);

  void _onLoginTap(BuildContext context) async {
    context.push(LoginScreen.routeName);
  }

  void _onEmailTap(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UsernameScreen(),
        ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OrientationBuilder(builder: (context, orientation) {
      print(orientation);
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size40),
            child: Column(
              children: [
                Gaps.v80,
                Text(
                  S.of(context).signUpTitle("TikTok", DateTime.now()),
                  style: const TextStyle(
                      fontSize: Sizes.size24, fontWeight: FontWeight.w800),
                ),
                Gaps.v20,
                Opacity(
                  opacity: 0.8,
                  child: Text(
                    S.of(context).signUpSubtitle(2),
                    style: const TextStyle(
                      fontSize: Sizes.size16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Gaps.v40,
                if (orientation == Orientation.portrait) ...[
                  GestureDetector(
                    onTap: () => _onEmailTap(context),
                    child: AuthButton(
                        icon: const FaIcon(FontAwesomeIcons.user),
                        // screen: EmailScreen(),
                        text: S.of(context).emailPasswordButton),
                  ),
                  Gaps.v16,
                  GestureDetector(
                    onTap: () => ref
                        .read(socialAuthProvider.notifier)
                        .githubSignIn(context),
                    child: const AuthButton(
                      icon: FaIcon(FontAwesomeIcons.github),
                      // screen: EmailScreen(),
                      text: "Continue with Github",
                    ),
                  ),
                ],
                if (orientation == Orientation.landscape)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _onEmailTap(context),
                          child: const AuthButton(
                              icon: FaIcon(FontAwesomeIcons.user),
                              // screen: EmailScreen(),
                              text: "Use email & password"),
                        ),
                      ),
                      Gaps.h16,
                      Expanded(
                        child: GestureDetector(
                          onTap: () => ref
                              .read(socialAuthProvider.notifier)
                              .githubSignIn(context),
                          child: const AuthButton(
                            icon: FaIcon(FontAwesomeIcons.github),
                            // screen: EmailScreen(),
                            text: "Continue with Github",
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Sizes.size32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.of(context).alreadyHaveAnAccount),
                Gaps.h5,
                GestureDetector(
                  onTap: () => _onLoginTap(context),
                  child: Text(
                    S.of(context).logIn("female"),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
