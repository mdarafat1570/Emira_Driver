import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/ride/accepted_ride/accepted_ride_controller.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/presentation/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/text-form-field/custom_text_field.dart';

class CancelBottomSheet extends StatelessWidget {
  final RideModel ride;
  final void Function()? press;
  const CancelBottomSheet({super.key, required this.ride, this.press});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AcceptedRideController>(builder: (controller) {
      return Column(
        children: [
          const BottomSheetHeaderRow(),
          const SizedBox(height: Dimensions.space10),
          CustomTextField(
            labelTextStyle: boldDefault.copyWith(),
            animatedLabel: false,
            needOutlineBorder: true,
            fillColor: MyColor.colorGrey.withValues(alpha: 0.1),
            labelText: MyStrings.cancelReason.tr,
            hintText: MyStrings.rideCancelledTitle,
            maxLines: 6,
            controller: controller.cancelReasonController,
            onChanged: (c) {},
          ),
          const SizedBox(height: Dimensions.space20),
          RoundedButton(
              text: MyStrings.submit.tr,
              color: MyColor.primaryButtonColor,
              isLoading: controller.isCancelLoading,
              press: () {
                if (press != null) {
                  press!();
                } else {
                  if (controller.cancelReasonController.text.isNotEmpty) {
                    controller.cancelRide(ride.id ?? '-1');
                  }
                }
              }),
          const SizedBox(height: Dimensions.space10),
        ],
      );
    });
  }
}
