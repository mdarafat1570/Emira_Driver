import 'package:flutter/material.dart';
import 'package:ovoride_driver/core/utils/app_status.dart';

import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/style.dart';

class RideStatusWidget extends StatelessWidget {
  final String status;

  const RideStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                width: .5,
                color: status == AppStatus.RIDE_ACTIVE || status == AppStatus.RIDE_COMPLETED
                    ? MyColor.greenSuccessColor.withValues(alpha: .7)
                    : status == AppStatus.RIDE_CANCELED
                        ? MyColor.redCancelTextColor.withValues(alpha: .7)
                        : MyColor.pendingColor.withValues(alpha: .7)),
            color: status == AppStatus.RIDE_ACTIVE || status == AppStatus.RIDE_COMPLETED
                ? MyColor.greenSuccessColor.withValues(alpha: .1)
                : status == AppStatus.RIDE_CANCELED
                    ? MyColor.redCancelTextColor.withValues(alpha: .1)
                    : MyColor.pendingColor.withValues(alpha: .1)),
        child: Text(
          status == AppStatus.RIDE_PENDING
              ? "Pending"
              : status == AppStatus.RIDE_COMPLETED
                  ? "Completed"
                  : status == AppStatus.RIDE_ACTIVE
                      ? "Active"
                      : status == AppStatus.RIDE_RUNNING
                          ? "Running"
                          : status == AppStatus.RIDE_CANCELED
                              ? "Canceled"
                              : status == AppStatus.RIDE_PAYMENT_REQUESTED
                                  ? "Payment Request"
                                  : "",
          style: mediumLarge.copyWith(
              color: status == AppStatus.RIDE_ACTIVE || status == AppStatus.RIDE_COMPLETED
                  ? MyColor.greenSuccessColor
                  : status == AppStatus.RIDE_CANCELED
                      ? MyColor.redCancelTextColor
                      : MyColor.pendingColor),
        ));
  }
}
