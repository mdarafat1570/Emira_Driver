import 'package:flutter/material.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/presentation/components/divider/custom_spacer.dart';
import 'package:ovoride_driver/presentation/components/image/my_network_image_widget.dart';

class VehicleServiceWidget extends StatelessWidget {
  final bool isSelected;
  final String image, name;
  const VehicleServiceWidget({super.key, this.isSelected = false, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        margin: const EdgeInsets.only(right: 8),
        width: Dimensions.space50 * 1.8,
        decoration: BoxDecoration(
          color: MyColor.colorWhite,
          borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
          border: isSelected ? Border.all(color: MyColor.primaryColor, width: 1.5) : Border.all(color: MyColor.colorGrey2, width: 1.2),
        ),
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyImageWidget(imageUrl: image, height: 60, width: 60, radius: 10),
              spaceDown(Dimensions.space10),
              FittedBox(
                child: Text(
                  name,
                  style: regularDefault.copyWith(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
