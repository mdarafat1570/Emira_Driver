import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ovoride_driver/core/utils/style.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_images.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../data/controller/ride/ride_details/ride_details_controller.dart';
import '../../../components/buttons/rounded_button.dart';

class PaymentReceiveDialog extends StatelessWidget {
  const PaymentReceiveDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideDetailsController>(
      builder: (controller) => Dialog(
        backgroundColor: MyColor.cardBgColor,
        insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.space40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 0, bottom: Dimensions.space15, left: Dimensions.space15, right: Dimensions.space15),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: MyColor.cardBgColor, borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Lottie.asset(MyImages.receivePayment, height: 250),
                    Column(
                      children: [
                        Text(MyStrings.pleaseReceivePayment.tr, style: semiBoldLarge.copyWith(color: MyColor.highPriorityPurpleColor, fontSize: 16), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2),
                        const SizedBox(height: 8),
                        Text(MyStrings.pleaseReceivePaymentSubtitle.tr, style: regularSmall.copyWith(color: MyColor.getTextColor()), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 4),
                      ],
                    ),
                    const SizedBox(height: Dimensions.space15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RoundedButton(
                              isLoading: controller.isAcceptPaymentBtnLoading,
                              text: MyStrings.paymentReceived.tr,
                              press: () {
                                controller.acceptPaymentRide(controller.ride.id ?? '', context);
                              },
                              horizontalPadding: 3,
                              verticalPadding: 15,
                              color: MyColor.primaryColor,
                              textColor: MyColor.colorWhite,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
