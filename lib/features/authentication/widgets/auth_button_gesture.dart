/// code challenge: implementing ontab naviagtor push inside the auth button.
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class AuthButtonGesture extends StatelessWidget {
  final String text;
  final FaIcon icon;
  final Widget screen;

  const AuthButtonGesture({
    super.key,
    required this.text,
    required this.icon,
    required this.screen,
  });

  void onTap(BuildContext context, screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
    // print("a");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context, screen),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: Sizes.size1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Sizes.size14),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: icon,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: Sizes.size16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
