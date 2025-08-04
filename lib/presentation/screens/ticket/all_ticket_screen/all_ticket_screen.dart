import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/date_converter.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/controller/support/support_controller.dart';
import 'package:ovoride_driver/data/repo/support/support_repo.dart';
import 'package:ovoride_driver/presentation/components/custom_loader/custom_loader.dart';
import 'package:ovoride_driver/presentation/components/no_data.dart';
import 'package:ovoride_driver/presentation/screens/ticket/all_ticket_screen/widget/all_ticket_list_item.dart';

import '../../../../core/route/route.dart';
import '../../../../core/utils/ticket_helper.dart';
import '../../../components/app-bar/custom_appbar.dart';
import '../../../components/fab.dart';

class AllTicketScreen extends StatefulWidget {
  const AllTicketScreen({super.key});

  @override
  State<AllTicketScreen> createState() => _AllTicketScreenState();
}

class _AllTicketScreenState extends State<AllTicketScreen> {
  ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<SupportController>().hasNext()) {
        Get.find<SupportController>().getSupportTicket();
      }
    }
  }

  @override
  void initState() {
    Get.put(SupportRepo(apiClient: Get.find()));
    final controller = Get.put(SupportController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
      scrollController.addListener(scrollListener);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupportController>(builder: (controller) {
      return Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(title: MyStrings.supportTicket),
        body: controller.isLoading
            ? const CustomLoader()
            : RefreshIndicator(
                onRefresh: () async {
                  controller.loadData();
                },
                color: MyColor.primaryColor,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: Dimensions.defaultPaddingHV,
                  child: controller.ticketList.isEmpty
                      ? const Center(
                          child: NoDataWidget(
                          text: MyStrings.noSupportTicket,
                        ))
                      : ListView.separated(
                          controller: scrollController,
                          itemCount: controller.ticketList.length + 1,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) => const SizedBox(height: Dimensions.space10),
                          itemBuilder: (context, index) {
                            if (controller.ticketList.length == index) {
                              return controller.hasNext() ? const CustomLoader(isPagination: true) : const SizedBox();
                            }
                            return GestureDetector(
                                onTap: () {
                                  String id = controller.ticketList[index].ticket ?? '-1';
                                  String subject = controller.ticketList[index].subject ?? '';
                                  Get.toNamed(RouteHelper.ticketDetailsScreen, arguments: [id, subject])?.then(
                                    (value) {
                                      if (value != null && value == 'updated') {
                                        controller.loadData();
                                      }
                                    },
                                  );
                                },
                                child: AllTicketListItem(
                                    ticketNumber: controller.ticketList[index].ticket ?? '',
                                    subject: controller.ticketList[index].subject ?? '',
                                    status: TicketHelper.getStatusText(controller.ticketList[index].status ?? '0'),
                                    priority: TicketHelper.getPriorityText(controller.ticketList[index].priority ?? '0'),
                                    statusColor: TicketHelper.getStatusColor(controller.ticketList[index].status ?? '0'),
                                    priorityColor: TicketHelper.getPriorityColor(controller.ticketList[index].priority ?? '0'),
                                    time: DateConverter.getTimeAgo(controller.ticketList[index].createdAt ?? '')));
                          },
                        ),
                )),
        floatingActionButton: FAB(
          callback: () {
            Get.toNamed(RouteHelper.newTicketScreen)?.then((value) => {
                  if (value != null && value == 'updated') {controller.loadData()}
                });
          },
        ),
      );
    });
  }
}
