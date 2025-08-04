import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/controller/dashboard/dashboard_controller.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/data/services/api_client.dart';
import 'package:ovoride_driver/presentation/components/image/my_network_image_widget.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovoride_driver/presentation/components/timeline/custom_timeLine.dart';
import '../../../core/helper/string_format_helper.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/style.dart';
import '../../screens/drawer/drawer_user_info_card.dart';
import '../buttons/rounded_button.dart';
import '../divider/custom_spacer.dart';

class CustomNewRideDialog {
  static void newRide({
    required RideModel ride,
    required String currency,
    required String currencySym,
    required VoidCallback onBidClick,
    required DashBoardController dashboardController,
    VoidCallback? reject,
    int duration = 90,
  }) {
    if (Get.context == null) {
      Get.rawSnackbar(
        progressIndicatorBackgroundColor: MyColor.transparentColor,
        progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(Colors.transparent),
        messageText: messageText(
          ride: ride,
          currency: currency,
          currencySym: currencySym,
          onBidClick: onBidClick,
          dashboardController: dashboardController,
          reject: reject,
        ),
        dismissDirection: DismissDirection.horizontal,
        snackPosition: SnackPosition.TOP,
        backgroundColor: MyColor.colorWhite,
        borderRadius: 4,
        margin: Get.isSnackbarOpen ? const EdgeInsets.only(top: Dimensions.space30) : const EdgeInsets.all(Dimensions.space10),
        padding: const EdgeInsets.all(Dimensions.space8),
        duration: Duration(seconds: duration),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeIn,
        showProgressIndicator: true,
        leftBarIndicatorColor: MyColor.transparentColor,
        animationDuration: const Duration(seconds: 1),
        borderColor: MyColor.transparentColor,
        reverseAnimationCurve: Curves.easeOut,
        borderWidth: 2,
      );
    } else {
      Flushbar(
        borderColor: MyColor.primaryColor,
        blockBackgroundInteraction: true,
        barBlur: 5,
        messageText: messageText(
          ride: ride,
          currency: currency,
          currencySym: currencySym,
          onBidClick: onBidClick,
          dashboardController: dashboardController,
          reject: reject,
        ),
        showProgressIndicator: true,
        margin: Get.isSnackbarOpen ? const EdgeInsets.only(top: Dimensions.space30) : const EdgeInsets.all(Dimensions.space10),
        borderRadius: BorderRadius.circular(Dimensions.cardRadius),
        backgroundColor: MyColor.bodyTextBgColor,
        duration: Duration(seconds: duration),
        leftBarIndicatorColor: MyColor.primaryColor.withValues(alpha: 0.05),
        forwardAnimationCurve: Curves.fastEaseInToSlowEaseOut,
        isDismissible: true,
        flushbarPosition: FlushbarPosition.TOP,
        boxShadows: [
          BoxShadow(color: Color.fromARGB(20, 0, 0, 0), offset: Offset(0, -3), blurRadius: 1),
          BoxShadow(color: Color.fromARGB(20, 0, 0, 0), offset: Offset(0, 3), blurRadius: 1),
        ],
      ).show(Get.context!);
    }
  }

