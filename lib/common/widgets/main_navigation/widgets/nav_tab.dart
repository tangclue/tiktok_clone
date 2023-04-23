import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/utils.dart';

import '../../../../constants/gaps.dart';

class NavTab extends StatelessWidget {
  const NavTab(
      {Key? key,
      required this.text,
      required this.isSelected,
      required this.icon,
      required this.onTap,
      required this.selectedIcon,
      required this.selectedIndex})
      : super(key: key);
  final String text;
  final bool isSelected;
  final IconData icon;
  final IconData selectedIcon;
  final Function onTap;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          color: selectedIndex == 0 || isDark ? Colors.black : Colors.white,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isSelected ? 1 : 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  isSelected ? selectedIcon : icon,
                  color: selectedIndex == 0 || isDark
                      ? Colors.white
                      : Colors.black,
                ),
                Gaps.v5,
                Text(
                  text,
                  style: TextStyle(
                      color: selectedIndex == 0 || isDark
                          ? Colors.white
                          : Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
