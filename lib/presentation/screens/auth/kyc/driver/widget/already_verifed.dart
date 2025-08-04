import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_images.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/data/controller/driver_kyc_controller/driver_kyc_controller.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/column_widget/card_column.dart';
import 'package:ovoride_driver/presentation/components/file_download_dialog/download_dialogue.dart';

import '../../../../../components/image/custom_svg_picture.dart';

class AlreadyVerifiedWidget extends StatefulWidget {
  final bool isPending;
  final String title;

  const AlreadyVerifiedWidget({super.key, this.isPending = false, this.title = MyStrings.kycUnderReviewMsg});

  @override
  State<AlreadyVerifiedWidget> createState() => _AlreadyVerifiedWidgetState();
}

class _AlreadyVerifiedWidgetState extends State<AlreadyVerifiedWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverKycController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.all(Dimensions.space20),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyColor.screenBgColor,
        ),
        child: controller.pendingData.isNotEmpty
            ? Column(
                children: [
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
                                            String url = "${UrlContainer.domainUrl}/${controller.path}/${controller.pendingData[index].value.toString()}";
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
                                      body: StringConverter.removeQuotationAndSpecialCharacterFromString(controller.pendingData[index].value ?? ''),
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
                  const SizedBox(height: 25),
                  Text(
                    widget.isPending ? widget.title.tr : MyStrings.kycAlreadyVerifiedMsg.tr,
                    style: regularDefault.copyWith(color: MyColor.colorBlack, fontSize: Dimensions.fontExtraLarge),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
      );
    });
  }
}
