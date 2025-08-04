import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';

import '../../../core/utils/style.dart';

class RoundedButton extends StatelessWidget {
  final bool isColorChange;
  final String text;
  final VoidCallback press;
  final Color color;
  final Color? textColor;
  final double width;
  final double horizontalPadding;
  final double verticalPadding;
  final double cornerRadius;
  final bool isOutlined;
  final Widget? child;
  final TextStyle? textStyle;
  final bool isLoading;
  final Color borderColor; // Added for outlined button border color
  final bool isDisabled; // Added to handle disabled state

  const RoundedButton({
    super.key,
    this.isColorChange = false,
    this.width = 1,
    this.child,
    this.cornerRadius = 14,
    required this.text,
    required this.press,
    this.isOutlined = false,
    this.horizontalPadding = 30,
    this.verticalPadding = 14,
    this.color = MyColor.primaryColor,
    this.textColor = MyColor.colorWhite,
    this.textStyle,
    this.isLoading = false,
    this.borderColor = MyColor.primaryColor, // Default border color
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = child ??
        Text(
          text.tr,
          style: textStyle ?? regularDefault.copyWith(color: isColorChange ? textColor : MyColor.getPrimaryButtonTextColor(), fontSize: 14, fontWeight: FontWeight.bold),
        );

    return SizedBox(
      width: double.infinity,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isDisabled ? null : press,
              style: OutlinedButton.styleFrom(
                elevation: 0,
                side: BorderSide(color: borderColor), // Border color for outlined button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(cornerRadius),
                ),
                splashFactory: InkRipple.splashFactory,

                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
              ).copyWith(
                overlayColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return MyColor.borderColor.withValues(alpha: 0.2); // Set the splash color to red with 40% opacity
                  }
                  return Colors.transparent; // Make the splash color transparent when the button is not pressed
                }),
              ),
              child: isLoading ? const SpinKitFadingCircle(color: MyColor.primaryColor, size: 20) : buttonChild,
            )
          : ElevatedButton(
              onPressed: isDisabled ? null : press,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(cornerRadius),
                ),
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
              ),
              child: isLoading ? const SpinKitFadingCircle(color: MyColor.colorWhite, size: 20) : buttonChild,
            ),
    );
  }
}
