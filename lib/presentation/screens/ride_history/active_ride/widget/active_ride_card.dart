import 'package:ovoride_driver/core/helper/date_converter.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_icons.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/core/utils/util.dart';
import 'package:ovoride_driver/data/controller/ride/accept_ride/active_ride_controller.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:ovoride_driver/presentation/components/buttons/icon_button.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/divider/custom_spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/presentation/components/timeline/custom_timeLine.dart';

import 'package:ovoride_driver/presentation/screens/ride_history/active_ride/widget/pick_up_bottom_sheet.dart';

class ActiveRidesCard extends StatelessWidget {
  bool isActive;
  String currency;
  String imageUrl;
  RideModel ride;
  ActiveRidesCard({
    super.key,
    required this.isActive,
    required this.currency,
    required this.imageUrl,
    required this.ride,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActiveRideController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: MyColor.getCardBgColor(),
          borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
          boxShadow: MyUtils.getCardShadow(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(MyStrings.ridePlace.tr, style: regularDefault.copyWith(fontSize: 16)),
                Text("$currency${StringConverter.formatNumber(ride.amount ?? '0')}", style: boldLarge.copyWith(fontSize: 16, fontWeight: FontWeight.w700, color: MyColor.rideTitle)),
              ],
            ),
            const SizedBox(height: Dimensions.space20),
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.rideDetailsScreen, arguments: ride.id.toString());
              },
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
                        ride.pickupLocation ?? '',
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
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
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
                        ride.destination ?? '',
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
            ),
            spaceDown(Dimensions.space10),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: MyColor.bodyTextBgColor,
                    borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        MyStrings.rideInProgress.tr,
                        style: boldDefault.copyWith(color: MyColor.bodyText),
                      ),
                      Text(
                        DateConverter.estimatedDate(
                          DateTime.tryParse('${ride.createdAt}') ?? DateTime.now(),
                        ),
                        style: boldDefault.copyWith(color: MyColor.colorGrey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Dimensions.space20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomIconButton(
                        name: MyStrings.message.tr,
                        icon: MyIcons.messageIcon,
                        iconColor: MyColor.rideTitle,
                        isOutline: true,
                        isSvg: true,
                        press: () {
                          Get.toNamed(RouteHelper.rideMessageScreen, arguments: [ride.id.toString(), ride.user?.getFullName(), ride.status.toString()]);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: Dimensions.space10,
                    ),
                    Expanded(
                      child: CustomIconButton(
                        name: MyStrings.call.tr,
                        icon: MyIcons.callIcon,
                        iconColor: MyColor.rideTitle,
                        isSvg: true,
                        isOutline: true,
                        press: () {
                          MyUtils.launchPhone(ride.user?.mobile ?? '');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: Dimensions.space10,
                ),
                if (ride.paymentStatus == "2") ...[
                  RoundedButton(
                    text: MyStrings.rideCompleted,
                    press: () {
                      controller.acceptPaymentRide(ride.id.toString());
                    },
                    textColor: MyColor.getRideTitleColor(),
                    textStyle: regularDefault.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontLarge, fontWeight: FontWeight.bold),
                  ),
                ] else if (ride.isRunning == "1") ...[
                  RoundedButton(
                    text: MyStrings.endRide.tr,
                    press: () {
                      controller.endRide(ride.id.toString());
                    },
                    textColor: MyColor.getRideTitleColor(),
                    textStyle: regularDefault.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontLarge, fontWeight: FontWeight.bold),
                  ),
                ] else ...[
                  RoundedButton(
                    text: MyStrings.pickupPassenger.tr,
                    press: () {
                      CustomBottomSheet(
                        child: PickUpBottomSheet(
                          ride: ride,
                          isFromActiveRide: true,
                        ),
                      ).customBottomSheet(context);
                    },
                    textColor: MyColor.getRideTitleColor(),
                    textStyle: regularDefault.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontLarge, fontWeight: FontWeight.bold),
                  ),
                ]
              ],
            ),
            const SizedBox(height: Dimensions.space10),
          ],
        ),
      );
    });
  }
}
