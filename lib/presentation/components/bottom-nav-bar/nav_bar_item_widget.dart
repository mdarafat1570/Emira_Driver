import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/my_color.dart';
import '../../../core/utils/style.dart';

class NavBarItem extends StatelessWidget {
  final String imagePath;
  final int index;
  final String label;
  final VoidCallback press;
  final bool isSelected;

  const NavBarItem({super.key, required this.imagePath, required this.index, required this.label, required this.isSelected, required this.press});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(color: isSelected ? MyColor.primaryColor.withValues(alpha: .2) : MyColor.colorWhite, borderRadius: BorderRadius.circular(50)),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  imagePath,
                  width: 16,
                  height: 16,
                  color: isSelected ? MyColor.primaryColor : MyColor.lightGrey.withValues(alpha: .7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label.tr,
                textAlign: TextAlign.center,
                style: mediumSmall.copyWith(color: isSelected ? MyColor.primaryColor : MyColor.lightGrey.withValues(alpha: .7)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}
