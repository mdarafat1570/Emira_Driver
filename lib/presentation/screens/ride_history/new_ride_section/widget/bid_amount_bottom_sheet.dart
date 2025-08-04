import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/debouncer.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/ride/new_ride/new_ride_controller.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/presentation/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/divider/custom_spacer.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovoride_driver/presentation/components/text/header_text.dart';

class BidAmountBottomSheet extends StatefulWidget {
  RideModel ride;
  Function onBtnPress;
  BidAmountBottomSheet({
    super.key,
    required this.ride,
    required this.onBtnPress,
  });

  @override
  State<BidAmountBottomSheet> createState() => _BidAmountBottomSheetState();
}

class _BidAmountBottomSheetState extends State<BidAmountBottomSheet> {
  bool isValid = false;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewRideController>(builder: (controller) {
      return Container(
        color: MyColor.colorWhite,
        child: Column(
          children: [
            const BottomSheetHeaderRow(),
            HeaderText(text: MyStrings.yourOfferAmount.tr, textStyle: boldLarge.copyWith(color: MyColor.getRideTitleColor(), fontWeight: FontWeight.bold, fontSize: Dimensions.fontOverLarge)),
            spaceDown(Dimensions.space15),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.space10),
                  decoration: BoxDecoration(color: MyColor.bodyTextBgColor, borderRadius: BorderRadius.circular(Dimensions.space5)),
                  child: Center(
                    child: Text(
                      MyStrings.recommendedPrice.rKv({
                        "priceKey": "${controller.defaultCurrencySymbol}${StringConverter.formatNumber(widget.ride.minAmount.toString())}",
                        "distanceKey": "${widget.ride.distance} ${MyStrings.km.tr}".tr,
                      }).tr,
                      style: regularDefault.copyWith(color: MyColor.bodyText),
                    ),
                  ),
                ),
                spaceDown(Dimensions.space20),
                Container(
                  decoration: BoxDecoration(shape: BoxShape.rectangle, color: MyColor.primaryColor.withValues(alpha: 0.05)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.defaultCurrencySymbol,
                        style: mediumExtraLarge.copyWith(
                          fontSize: 50,
                          color: MyColor.primaryColor,
                        ),
                      ),
                      IntrinsicWidth(
                        child: TextFormField(
                          onChanged: (val) {
                            MyDebouncer(delay: const Duration(milliseconds: 500)).run(() {
                              if (val.isNotEmpty) {
                                double enterValue = double.tryParse(val) ?? 0.0;
                                if (enterValue.toPrecision(0) >= (double.tryParse(widget.ride.minAmount.toString()) ?? 0) && (enterValue.toPrecision(0)) < (double.tryParse(widget.ride.maxAmount.toString()) ?? 0)) {
                                  printX('valid ${widget.ride.minAmount} ${widget.ride.maxAmount}');
                                  controller.updateMainAmount(enterValue);
                                } else {
                                  printX('not valid');
                                }
                                setState(() {});
                              }
                            });
                          },
                          expands: false,
                          controller: controller.amountController,
                          scrollPadding: EdgeInsets.zero,
                          inputFormatters: [LengthLimitingTextInputFormatter(8)],
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.space20),
                            border: InputBorder.none,
                            hintText: controller.amountController.text.isNotEmpty ? '0' : '0.0',
                            hintStyle: mediumDefault.copyWith(
                              fontSize: 50,
                              color: controller.amountController.text.isNotEmpty ? MyColor.primaryColor : Colors.grey.shade500,
                            ),
                          ),
                          style: mediumDefault.copyWith(
                            fontSize: 50,
                            color: controller.amountController.text.isNotEmpty ? MyColor.primaryColor : Colors.grey.shade500,
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          selectionHeightStyle: BoxHeightStyle.includeLineSpacingTop,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                spaceDown(Dimensions.space40),
                RoundedButton(
                  text: MyStrings.done.tr.toUpperCase(),
                  textStyle: boldDefault.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontLarge),
                  press: () {
                    double enterValue = double.tryParse(controller.amountController.text) ?? 0.0;
                    if (enterValue.toPrecision(0) >= (double.tryParse(widget.ride.minAmount.toString()) ?? 0) && (enterValue.toPrecision(0)) < (double.tryParse(widget.ride.maxAmount.toString()) ?? 0)) {
                      Get.back();
                      widget.onBtnPress();
                    } else {
                      CustomSnackBar.error(
                        errorList: ['${MyStrings.pleaseEnterMinimum.tr} ${controller.defaultCurrencySymbol}${StringConverter.formatNumber(widget.ride.minAmount ?? '')} ${MyStrings.to.tr} ${controller.defaultCurrencySymbol}${StringConverter.formatNumber(widget.ride.maxAmount ?? '')}'],
                      );
                    }
                  },
                ),
                spaceDown(Dimensions.space20),
              ],
            )
          ],
        ),
      );
    });
  }
}
