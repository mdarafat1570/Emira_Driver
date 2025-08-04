import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/core/utils/util.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/dotted_border/dotted_border.dart';
import 'package:ovoride_driver/presentation/components/image/my_network_image_widget.dart';

import '../../../../core/helper/date_converter.dart';
import '../../../components/divider/custom_spacer.dart';
import '../../../components/timeline/custom_timeLine.dart';

class AcceptedRideCard extends StatelessWidget {
  bool isActive;
  String currency;
  String imageUrl;
  RideModel ride;
  VoidCallback cancelCallback;
  bool hideCancelBtn;
  AcceptedRideCard({
    super.key,
    required this.isActive,
    required this.currency,
    required this.imageUrl,
    required this.ride,
    required this.cancelCallback,
    this.hideCancelBtn = false,
  });

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Row(
                  children: [
                    MyImageWidget(imageUrl: imageUrl, height: 45, width: 45, radius: 20, isProfile: true),
                    const SizedBox(width: Dimensions.space10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${ride.user?.firstname} ${ride.user?.lastname}".toTitleCase(),
                            overflow: TextOverflow.ellipsis,
                            style: boldMediumLarge,
                          ),
                          spaceDown(Dimensions.space5),
                          FittedBox(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${ride.duration}, ${ride.distance} ${MyStrings.km.tr}",
                                  style: boldDefault.copyWith(color: MyColor.primaryColor, fontSize: Dimensions.fontDefault, fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              spaceSide(Dimensions.space10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FittedBox(
                    child: Row(
                      children: [
                        Icon(Icons.group, color: MyColor.primaryColor),
                        SizedBox(width: Dimensions.space2),
                        Text(
                          "${ride.numberOfPassenger}",
                          overflow: TextOverflow.ellipsis,
                          style: boldLarge.copyWith(fontSize: Dimensions.fontExtraLarge, fontWeight: FontWeight.w900, color: MyColor.primaryColor),
                        ),
                      ],
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      "$currency${StringConverter.formatNumber(ride.amount ?? '0')}",
                      overflow: TextOverflow.ellipsis,
                      style: boldLarge.copyWith(fontSize: Dimensions.fontExtraLarge, fontWeight: FontWeight.w900, color: MyColor.rideTitle),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space20),
          CustomTimeLine(
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
                  const SizedBox(height: Dimensions.space5 - 1),
                  Text(
                    ride.destination ?? '',
                    style: regularDefault.copyWith(color: MyColor.getRideSubTitleColor(), fontSize: Dimensions.fontSmall),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          spaceDown(Dimensions.space10),
          const DottedLine(),
          spaceDown(Dimensions.space15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MyColor.bodyTextBgColor,
              borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: boldDefault.copyWith(color: MyColor.bodyText),
                    children: <TextSpan>[
                      TextSpan(
                        text: MyStrings.amount.tr,
                      ),
                      const TextSpan(
                        text: ' : ',
                      ),
                      TextSpan(
                        text: "$currency${StringConverter.formatNumber(ride.amount ?? '0')}",
                        style: boldDefault.copyWith(color: MyColor.rideTitle, fontSize: Dimensions.fontMedium),
                      ),
                    ],
                  ),
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
          hideCancelBtn == false ? const SizedBox(height: Dimensions.space20) : SizedBox(),
          if (hideCancelBtn == false) ...[
            RoundedButton(
              color: MyColor.redCancelTextColor,
              text: MyStrings.cancel.tr,
              press: () {
                cancelCallback();
              },
            ),
          ]
        ],
      ),
    );
  }
}
