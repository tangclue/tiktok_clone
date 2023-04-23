import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_form_screen.dart';
import 'package:tiktok_clone/features/authentication/viewmodel/social_auth_view_model.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';

class LoginScreen extends ConsumerWidget {
  static String routeName = "/login";
  static String routeURL = "/login";
  const LoginScreen({Key? key}) : super(key: key);

  void _onSignUpTap(BuildContext context) {
    context.pop();
  }

  void _onEmailLoginTap(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginFormScreen(),
        ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size40),
          child: Column(
            children: [
              Gaps.v80,
              Text("Log in to TikTok",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.red)),
              Gaps.v20,
              const Opacity(
                opacity: 0.7,
                child: Text(
                  "Manage your account, check notifications,"
                  " comment on videos, and more.",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Gaps.v40,
              GestureDetector(
                onTap: () => _onEmailLoginTap(context),
                child: const AuthButton(
                    icon: FaIcon(FontAwesomeIcons.user),
                    text: "Use email & password"),
              ),
              Gaps.v16,
              GestureDetector(
                onTap: () =>
                    ref.read(socialAuthProvider.notifier).githubSignIn(context),
                child: const AuthButton(
                  icon: FaIcon(FontAwesomeIcons.github),
                  text: "Continue with github",
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 2,
        color: Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.size32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              Gaps.h5,
              GestureDetector(
                onTap: () => _onSignUpTap(context),
                child: Text(
                  "Sign up",
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
  }
}
