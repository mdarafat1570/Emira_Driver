import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/presentation/components/divider/custom_spacer.dart';
import 'package:ovoride_driver/presentation/components/image/my_network_image_widget.dart';

class VehicleBrandWidget extends StatelessWidget {
  final bool isSelected;
  final String image, name;
  const VehicleBrandWidget({super.key, this.isSelected = false, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 700),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        margin: const EdgeInsets.only(right: 8),
        width: Dimensions.space50 * 1.8,
        decoration: BoxDecoration(
          color: MyColor.colorWhite,
          // borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
          border: isSelected ? Border.all(color: MyColor.primaryColor, width: 1.5) : Border.all(color: MyColor.colorGrey2, width: 1.2),
        ),
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyImageWidget(
                imageUrl: image,
                height: 40,
                width: 60,
                radius: 1,
                boxFit: BoxFit.fill,
              ),
              spaceDown(Dimensions.space10),
              FittedBox(child: Text(name, style: regularDefault.copyWith()))
            ],
          ),
        ),
      ).animate().moveX(),
    );
  }
}
