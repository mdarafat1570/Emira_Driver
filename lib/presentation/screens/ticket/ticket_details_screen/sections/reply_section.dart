import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/core/utils/util.dart';
import 'package:ovoride_driver/data/controller/support/ticket_details_controller.dart';

import '../../../../../core/utils/my_icons.dart';
import '../../../../components/buttons/rounded_button.dart';
import '../../widget/circle_icon_button.dart';
import '../../widget/label_text_field.dart';

class ReplySection extends StatelessWidget {
  const ReplySection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketDetailsController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelTextField(
            controller: controller.replyController,
            maxLines: 5,
            contentPadding: const EdgeInsets.all(Dimensions.space10),
            isAttachment: true,
            labelText: MyStrings.message,
            hintText: "",
            inputAction: TextInputAction.done,
            onChanged: (value) {
              return;
            },
          ),
          const SizedBox(height: 20),
          LabelTextField(
            readOnly: true,
            contentPadding: const EdgeInsets.all(Dimensions.space10),
            isAttachment: true,
            labelText: MyStrings.attachment.tr,
            hintText: MyStrings.chooseAFile.tr,
            inputAction: TextInputAction.done,
            onChanged: (value) {
              return;
            },
            suffixIcon: InkWell(
              onTap: () {
                controller.pickFile();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space10),
                margin: const EdgeInsets.all(Dimensions.space5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: MyColor.getPrimaryColor(),
                ),
                child: Text(
                  MyStrings.upload,
                  style: regularDefault.copyWith(color: MyColor.colorWhite),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text("${MyStrings.supportedFileType.tr} ${MyStrings.ext}", style: regularSmall.copyWith(color: MyColor.getGreyText())),
          const SizedBox(height: Dimensions.space20),
          controller.attachmentList.isNotEmpty
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          controller.attachmentList.length,
                          (index) => Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(Dimensions.space5),
                                    decoration: const BoxDecoration(),
                                    child: MyUtils.isImage(controller.attachmentList[index].path)
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                            child: Image.file(
                                              controller.attachmentList[index],
                                              width: context.width / 5,
                                              height: context.width / 5,
                                              fit: BoxFit.cover,
                                            ))
                                        : MyUtils.isDoc(controller.attachmentList[index].path)
                                            ? Container(
                                                width: context.width / 5,
                                                height: context.width / 5,
                                                decoration: BoxDecoration(color: MyColor.colorWhite, borderRadius: BorderRadius.circular(Dimensions.mediumRadius), border: Border.all(color: MyColor.borderColor, width: 1)),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    MyIcons.doc,
                                                    height: 45,
                                                    width: 45,
                                                    color: MyColor.colorWhite,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: context.width / 5,
                                                height: context.width / 5,
                                                decoration: BoxDecoration(
                                                  color: MyColor.colorWhite,
                                                  borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                                  border: Border.all(color: MyColor.borderColor, width: 1),
                                                ),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    MyIcons.pdfFile,
                                                    height: 45,
                                                    width: 45,
                                                  ),
                                                ),
                                              ),
                                  ),
                                  CircleIconButton(
                                    onTap: () {
                                      controller.removeAttachmentFromList(index);
                                    },
                                    height: Dimensions.space20,
                                    width: Dimensions.space20,
                                    backgroundColor: MyColor.redCancelTextColor,
                                    child: Icon(
                                      Icons.close,
                                      color: MyColor.colorWhite,
                                      size: Dimensions.space15,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: Dimensions.space30),
          RoundedButton(
            isLoading: controller.submitLoading,
            text: MyStrings.reply.tr,
            press: () {
              controller.submitReply();
            },
          ),
          const SizedBox(height: Dimensions.space30),
        ],
      ),
    );
  }
}
