import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/controller/support/ticket_details_controller.dart';
import 'package:ovoride_driver/data/repo/support/support_repo.dart';
import 'package:ovoride_driver/presentation/components/app-bar/custom_appbar.dart';
import 'package:ovoride_driver/presentation/components/custom_loader/custom_loader.dart';
import 'package:ovoride_driver/presentation/screens/ticket/ticket_details_screen/sections/message_list_section.dart';
import 'package:ovoride_driver/presentation/screens/ticket/ticket_details_screen/sections/reply_section.dart';
import 'package:ovoride_driver/presentation/screens/ticket/ticket_details_screen/widget/ticket_status_widget.dart';

import '../../../components/warning_aleart_dialog.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({super.key});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  String title = "";
  @override
  void initState() {
    String ticketId = Get.arguments[0];
    title = Get.arguments[1];

    Get.put(SupportRepo(apiClient: Get.find()));
    var controller = Get.put(TicketDetailsController(repo: Get.find(), ticketId: ticketId));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketDetailsController>(
      builder: (controller) => Scaffold(
          appBar: CustomAppBar(
            title: title,
            actionsWidget: [
              if (controller.model.data?.myTickets?.status != '3' && !controller.isLoading) ...[
                InkWell(
                  onTap: () {
                    const WarningAlertDialog().warningAlertDialog(subtitleMessage: MyStrings.youWantToCloseThisTicket.tr, context, () {
                      Navigator.pop(context);
                      controller.closeTicket(controller.model.data?.myTickets?.id.toString() ?? '-1');
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(color: MyColor.redCancelTextColor, shape: BoxShape.circle),
                    padding: EdgeInsets.all(4),
                    height: 30,
                    width: 30,
                    child: controller.closeLoading ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: MyColor.colorWhite)) : Icon(Icons.close, color: MyColor.colorWhite),
                  ),
                )
              ],
              SizedBox(width: Dimensions.space10)
            ],
          ),
          body: controller.isLoading
              ? const CustomLoader(isFullScreen: true)
              : SingleChildScrollView(
                  padding: Dimensions.screenPadding,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        TicketStatusWidget(controller: controller),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: MyColor.cardBgColor,
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ReplySection(), MessageListSection()],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
    );
  }
}
