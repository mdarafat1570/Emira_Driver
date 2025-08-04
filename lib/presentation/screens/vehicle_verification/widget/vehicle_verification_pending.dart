import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_images.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/column_widget/card_column.dart';
import 'package:ovoride_driver/presentation/components/file_download_dialog/download_dialogue.dart';
import 'package:ovoride_driver/presentation/components/image/custom_svg_picture.dart';

import '../../../../data/controller/vehicle_verification/vehicle_verification_controller.dart';
import '../../../components/image/my_network_image_widget.dart';

class VehicleVerificationPendingSection extends StatefulWidget {
  final bool isPending;
  final String title;

  const VehicleVerificationPendingSection({super.key, this.isPending = false, this.title = MyStrings.kycUnderReviewMsg});

  @override
  State<VehicleVerificationPendingSection> createState() => _VehicleVerificationPendingSectionState();
}

class _VehicleVerificationPendingSectionState extends State<VehicleVerificationPendingSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VehicleVerificationController>(builder: (controller) {
      return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyColor.screenBgColor,
        ),
        child: controller.pendingData.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: MyColor.naturalLight.withValues(alpha: .4))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(MyStrings.selectedService.tr, style: boldLarge),
                        SizedBox(height: 10),
                        MyImageWidget(imageUrl: "${controller.serviceImagePath}/${controller.selectedService.image ?? ''}", height: 60, width: 60, radius: 10),
                        SizedBox(height: 10),
                        Row(
                          children: [Text("${MyStrings.serviceName} : ", style: mediumDefault), Text(controller.selectedService.name?.tr ?? '', style: mediumDefault.copyWith())],
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: MyColor.naturalLight.withValues(alpha: .4))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(MyStrings.selectedBrand.tr, style: boldLarge),
                        SizedBox(height: 10),
                        MyImageWidget(imageUrl: "${controller.brandImagePath}/${controller.pendingVehicleData?.brand?.image ?? ''}", height: 60, width: 60, radius: 10),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text("${MyStrings.brandName.tr} : ", style: mediumDefault),
                            Text(controller.pendingVehicleData?.brand?.name ?? '', style: mediumDefault.copyWith()),
                          ],
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: MyColor.naturalLight.withValues(alpha: .4))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Vehicle Image".tr, style: boldLarge),
                        SizedBox(height: 10),
                        MyImageWidget(imageUrl: controller.pendingVehicleData?.imageSrc ?? '', height: 100, width: 100, radius: 10),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Dimensions.space8),
                    margin: const EdgeInsets.symmetric(vertical: Dimensions.space10),
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColor.borderColor, width: .5),
                      borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                    ),
                    child: CardColumn(
                      header: "Vehicle Color",
                      body: StringConverter.removeQuotationAndSpecialCharacterFromString(controller.pendingVehicleData?.color?.name ?? '').toTitleCase(),
                      headerTextStyle: semiBoldDefault.copyWith(fontSize: Dimensions.fontDefault),
                      bodyTextStyle: regularDefault.copyWith(),
                      bodyMaxLine: 3,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Dimensions.space8),
                    margin: const EdgeInsets.symmetric(vertical: Dimensions.space10),
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColor.borderColor, width: .5),
                      borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                    ),
                    child: CardColumn(
                      header: "Vehicle Model",
                      body: StringConverter.removeQuotationAndSpecialCharacterFromString(controller.pendingVehicleData?.model?.name ?? '').toTitleCase(),
                      headerTextStyle: semiBoldDefault.copyWith(fontSize: Dimensions.fontDefault),
                      bodyTextStyle: regularDefault.copyWith(),
                      bodyMaxLine: 3,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Dimensions.space8),
                    margin: const EdgeInsets.symmetric(vertical: Dimensions.space10),
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColor.borderColor, width: .5),
                      borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                    ),
                    child: CardColumn(
                      header: "Vehicle Year",
                      body: StringConverter.removeQuotationAndSpecialCharacterFromString(controller.pendingVehicleData?.year?.name ?? '').toTitleCase(),
                      headerTextStyle: semiBoldDefault.copyWith(fontSize: Dimensions.fontDefault),
                      bodyTextStyle: regularDefault.copyWith(),
                      bodyMaxLine: 3,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.pendingData.length,
                    itemBuilder: (context, index) {
                      return controller.pendingData[index].value != null && controller.pendingData[index].value!.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.all(Dimensions.space8),
                              margin: const EdgeInsets.symmetric(vertical: Dimensions.space10),
                              decoration: BoxDecoration(
                                border: Border.all(color: MyColor.borderColor, width: .5),
                                borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                              ),
                              child: controller.pendingData[index].type == "file"
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(controller.pendingData[index].name ?? '', style: semiBoldDefault.copyWith(fontSize: Dimensions.fontDefault)),
                                        const SizedBox(height: Dimensions.space5),
                                        GestureDetector(
                                          onTap: () {
                                            String url = "${controller.path}/${controller.pendingData[index].value.toString()}";
                                            printX(url);
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return DownloadingDialog(url: url, fileName: MyStrings.kycData);
                                              },
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.file_download,
                                                size: 17,
                                                color: MyColor.primaryColor,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                MyStrings.attachment.tr,
                                                style: regularDefault.copyWith(color: MyColor.primaryColor),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : CardColumn(
                                      header: controller.pendingData[index].name ?? '',
                                      body: StringConverter.removeQuotationAndSpecialCharacterFromString(controller.pendingData[index].value ?? '').toTitleCase(),
                                      headerTextStyle: semiBoldDefault.copyWith(fontSize: Dimensions.fontDefault),
                                      bodyTextStyle: regularDefault.copyWith(),
                                      bodyMaxLine: 3,
                                    ),
                            )
                          : SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: Dimensions.space15),
                  RoundedButton(
                    text: MyStrings.backToHome,
                    press: () {
                      Get.back();
                    },
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomSvgPicture(
                    image: widget.isPending ? MyImages.pendingIcon : MyImages.verifiedIcon,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(widget.isPending ? widget.title.tr : MyStrings.kycAlreadyVerifiedMsg.tr,
                      style: regularDefault.copyWith(
                        color: MyColor.colorBlack,
                        fontSize: Dimensions.fontExtraLarge,
                      )),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
      );
    });
  }
}
