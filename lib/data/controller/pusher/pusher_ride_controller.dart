import 'dart:convert';

import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/shared_preference_helper.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/util.dart';
import 'package:ovoride_driver/data/controller/ride/ride_details/ride_details_controller.dart';
import 'package:ovoride_driver/data/controller/ride/ride_meassage/ride_meassage_controller.dart';
import 'package:ovoride_driver/data/model/global/app/message_response_model.dart';
import 'package:ovoride_driver/data/model/global/app/ride_meassage_model.dart';
import 'package:ovoride_driver/data/model/global/pusher/pusher_event_response_model.dart';
import 'package:ovoride_driver/data/services/api_client.dart';
import 'package:ovoride_driver/data/services/pusher_service.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';

class PusherRideController extends GetxController {
  ApiClient apiClient;
  RideMessageController controller;
  RideDetailsController detailsController;
  PusherRideController({
    required this.apiClient,
    required this.controller,
    required this.detailsController,
  });

  @override
  void onInit() {
    super.onInit();
    PusherManager().addListener(onEvent);
  }

  void onEvent(PusherEvent event) {
    printX('event.data ${event.eventName}');
    if (event.eventName.toLowerCase() == "MESSAGE_RECEIVED".toLowerCase()) {
      printX(Get.currentRoute);
      if (Get.currentRoute == RouteHelper.rideDetailsScreen) {
        MyUtils.vibrate();
      }
      MessageResponseModel model = MessageResponseModel.fromJson(jsonDecode(event.data));
      controller.addEventMessage(
        RideMessage(
          rideId: model.data?.message?.rideId ?? '-1',
          message: model.data?.message?.message,
          driverId: model.data?.message?.driverId,
          userId: model.data?.message?.userId,
          image: model.data?.message?.image,
        ),
      );
    }

    PusherResponseModel model = PusherResponseModel.fromJson(jsonDecode(event.data));
    printX('event.channelName ${event.eventName}');
    final modify = PusherResponseModel(eventName: event.eventName, channelName: event.channelName, data: model.data);

    if (event.eventName.toLowerCase().trim() == "CASH_PAYMENT_REQUEST".toLowerCase().trim()) {
      if (Get.currentRoute == RouteHelper.rideDetailsScreen) {
        printX('payment_complete from payment_complete');
        detailsController.onShowPaymentDialog(Get.context!);
      } else {
        Get.offAllNamed(RouteHelper.rideDetailsScreen, arguments: modify.data?.ride?.id);
      }
    } else if (event.eventName.toLowerCase().trim() == "ONLINE_PAYMENT_RECEIVED".toLowerCase().trim()) {
      if (Get.currentRoute == RouteHelper.rideDetailsScreen) {
        MyUtils.vibrate();
        Get.offAllNamed(RouteHelper.allRideScreen);
      } else {
        Get.offAllNamed(RouteHelper.rideDetailsScreen, arguments: modify.data?.ride?.id);
      }
      CustomSnackBar.success(successList: ["Ride Completed Successfully"]);
    } else {
      updateEvent(modify);
    }
  }

  void updateEvent(PusherResponseModel event) {
    printX('event.eventName ${event.eventName}');
    if (event.eventName == "pick_up" || event.eventName == "ride_end" || event.eventName == "online-payment-received") {
      if (event.eventName == "online-payment-received") {
        CustomSnackBar.success(successList: ["Payment Received"]);
      }
      if (event.data?.ride != null) {
        detailsController.updateRide(event.data!.ride!);
      }
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
