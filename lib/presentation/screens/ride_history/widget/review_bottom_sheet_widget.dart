import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_icons.dart';
import 'package:ovoride_driver/core/utils/my_images.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/ride/complete_ride/complete_ride_controller.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/presentation/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/divider/custom_divider.dart';
import 'package:ovoride_driver/presentation/components/image/custom_svg_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/presentation/components/text-form-field/custom_text_field.dart';

import '../../../../core/route/route.dart';

class ReviewBottomSheet extends StatelessWidget {
  AllRideController controller;
  RideModel ride;
  bool isFromRideDetails;

  ReviewBottomSheet({super.key, required this.controller, required this.ride, this.isFromRideDetails = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height / 1.5,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const BottomSheetHeaderRow(),
            Text(
              MyStrings.reviewForUser,
              style: regularDefault.copyWith(fontSize: Dimensions.fontOverLarge - 1),
            ),
            const SizedBox(
              height: Dimensions.space20,
            ),
            Image.asset(
              MyImages.profile,
              height: 75,
              width: 75,
            ),
            const SizedBox(height: Dimensions.space8),
            Text("${ride.user?.firstname} ${ride.user?.lastname}", style: regularDefault.copyWith(fontSize: 16)),
            const SizedBox(height: Dimensions.space8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 12,
                      color: MyColor.colorYellow,
                    ),
                    Text(
                      "${ride.user?.avgRating}",
                      style: boldDefault.copyWith(color: MyColor.colorGrey, fontSize: Dimensions.fontDefault, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Container(
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(border: Border.all(color: MyColor.colorGrey, width: .5)),
                ),
                Row(
                  children: [
                    const CustomSvgPicture(
                      image: MyIcons.suv,
                      color: MyColor.bodyText,
                      height: 10,
                      width: 15,
                    ),
                    const SizedBox(
                      width: Dimensions.space5 - 1,
                    ),
                    Text(
                      "${ride.user?.mobile}",
                      style: boldDefault.copyWith(color: MyColor.colorGrey, fontSize: Dimensions.fontDefault, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
            const CustomDivider(
              space: Dimensions.space10,
              color: MyColor.bodyText,
            ),
            const SizedBox(
              height: Dimensions.space30,
            ),
            Text(
              MyStrings.ratingRider.tr,
              style: semiBoldDefault.copyWith(fontSize: Dimensions.fontOverLarge + 2),
            ),
            RatingBar.builder(
              initialRating: controller.rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                controller.updateRating(rating);
              },
            ),
            const SizedBox(
              height: Dimensions.space25 - 1,
            ),
            Text(
              MyStrings.whatCouldBeBetter.tr,
              style: mediumDefault.copyWith(fontSize: Dimensions.fontOverLarge - 1),
            ),
            const SizedBox(
              height: Dimensions.space12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomTextField(
                needOutlineBorder: true,
                animatedLabel: false,
                labelText: '',
                onChanged: (v) {},
                controller: controller.reviewMsgController,
                hintText: MyStrings.reviewMsgHintText.tr,
                maxLines: 5,
              ),
            ),
            const SizedBox(
              height: Dimensions.space30 + 2,
            ),
            RoundedButton(
              text: MyStrings.submit,
              textColor: MyColor.colorWhite,
              isLoading: controller.isReviewLoading,
              press: () {
                printX(controller.rating);
                printX(controller.reviewMsgController.text);
                if (controller.rating > 0 && controller.reviewMsgController.text.isNotEmpty) {
                  Get.offAllNamed(RouteHelper.dashboard);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
