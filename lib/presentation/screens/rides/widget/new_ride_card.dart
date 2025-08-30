import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/core/utils/util.dart';
import 'package:ovoride_driver/data/controller/ride/new_ride/new_ride_controller.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/dotted_border/dotted_border.dart';
import 'package:ovoride_driver/presentation/screens/ride_history/new_ride_section/widget/bid_amount_bottom_sheet.dart';

import '../../../../core/utils/my_images.dart';
import '../../../components/divider/custom_spacer.dart';
import '../../../components/timeline/custom_timeLine.dart';

class NewRideCard extends StatelessWidget {
  RideModel ride;

  String currency;
  NewRideCard({super.key, required this.ride, required this.currency});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewRideController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.only(
          bottom: 8,
        ),
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
                      Container(
                        decoration: BoxDecoration(
                            color: MyColor.borderColor.withValues(alpha: 0.5),
                            border: Border.all(
                              color: MyColor.borderColor,
                            ),
                            borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
                        child: Image.asset(
                          MyImages.defaultAvatar,
                          height: 45,
                          width: 45,
                        ),
                      ),
                      const SizedBox(
                        width: Dimensions.space10,
                      ),
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
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: Dimensions.fontExtraLarge,
                                        color: MyColor.colorYellow,
                                      ),
                                      const SizedBox(
                                        width: Dimensions.space2,
                                      ),
                                      Text(
                                        ride.user?.avgRating ?? '',
                                        style: boldDefault.copyWith(color: MyColor.getRideSubTitleColor(), fontSize: Dimensions.fontDefault, fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: Dimensions.space8,
                                  ),
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
                FittedBox(
                  child: Text(
                    "$currency${StringConverter.formatNumber(ride.amount ?? '0')}",
                    overflow: TextOverflow.ellipsis,
                    style: boldLarge.copyWith(fontSize: Dimensions.fontExtraLarge, fontWeight: FontWeight.w900, color: MyColor.rideTitle),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: Dimensions.space20,
            ),
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
            spaceDown(Dimensions.space10),
            const DottedLine(),
            spaceDown(Dimensions.space15),
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
                      Flexible(
                        child: Text(
                          MyStrings.recommendedPrice.rKv({"priceKey": '$currency${StringConverter.formatNumber(ride.recommendAmount ?? '0')}', 'distanceKey': '${ride.distance} ${MyStrings.km.tr}'.tr}),
                          style: boldDefault.copyWith(color: MyColor.bodyText),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Dimensions.space20),
                RoundedButton(
                  text: MyStrings.bidNOW,
                  press: () {
                    controller.updateMainAmount(double.tryParse(ride.amount.toString()) ?? 0);

                    CustomBottomSheet(
                        child: BidAmountBottomSheet(
                      ride: ride,
                      onBtnPress: () {
                        controller.createBid(ride.id ?? '-1');
                      },
                    )).customBottomSheet(context);
                  },
                  isLoading: controller.rideId == ride.id && controller.isSubmitLoading == true,
                  isColorChange: true,
                  verticalPadding: 15,
                  borderColor: MyColor.rideTitle,
                  textColor: MyColor.getRideTitleColor(),
                  isOutlined: true,
                  textStyle: regularDefault.copyWith(color: MyColor.getRideTitleColor(), fontSize: Dimensions.fontLarge, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              height: Dimensions.space10,
            ),
          ],
        ),
      );
    });
  }
}