  static Widget messageText({
    required RideModel ride,
    required String currency,
    required String currencySym,
    required VoidCallback onBidClick,
    required DashBoardController dashboardController,
    VoidCallback? reject,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(RouteHelper.userReviewScreen, arguments: ride.user?.id);
          },
          child: DrawerUserCard(
            fullName: '${ride.user?.getFullName()}',
            username: '${ride.user?.username}',
            subtitle: "",
            rightWidget: Column(
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
                Text(
                  "$currencySym${StringConverter.formatNumber(ride.amount ?? '0')}",
                  overflow: TextOverflow.ellipsis,
                  style: boldExtraLarge.copyWith(color: MyColor.primaryColor),
                ),
              ],
            ),
            imgWidget: MyImageWidget(
              imageUrl: '${dashboardController.userImagePath}/${ride.user?.avatar}',
              boxFit: BoxFit.cover,
              height: 40,
              width: 40,
              radius: 20,
              isProfile: true,
            ),
            imgHeight: 40,
            imgWidth: 40,
          ),
        ),
        const SizedBox(height: Dimensions.space10),
        destination(pickupLocation: ride.pickupLocation ?? '', destination: ride.destination ?? ''),
        const SizedBox(height: Dimensions.space10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Dimensions.space10),
          decoration: BoxDecoration(color: MyColor.bodyTextBgColor, borderRadius: BorderRadius.circular(Dimensions.space5)),
          child: Center(
            child: Text(
              MyStrings.recommendedPrice.rKv({
                "priceKey": "$currencySym${StringConverter.formatNumber(ride.recommendAmount.toString())}",
                "distanceKey": "${ride.distance} ${MyStrings.km.tr}",
              }).tr,
              style: regularDefault.copyWith(color: MyColor.bodyText),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        spaceDown(Dimensions.space10),
        Container(
          decoration: BoxDecoration(shape: BoxShape.rectangle, color: MyColor.primaryColor.withValues(alpha: 0.05)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Get.find<ApiClient>().getCurrency(isSymbol: true),
                style: mediumExtraLarge.copyWith(
                  fontSize: 30,
                  color: MyColor.primaryColor,
                ),
              ),
              IntrinsicWidth(
                child: TextFormField(
                  onChanged: (val) {},
                  expands: false,
                  controller: dashboardController.amountController,
                  scrollPadding: EdgeInsets.zero,
                  inputFormatters: [LengthLimitingTextInputFormatter(8)],
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.space10),
                    border: InputBorder.none,
                    hintText: dashboardController.amountController.text.isNotEmpty ? '0' : '0.0',
                    hintStyle: mediumDefault.copyWith(
                      fontSize: 30,
                      color: dashboardController.amountController.text.isNotEmpty ? MyColor.primaryColor : Colors.grey.shade500,
                    ),
                  ),
                  style: mediumDefault.copyWith(
                    fontSize: 30,
                    color: dashboardController.amountController.text.isNotEmpty ? MyColor.primaryColor : Colors.grey.shade500,
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
        if (ride.note != null) ...[
          spaceDown(Dimensions.space10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Dimensions.space10),
            decoration: BoxDecoration(color: MyColor.bodyTextBgColor, borderRadius: BorderRadius.circular(Dimensions.space5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${MyStrings.riderInstruction.tr}:",
                  style: boldDefault.copyWith(color: MyColor.bodyText),
                  textAlign: TextAlign.center,
                ),
                spaceSide(Dimensions.space7),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: Dimensions.space100),
                  child: SingleChildScrollView(
                    child: Text(
                      ride.note ?? "",
                      style: regularDefault.copyWith(color: MyColor.bodyText),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
          ),
          spaceDown(Dimensions.space10),
        ] else ...[
          spaceDown(Dimensions.space20),
        ],
        const SizedBox(height: Dimensions.space20),
        Row(
          children: [
            Expanded(
                child: RoundedButton(
              text: MyStrings.decline.tr,
              press: () {
                if (reject != null) {
                  reject();
                } else {
                  Get.back();
                }
              },
              color: MyColor.colorGrey,
              isColorChange: true,
            )),
            const SizedBox(width: Dimensions.space10),
            Expanded(
                child: GetBuilder<DashBoardController>(
              builder: (controller) => RoundedButton(
                text: MyStrings.bidNOW.tr,
                isLoading: dashboardController.isSendLoading,
                press: () {
                  double enterValue = StringConverter.formatDouble(controller.amountController.text);
                  double min = StringConverter.formatDouble(ride.minAmount ?? '0.0');
                  double max = StringConverter.formatDouble(ride.maxAmount ?? '0.0');

                  if (enterValue < max + 1 && enterValue >= min) {
                    controller.updateMainAmount(enterValue);
                    onBidClick();
                  } else {
                    CustomSnackBar.error(
                      errorList: ['${MyStrings.pleaseEnterMinimum.tr} ${controller.currencySym}${StringConverter.formatNumber(ride.minAmount ?? '0')} to ${controller.currencySym}${StringConverter.formatNumber(ride.maxAmount ?? '')}'],
                    );
                  }
                },
                color: MyColor.primaryColor,
                isColorChange: true,
              ),
            )),
          ],
        ),
      ],
    );
  }

  static CustomTimeLine destination({required String pickupLocation, required String destination}) {
    return CustomTimeLine(
      indicatorPosition: 0.1,
      dashColor: MyColor.colorYellow,
      firstWidget: Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 10),
        child: Column(
          children: [
            Text(pickupLocation.toTitleCase(), style: regularSmall.copyWith(color: MyColor.getRideSubTitleColor()), maxLines: 2, overflow: TextOverflow.ellipsis),
            SizedBox(height: 8),
          ],
        ),
      ),
      secondWidget: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(destination.toTitleCase(), style: regularSmall.copyWith(color: MyColor.getRideSubTitleColor()), maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
