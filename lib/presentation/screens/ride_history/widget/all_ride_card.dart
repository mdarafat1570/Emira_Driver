// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/date_converter.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/app_status.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/core/utils/util.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/data/services/download_service.dart';
import 'package:ovoride_driver/environment.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/image/my_network_image_widget.dart';
import 'package:ovoride_driver/presentation/screens/ride_history/widget/ride_status_widget.dart';

import '../../../components/divider/custom_spacer.dart';
import '../../../components/timeline/custom_timeLine.dart';

class AllRideCard extends StatefulWidget {
  bool isPaymentDone;
  bool isReviewDone;
  RideModel ride;
  String currency;
  String imageUrl;
  VoidCallback reviewBtnCallback;

  AllRideCard({
    super.key,
    required this.isPaymentDone,
    required this.isReviewDone,
    required this.ride,
    required this.currency,
    required this.imageUrl,
    required this.reviewBtnCallback,
  });

  @override
  State<AllRideCard> createState() => _AllRideCardState();
}

class _AllRideCardState extends State<AllRideCard> {
  bool isDownLoadLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouteHelper.rideDetailsScreen, arguments: widget.ride.id.toString());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(Dimensions.mediumRadius), boxShadow: MyUtils.getCardShadow()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space5, vertical: Dimensions.space5),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(Dimensions.mediumRadius), boxShadow: MyUtils.getCardShadow()),
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
                            MyImageWidget(imageUrl: widget.imageUrl, isProfile: true, height: 45, width: 45, radius: 20),
                            const SizedBox(width: Dimensions.space10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.ride.user?.firstname} ${widget.ride.user?.lastname}".toTitleCase(),
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
                                          "${widget.ride.duration}, ${widget.ride.distance} ${MyStrings.km.tr}",
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
                        child: Column(
                          children: [
                            RideStatusWidget(status: widget.ride.status ?? ""),
                            SizedBox(height: 5),
                            Text(
                              "${widget.currency}${StringConverter.formatNumber(widget.ride.amount ?? '0')}",
                              overflow: TextOverflow.ellipsis,
                              style: boldLarge.copyWith(fontSize: Dimensions.fontExtraLarge, fontWeight: FontWeight.w900, color: MyColor.rideTitle),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  spaceDown(Dimensions.space30),
                  SizedBox(
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
                              widget.ride.pickupLocation ?? '',
                              style: regularDefault.copyWith(
                                color: MyColor.getRideSubTitleColor(),
                                fontSize: Dimensions.fontSmall,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.ride.startTime != null) ...[
                              spaceDown(Dimensions.space8),
                              Text(
                                DateConverter.estimatedDate(
                                  DateTime.tryParse('${widget.ride.startTime}') ?? DateTime.now(),
                                ),
                                style: regularDefault.copyWith(
                                  color: MyColor.getRideSubTitleColor(),
                                  fontSize: Dimensions.fontSmall,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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
                              widget.ride.destination ?? '',
                              style: regularDefault.copyWith(
                                color: MyColor.getRideSubTitleColor(),
                                fontSize: Dimensions.fontSmall,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.ride.endTime != null) ...[
                              spaceDown(Dimensions.space8),
                              Text(
                                DateConverter.estimatedDate(
                                  DateTime.tryParse('${widget.ride.endTime}') ?? DateTime.now(),
                                ),
                                style: regularDefault.copyWith(
                                  color: MyColor.getRideSubTitleColor(),
                                  fontSize: Dimensions.fontSmall,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                    MyStrings.rideCreatedTime.tr,
                    style: boldDefault.copyWith(color: MyColor.bodyText),
                  ),
                  Text(
                    DateConverter.estimatedDate(
                      DateTime.tryParse('${widget.ride.createdAt}') ?? DateTime.now(),
                    ),
                    style: boldDefault.copyWith(color: MyColor.colorGrey),
                  ),
                ],
              ),
            ),
            spaceDown(Dimensions.space10),
            if (widget.ride.status == AppStatus.RIDE_COMPLETED) ...[
              RoundedButton(
                text: MyStrings.receipt,
                isLoading: isDownLoadLoading,
                press: () {
                  setState(() {
                    isDownLoadLoading = true;
                  });
                  printX(isDownLoadLoading);
                  DownloadService.downloadPDF(
                    url: "${UrlContainer.rideReceipt}/${widget.ride.id}",
                    fileName: "${Environment.appName}_receipt_${widget.ride.id}.pdf",
                  );
                  Future.delayed(const Duration(seconds: 1), () {}).then((_) {
                    setState(() {
                      isDownLoadLoading = false;
                    });
                  });

                  printX(isDownLoadLoading);
                },
                textColor: MyColor.getRideTitleColor(),
                textStyle: regularDefault.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontLarge, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
