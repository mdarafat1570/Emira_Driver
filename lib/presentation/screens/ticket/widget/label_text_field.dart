import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/style.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';

class LabelTextField extends StatefulWidget {
  final bool needOutline;
  final String labelText;
  final String? hintText;
  final Function? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final FormFieldValidator? validator;
  final TextInputType? textInputType;
  final bool isEnable;
  final bool isPassword;
  final TextInputAction inputAction;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final int maxLines;
  final bool isRequired;
  final bool isAttachment;
  final bool hideLabel;
  final double radius;
  final EdgeInsetsGeometry contentPadding;
  final Color fillColor;
  final Color labelTextColor;
  final Color hintTextColor;
  final TextStyle? labelTextStyle;
  final TextStyle? inputTextStyle;

  const LabelTextField({
    super.key,
    this.needOutline = true,
    required this.labelText,
    this.readOnly = false,
    required this.onChanged,
    this.hintText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.validator,
    this.textInputType,
    this.isEnable = true,
    this.isPassword = false,
    this.isAttachment = false,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.isRequired = false,
    this.hideLabel = false,
    this.radius = Dimensions.largeRadius,
    this.suffixIcon,
    this.prefixIcon,
    this.contentPadding = const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
    this.fillColor = Colors.transparent,
    this.hintTextColor = MyColor.hintTextColor,
    this.labelTextColor = MyColor.labelTextColor,
    this.labelTextStyle,
    this.inputTextStyle,
  });

  @override
  State<LabelTextField> createState() => _LabelTextFieldState();
}

class _LabelTextFieldState extends State<LabelTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return widget.isAttachment
        ? TextFormField(
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            style: widget.inputTextStyle ?? regularDefault.copyWith(color: MyColor.getTextColor()),
            cursorColor: MyColor.getTextColor(),
            controller: widget.controller,
            autofocus: false,
            textInputAction: widget.inputAction,
            enabled: widget.isEnable,
            focusNode: widget.focusNode,
            validator: widget.validator,
            keyboardType: widget.textInputType,
            obscureText: widget.isPassword ? obscureText : false,
            decoration: InputDecoration(
              contentPadding: widget.contentPadding,
              hintText: widget.hintText?.tr ?? '',
              hintStyle: regularDefault.copyWith(color: widget.hintTextColor),
              fillColor: widget.fillColor,
              filled: true,
              border: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldDisableBorder()), borderRadius: BorderRadius.circular(widget.radius)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldDisableBorder()), borderRadius: BorderRadius.circular(widget.radius)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 0.5, color: MyColor.getTextFieldDisableBorder()),
                borderRadius: BorderRadius.circular(widget.radius),
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPassword
                  ? UnconstrainedBox(
                      child: Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        child: InkWell(
                          focusColor: MyColor.colorGrey.withValues(alpha: 0.01),
                          autofocus: false,
                          canRequestFocus: false,
                          onTap: _toggle,
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.space5),
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: MyColor.primaryColor),
                            height: 25,
                            width: 25,
                          ),
                        ),
                      ),
                    )
                  : widget.suffixIcon,
            ),
            onFieldSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus) : null,
            onChanged: (text) => widget.onChanged!(text),
          )
        : SizedBox();
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
