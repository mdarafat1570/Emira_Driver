import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/withdraw/withdraw_history_controller.dart';
import 'package:ovoride_driver/data/repo/withdraw/withdraw_history_repo.dart';

import '../../../../core/helper/date_converter.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/no_data.dart';
import '../widget/custom_withdraw_card.dart';
import '../widget/withdraw_bottom_sheet.dart';
import '../widget/withdraw_history_top.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (Get.find<WithdrawHistoryController>().hasNext()) {
        Get.find<WithdrawHistoryController>().loadPaginationData();
      }
    }
  }

  @override
  void initState() {
    Get.put(WithdrawHistoryRepo(apiClient: Get.find()));
    final controller = Get.put(WithdrawHistoryController(withdrawHistoryRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initData();
      scrollController.addListener(scrollListener);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawHistoryController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.containerBgColor,
        appBar: AppBar(
          title: Text(MyStrings.withdraw.tr, style: regularLarge.copyWith(color: MyColor.colorWhite)),
          backgroundColor: MyColor.primaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios, color: MyColor.colorWhite, size: 20),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                controller.changeSearchStatus();
              },
              child: Container(
                padding: const EdgeInsets.all(Dimensions.space7),
                decoration: const BoxDecoration(color: MyColor.colorWhite, shape: BoxShape.circle),
                child: Icon(controller.isSearch ? Icons.clear : Icons.search, color: MyColor.primaryColor, size: 15),
              ),
            ),
            const SizedBox(width: Dimensions.space15),
          ],
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : Padding(
                padding: const EdgeInsets.only(top: Dimensions.space20, left: Dimensions.space15, right: Dimensions.space15),
                child: Column(
                  children: [
                    Visibility(
                      visible: controller.isSearch,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WithdrawHistoryTop(),
                          SizedBox(height: Dimensions.space10),
                        ],
                      ),
                    ),
                    Expanded(
                      child: controller.withdrawList.isEmpty && controller.filterLoading == false
                          ? NoDataWidget(
                              margin: 8,
                              text: MyStrings.noWithdrawalFound.tr,
                            )
                          : controller.filterLoading
                              ? const CustomLoader()
                              : SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: controller.withdrawList.length + 1,
                                    controller: scrollController,
                                    separatorBuilder: (context, index) => const SizedBox(height: Dimensions.space10),
                                    itemBuilder: (context, index) {
                                      if (index == controller.withdrawList.length) {
                                        return controller.hasNext() ? const CustomLoader(isPagination: true) : const SizedBox();
                                      }
                                      return CustomWithdrawCard(
                                        onPressed: () {
                                          WithdrawBottomSheet().withdrawBottomSheet(index, context, controller.currency, controller);
                                        },
                                        trxValue: controller.withdrawList[index].trx ?? "",
                                        date: DateConverter.estimatedDate(DateTime.tryParse(controller.withdrawList[index].createdAt ?? "") ?? DateTime.now(), formatType: DateFormatType.onlyDate),
                                        status: controller.getStatus(index),
                                        statusBgColor: controller.getColor(index),
                                        amount: "${StringConverter.formatNumber(controller.withdrawList[index].amount ?? " ")} ${controller.currency}",
                                      );
                                    },
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
