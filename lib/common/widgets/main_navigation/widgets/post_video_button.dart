import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/utils.dart';

import '../../../../constants/sizes.dart';

class PostVideoButton extends StatefulWidget {
  final bool inverted;
  const PostVideoButton({Key? key, required this.inverted}) : super(key: key);

  @override
  _PostVideoButtonState createState() => _PostVideoButtonState();
}

class _PostVideoButtonState extends State<PostVideoButton> {
  final bool _isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return GestureDetector(
      // onLongPress: _onLongPressedButton,
      // onLongPressUp: _onLongPressedUpButton,
      child: AnimatedOpacity(
        opacity: _isLongPressed ? 0.5 : 1,
        duration: const Duration(milliseconds: 100),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: 20,
              child: Container(
                height: 30,
                width: 25,
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size8),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(Sizes.size11)),
              ),
            ),
            Positioned(
              left: 20,
              child: Container(
                height: 30,
                width: 25,
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size8),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Sizes.size11)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color:
                      !widget.inverted || isDark ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.circular(Sizes.size8)),
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size11),
              child: Center(
                  child: FaIcon(
                FontAwesomeIcons.plus,
                color: !widget.inverted || isDark ? Colors.black : Colors.white,
                size: 18,
              )),
            )
          ],
        ),
      ),
    );
  }
}
