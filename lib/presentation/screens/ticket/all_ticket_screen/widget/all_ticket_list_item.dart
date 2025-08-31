import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/presentation/screens/ticket/all_ticket_screen/widget/priority_badge.dart';
import 'package:ovoride_driver/presentation/screens/ticket/all_ticket_screen/widget/status_badge.dart';

import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/my_strings.dart';
import '../../../../../core/utils/style.dart';
import '../../../../components/column_widget/card_column.dart';

class AllTicketListItem extends StatelessWidget {
  final String ticketNumber;
  final String subject;
  final String status;
  final Color statusColor;
  final String priority;
  final Color priorityColor;
  final String time;

  const AllTicketListItem({super.key, required this.ticketNumber, required this.subject, required this.status, required this.priority, required this.statusColor, required this.priorityColor, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space15),
      decoration: BoxDecoration(color: MyColor.cardBgColor, borderRadius: BorderRadius.circular(Dimensions.mediumRadius)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: Dimensions.space10),
                  child: Column(
                    children: [
                      CardColumn(
                        header: "[${MyStrings.ticket.tr}#$ticketNumber]",
                        body: subject.tr,
                        space: 5,
                        headerTextStyle: regularDefault.copyWith(
                          color: MyColor.primaryTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                        bodyTextStyle: regularDefault.copyWith(
                          color: MyColor.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              StatusBadge(text: status, color: statusColor)
            ],
          ),
          const SizedBox(height: Dimensions.space15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PriorityBadge(text: priority, color: priorityColor),
              Text(
                time,
                style: regularDefault.copyWith(fontSize: Dimensions.fontSmall, fontStyle: FontStyle.italic, color: MyColor.naturalDark),
              ),
            ],
          )
        ],
      ),
    );
  }
}
