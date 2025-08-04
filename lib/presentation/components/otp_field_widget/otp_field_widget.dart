import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/style.dart';

class OTPFieldWidget extends StatelessWidget {
  final Color textcolor, activeColor, inActiveColor;
  final bool fromExam;
  final int length;
  final TextEditingController? tController; // Changed to optional

  const OTPFieldWidget({
    super.key,
    this.tController, // Made it optional
    required this.onChanged,
    this.textcolor = MyColor.colorBlack,
    this.activeColor = MyColor.screenBgColor,
    this.inActiveColor = MyColor.borderColor,
    this.fromExam = false,
    this.length = 6,
  });

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10),
      child: PinCodeTextField(
        appContext: context,
        pastedTextStyle: regularDefault.copyWith(color: MyColor.getTextColor()),
        length: 6,
        textStyle: regularDefault.copyWith(color: MyColor.getTextColor()),
        obscureText: false,
        obscuringCharacter: '*',
        blinkWhenObscuring: false,
        animationType: AnimationType.slide,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8),
          borderWidth: 1,
          fieldHeight: 40,
          fieldWidth: 40,
          inactiveColor: MyColor.getTextFieldDisableBorder(),
          inactiveFillColor: MyColor.getScreenBgColor(),
          activeFillColor: MyColor.getScreenBgColor(),
          activeColor: MyColor.getPrimaryColor(),
          selectedFillColor: MyColor.getScreenBgColor(),
          selectedColor: MyColor.getPrimaryColor(),
        ),
        cursorColor: MyColor.colorBlack,
        animationDuration: const Duration(milliseconds: 100),
        enableActiveFill: true,
        keyboardType: TextInputType.number,
        beforeTextPaste: (text) {
          return true;
        },
        onChanged: (value) => onChanged!(value),
      ),
    );
  }
}
