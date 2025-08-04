import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';

import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/ride/ride_details/ride_details_controller.dart';
import 'package:ovoride_driver/presentation/components/divider/custom_spacer.dart';
import 'package:ovoride_driver/presentation/components/timeline/custom_timeLine.dart';

class RideDestination extends StatelessWidget {
  const RideDestination({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideDetailsController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15),
        child: CustomTimeLine(
          indicatorPosition: 0.1,
          dashColor: MyColor.colorYellow,
          firstWidget: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    MyStrings.pickUpLocation.tr,
                    style: boldLarge.copyWith(color: MyColor.rideTitle, fontSize: Dimensions.fontLarge - 1, fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                spaceDown(Dimensions.space5),
                Text(
                  controller.ride.pickupLocation ?? '',
                  style: regularDefault.copyWith(
                    color: MyColor.getRideSubTitleColor(),
                    fontSize: Dimensions.fontSmall,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                spaceDown(Dimensions.space15),
              ],
            ),
          ),
          secondWidget: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    MyStrings.destination.tr,
                    style: boldLarge.copyWith(color: MyColor.rideTitle, fontSize: Dimensions.fontLarge - 1, fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: Dimensions.space5 - 1,
                ),
                Text(
                  controller.ride.destination ?? '',
                  style: regularDefault.copyWith(
                    color: MyColor.getRideSubTitleColor(),
                    fontSize: Dimensions.fontSmall,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
