import 'dart:convert';

import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/shared_preference_helper.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/audio_utils.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/controller/dashboard/dashboard_controller.dart';
import 'package:ovoride_driver/data/model/global/pusher/pusher_event_response_model.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/data/services/pusher_service.dart';
import 'package:ovoride_driver/presentation/components/dialog/custom_new_ride_dialog.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../core/helper/string_format_helper.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../services/api_client.dart';

class GlobalPusherController extends GetxController {
  ApiClient apiClient;
  DashBoardController dashBoardController;

  GlobalPusherController({required this.apiClient, required this.dashBoardController});

  @override
  void onInit() {
    super.onInit();

    PusherManager().addListener(onEvent);
  }

  void onEvent(PusherEvent event) {
    printX("Event Name:>> ${event.eventName}");
    if (event.eventName.toString().toLowerCase() == "NEW_RIDE".toLowerCase()) {
      printX("Event Name:>> ${event.eventName}");
      AudioUtils.playAudio(apiClient.getNotificationAudio());
      PusherResponseModel model = PusherResponseModel.fromJson(jsonDecode(event.data));
      final modifyData = PusherResponseModel(eventName: event.eventName, channelName: event.channelName, data: model.data);

      dashBoardController.updateMainAmount(double.tryParse(modifyData.data?.ride?.amount.toString() ?? "0.00") ?? 0);
      CustomNewRideDialog.newRide(
        ride: modifyData.data?.ride ?? RideModel(id: "-1"),
        currency: Get.find<ApiClient>().getCurrency(),
        currencySym: Get.find<ApiClient>().getCurrency(isSymbol: true),
        dashboardController: dashBoardController,
        onBidClick: () {
          var ride = modifyData.data?.ride;
          double enterValue = double.tryParse(dashBoardController.amountController.text) ?? 0.0;
          if (enterValue.toPrecision(0) >= (double.tryParse(ride?.minAmount.toString() ?? "0.00") ?? 0) && (enterValue.toPrecision(0)) < (double.tryParse(ride?.maxAmount.toString() ?? "0.00") ?? 0)) {
            dashBoardController.sendBid(modifyData.data?.ride?.id ?? '-1');
          } else {
            CustomSnackBar.error(
              errorList: ['${MyStrings.pleaseEnterMinimum} ${dashBoardController.currencySym}${StringConverter.formatNumber(ride?.minAmount ?? '0')} to ${dashBoardController.currencySym}${StringConverter.formatNumber(ride?.maxAmount ?? '')}'],
            );
          }
        },
      );

      dashBoardController.loadData();
      dashBoardController.update();
    }

    if (event.eventName.toString().toLowerCase() == "bid_accept" || event.eventName.toString().toLowerCase() == "CASH_PAYMENT_REQUEST".toLowerCase() || event.eventName.toString().toLowerCase() == "ONLINE_PAYMENT_RECEIVED".toLowerCase()) {
      PusherResponseModel model = PusherResponseModel.fromJson(jsonDecode(event.data));
      final pusherData = PusherResponseModel(eventName: event.eventName, channelName: event.channelName, data: model.data);

      Get.toNamed(RouteHelper.rideDetailsScreen, arguments: pusherData.data?.ride?.id);
    }
  }

  @override
  void onClose() {
    PusherManager().removeListener(onEvent);
    super.onClose();
  }

  Future<void> ensureConnection({String? channelName}) async {
    try {
      var userId = apiClient.sharedPreferences.getString(SharedPreferenceHelper.userIdKey) ?? '';
      await PusherManager().checkAndInitIfNeeded(channelName ?? "private-rider-driver-$userId");
    } catch (e) {
      printX("Error ensuring connection: $e");
    }
  }
}
