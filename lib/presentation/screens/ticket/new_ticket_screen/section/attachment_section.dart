import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/my_icons.dart';
import '../../../../../data/controller/support/new_ticket_controller.dart';
import '../../widget/circle_icon_button.dart';

class AttachmentSection extends StatelessWidget {
  const AttachmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewTicketController>(builder: (controller) {
      return controller.attachmentList.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  controller.attachmentList.length,
                  (index) => Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(Dimensions.space5),
                            decoration: const BoxDecoration(),
                            child: controller.isImage(controller.attachmentList[index].path)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                    child: Image.file(
                                      controller.attachmentList[index],
                                      width: context.width / 5,
                                      height: context.width / 5,
                                      fit: BoxFit.cover,
                                    ))
                                : controller.isXlsx(controller.attachmentList[index].path)
                                    ? Container(
                                        width: context.width / 5,
                                        height: context.width / 5,
                                        decoration: BoxDecoration(
                                          color: MyColor.colorWhite,
                                          borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                          border: Border.all(color: MyColor.borderColor, width: 1),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(MyIcons.xlsx, height: 45, width: 45),
                                        ),
                                      )
                                    : controller.isDoc(controller.attachmentList[index].path)
                                        ? Container(
                                            width: context.width / 5,
                                            height: context.width / 5,
                                            decoration: BoxDecoration(
                                              color: MyColor.colorWhite,
                                              borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                              border: Border.all(color: MyColor.borderColor, width: 1),
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(MyIcons.doc, height: 45, width: 45),
                                            ),
                                          )
                                        : Container(
                                            width: context.width / 5,
                                            height: context.width / 5,
                                            decoration: BoxDecoration(color: MyColor.colorWhite, borderRadius: BorderRadius.circular(Dimensions.mediumRadius), border: Border.all(color: MyColor.borderColor, width: 1)),
                                            child: Center(
                                              child: SvgPicture.asset(MyIcons.pdfFile, height: 45, width: 45),
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
                              size: Dimensions.space12,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox();
    });
  }
}
