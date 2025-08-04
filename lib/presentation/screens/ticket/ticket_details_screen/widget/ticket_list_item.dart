import 'package:flutter_svg/svg.dart';
import 'package:ovoride_driver/core/helper/date_converter.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_icons.dart';
import 'package:ovoride_driver/core/utils/my_images.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/core/utils/util.dart';
import 'package:ovoride_driver/data/controller/support/ticket_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/url_container.dart';
import '../../../../../data/model/support/support_ticket_view_response_model.dart';
import '../../../../components/image/my_network_image_widget.dart';

class TicketListItem extends StatelessWidget {
  const TicketListItem({super.key, required this.index, required this.messages});

  final SupportMessage messages;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketDetailsController>(
        builder: (controller) => Container(
              padding: const EdgeInsets.all(Dimensions.space10),
              margin: const EdgeInsets.only(bottom: Dimensions.space15),
              decoration: BoxDecoration(
                color: messages.adminId == "1" ? MyColor.pendingColor.withValues(alpha: 0.1) : MyColor.cardBgColor,
                borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                border: Border.all(
                  color: messages.adminId == "1" ? MyColor.pendingColor : MyColor.borderColor,
                  strokeAlign: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: ClipOval(
                          child: Image.asset(messages.adminId == "1" ? MyImages.admin : MyImages.profile, height: 35, width: 35),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (messages.admin == null)
                                Text(
                                  '${messages.ticket?.name}',
                                  style: boldDefault.copyWith(color: MyColor.getTextColor()),
                                )
                              else
                                Text(
                                  '${messages.admin?.name}',
                                  style: boldDefault.copyWith(color: MyColor.getTextColor()),
                                ),
                              Text(
                                messages.adminId == "1" ? MyStrings.admin.tr : MyStrings.you.tr,
                                style: regularDefault.copyWith(color: MyColor.bodyTextColor),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateConverter.getTimeAgo(messages.createdAt ?? ''),
                            style: regularDefault.copyWith(color: MyColor.bodyTextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
                          ),
                          child: Text(
                            messages.message ?? "",
                            style: regularDefault.copyWith(color: MyColor.bodyTextColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (messages.attachments?.isNotEmpty ?? false)
                    Container(
                      height: MediaQuery.of(context).size.width > 500 ? 100 : 100,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: messages.attachments != null
                              ? List.generate(
                                  messages.attachments!.length,
                                  (i) => messages.attachments![i].isLoading
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space30, vertical: Dimensions.space10),
                                          decoration: BoxDecoration(
                                            color: MyColor.getScreenBgColor(),
                                            borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                          ),
                                          child: SpinKitThreeBounce(size: 20.0, color: MyColor.getPrimaryColor()),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            String url = '${UrlContainer.supportImagePath}${messages.attachments?[i].attachment}';
                                            String ext = messages.attachments?[i].attachment!.split('.')[1] ?? 'pdf';
                                            if (MyUtils.isImage(messages.attachments?[i].attachment.toString() ?? "")) {
                                              controller.downloadAttachment(url, messages.attachments?[i].id ?? -1, ext, messages.attachments![i]);
                                            } else {
                                              controller.downloadAttachment(url, messages.attachments?[i].id ?? -1, ext, messages.attachments![i]);
                                            }
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context).size.width > 500 ? 100 : 100,
                                                  height: MediaQuery.of(context).size.width > 500 ? 100 : 100,
                                                  margin: const EdgeInsets.only(right: 10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: MyColor.borderColor),
                                                    borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                                  ),
                                                  child: MyUtils.isImage(messages.attachments?[i].attachment.toString() ?? "")
                                                      ? MyImageWidget(
                                                          imageUrl: "${UrlContainer.supportImagePath}${messages.attachments?[i].attachment}",
                                                          width: MediaQuery.of(context).size.width > 500 ? 100 : 100,
                                                          height: MediaQuery.of(context).size.width > 500 ? 100 : 100,
                                                        )
                                                      : MyUtils.isDoc(messages.attachments?[i].attachment.toString() ?? "")
                                                          ? Center(
                                                              child: SvgPicture.asset(
                                                                MyIcons.doc,
                                                                height: 45,
                                                                width: 45,
                                                              ),
                                                            )
                                                          : Center(
                                                              child: SvgPicture.asset(
                                                                MyIcons.pdfFile,
                                                                height: 45,
                                                                width: 45,
                                                              ),
                                                            )),
                                            ],
                                          ),
                                        ),
                                )
                              : const [SizedBox.shrink()],
                        ),
                      ),
                    ),
                ],
              ),
            ));
  }
}
