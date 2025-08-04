import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/ride/ride_details/ride_details_controller.dart';

class RideDetailsPaymentSection extends StatelessWidget {
  const RideDetailsPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideDetailsController>(builder: (controller) {
      if (controller.isCashPaymentRequest) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.onShowPaymentDialog(context);
        });
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          controller.isCashPaymentRequest
              ? SizedBox()
              : Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: EdgeInsets.only(top: 0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      children: [
                        SizedBox(width: context.width * .7, child: Center(child: SpinKitDoubleBounce(color: MyColor.primaryColor, size: 35.0))),
                        SizedBox(height: 6),
                        Text(MyStrings.waitForUserPayment.tr, style: boldLarge.copyWith(fontSize: 15, color: MyColor.primaryColor)),
                      ],
                    ),
                  ),
                ),
        ],
      );
    });
  }
}
