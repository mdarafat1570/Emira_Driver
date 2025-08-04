import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/util.dart';
import 'package:ovoride_driver/data/controller/payment_history/payment_history_controller.dart';
import 'package:ovoride_driver/data/services/api_client.dart';
import 'package:ovoride_driver/presentation/components/divider/custom_divider.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../components/column_widget/card_column.dart';

class CustomPaymentCard extends StatelessWidget {
  final String riderName;
  final String dateData;
  final String amountData;
  final String paymentType;
  final int index;

  const CustomPaymentCard({super.key, required this.index, required this.riderName, required this.dateData, required this.amountData, required this.paymentType});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentHistoryController>(
      builder: (controller) => Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
        decoration: BoxDecoration(color: MyColor.colorWhite, borderRadius: BorderRadius.circular(5), boxShadow: MyUtils.getCardShadow()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: CardColumn(header: MyStrings.rideUid.tr, body: riderName)),
                Expanded(
                  child: CardColumn(
                    alignmentEnd: true,
                    header: MyStrings.date,
                    body: dateData,
                    isDate: true,
                  ),
                )
              ],
            ),
            const CustomDivider(
              space: Dimensions.space15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: CardColumn(
                  header: MyStrings.amount,
                  body: '${StringConverter.formatNumber(amountData)} ${Get.find<ApiClient>().getCurrency()}',
                  textColor: MyColor.primaryTextColor,
                )),
                Expanded(child: CardColumn(alignmentEnd: true, header: MyStrings.paymentType.tr, body: paymentType == "1" ? MyStrings.onlinePayment.tr : MyStrings.cashPayment.tr)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
