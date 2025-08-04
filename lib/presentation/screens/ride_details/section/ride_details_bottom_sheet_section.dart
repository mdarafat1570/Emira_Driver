import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/data/controller/ride/ride_details/ride_details_controller.dart';
import 'package:ovoride_driver/data/services/download_service.dart';
import 'package:ovoride_driver/environment.dart';
import 'package:ovoride_driver/presentation/components/annotated_region/annotated_region_widget.dart';
import 'package:ovoride_driver/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/dialog/app_dialog.dart';
import 'package:ovoride_driver/presentation/screens/ride_details/section/ride_details_payment_section.dart';
import 'package:ovoride_driver/presentation/screens/ride_details/section/ride_details_review_section.dart';
import 'package:ovoride_driver/presentation/screens/ride_details/widgets/pick_up_bottom_sheet.dart';
import 'package:ovoride_driver/presentation/screens/ride_details/widgets/ride_card_details.dart';
import 'package:ovoride_driver/presentation/screens/ride_details/widgets/ride_destination_widget.dart';
import 'package:ovoride_driver/presentation/screens/ride_details/widgets/user_details_widget.dart';

class RideDetailsBottomSheetSection extends StatefulWidget {
  final ScrollController scrollController;
  final BoxConstraints constraints;
  final DraggableScrollableController draggableScrollableController;
  const RideDetailsBottomSheetSection({
    super.key,
    required this.scrollController,
    required this.constraints,
    required this.draggableScrollableController,
  });

  @override
  State<RideDetailsBottomSheetSection> createState() => _RideDetailsBottomSheetSectionState();
}

class _RideDetailsBottomSheetSectionState extends State<RideDetailsBottomSheetSection> {
  bool isDownLoadLoading = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideDetailsController>(builder: (controller) {
      final ride = controller.ride;
      final currency = controller.currency;

      return AnnotatedRegionWidget(
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: context.width,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space12),
          decoration: const BoxDecoration(color: MyColor.colorWhite, borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18))),
          child: ListView(
            clipBehavior: Clip.none,
            controller: widget.scrollController,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: MyColor.colorGrey.withValues(alpha: 0.2)),
                ),
              ),
              const SizedBox(height: Dimensions.space20),
              UserDetailsWidget(ride: ride, imageUrl: controller.userImageUrl),
              const SizedBox(height: Dimensions.space20),
              Container(
                width: context.width,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space15),
                decoration: BoxDecoration(color: MyColor.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Dimensions.mediumRadius)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: Dimensions.space20),
                      RideCardDetails(title: '${ride.distance} ${MyStrings.km.tr}', description: MyStrings.distanceAway),
                      const SizedBox(width: Dimensions.space30),
                      RideCardDetails(title: '${ride.duration}', description: MyStrings.estimatedDuration),
                      const SizedBox(width: Dimensions.space30),
                      RideCardDetails(title: '${StringConverter.formatNumber(ride.amount.toString())} $currency', description: MyStrings.rideFare),
                      const SizedBox(width: Dimensions.space20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.space20),
              const RideDestination(),
              const SizedBox(height: Dimensions.space20),
              if (controller.ride.status == "1") ...[
                if (controller.ride.userReview == null) ...[
                  RoundedButton(
                    text: MyStrings.review,
                    isOutlined: false,
                    press: () {
                      CustomBottomSheet(child: RideDetailsReviewSection()).customBottomSheet(context);
                    },
                    textColor: MyColor.colorWhite,
                  ),
                ] else ...[
                  const SizedBox(height: Dimensions.space20),
                  RoundedButton(
                    text: MyStrings.receipt,
                    press: () {
                      setState(() {
                        isDownLoadLoading = true;
                      });
                      DownloadService.downloadPDF(
                        url: "${UrlContainer.rideReceipt}/${controller.ride.id}",
                        fileName: "${Environment.appName}_receipt_${controller.ride.id}.pdf",
                      );
                      setState(() {
                        isDownLoadLoading = false;
                      });
                    },
                    isLoading: isDownLoadLoading,
                    textColor: MyColor.getRideTitleColor(),
                    textStyle: regularDefault.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontLarge, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: Dimensions.space15),
                ]
              ] else if (controller.ride.status == "2") ...[
                RoundedButton(
                  text: MyStrings.pickupPassenger.tr,
                  press: () {
                    CustomBottomSheet(
                      child: PickUpBottomSHeet(ride: ride),
                    ).customBottomSheet(context);
                  },
                  isLoading: controller.isStartBtnLoading,
                  textColor: MyColor.getRideTitleColor(),
                  textStyle: regularDefault.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontLarge, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: Dimensions.space15),
              ] else if (controller.ride.status == "3") ...[
                RoundedButton(
                  text: MyStrings.endRide,
                  press: () {
                    AppDialog().showRideDetailsDialog(context, title: MyStrings.pleaseConfirm, description: MyStrings.youWantToEndTheRide, onTap: () {
                      controller.endRide(ride.id ?? '-1');
                    });
                  },
                  isLoading: controller.isEndBtnLoading,
                  textColor: MyColor.getRideTitleColor(),
                  textStyle: regularDefault.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontLarge, fontWeight: FontWeight.bold),
                ),
              ] else if (controller.ride.status == "4") ...[
                RideDetailsPaymentSection(),
                const SizedBox(height: Dimensions.space25),
              ] else
                ...[]
            ],
          ),
        ),
      );
    });
  }
}
