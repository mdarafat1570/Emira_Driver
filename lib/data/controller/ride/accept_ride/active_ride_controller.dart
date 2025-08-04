import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/model/authorization/authorization_response_model.dart';
import 'package:ovoride_driver/data/model/global/response_model/response_model.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/data/model/ride/active_ride_response_model.dart';
import 'package:ovoride_driver/data/repo/ride/ride_repo.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';

class ActiveRideController extends GetxController {
  RideRepo repo;
  ActiveRideController({required this.repo});

  bool isLoading = true;

  String imagePath = "";
  String defaultCurrency = "";
  String defaultCurrencySymbol = "";
  String username = "";
  int page = 0;
  TextEditingController otpController = TextEditingController();
  bool isInterCity = false;

  Future<void> initialData(bool isICity) async {
    page = 0;
    defaultCurrency = repo.apiClient.getCurrency();
    defaultCurrencySymbol = repo.apiClient.getCurrency(isSymbol: true);
    username = repo.apiClient.getUserName();
    pendingRides = [];
    isInterCity = isICity;
    update();
    await getActiveRideList();
    isLoading = false;
    update();
  }

  RideModel runningRides = RideModel(id: '-1');
  List<RideModel> pendingRides = [];
  List<RideModel> acceptRides = [];

  Future<void> getActiveRideList({int? p, bool shouldLoading = true}) async {
    page = p ?? page + 1;
    if (page == 1) {
      pendingRides.clear();
      acceptRides.clear();
      pendingRides.clear();
      isLoading = shouldLoading;
    }

    isLoading = shouldLoading;
    update();

    try {
      ResponseModel responseModel = await repo.activeRide(isICity: isInterCity);
      if (responseModel.statusCode == 200) {
        ActiveRideResponseModel model = ActiveRideResponseModel.fromJson((responseModel.responseJson));
        if (model.status == MyStrings.success) {
          pendingRides.addAll(model.data?.rides?.data ?? []);
          update();
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    }
    isLoading = false;
    update();
  }

  String selectedRideId = '-1';
  Future<void> startRide(String rideId) async {
    page = page + 1;
    selectedRideId = rideId;
    if (page == 1) {
      pendingRides.clear();
      acceptRides.clear();
      isLoading = true;
    }
    update();

    try {
      ResponseModel responseModel = await repo.startRide(id: rideId, otp: otpController.text);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson((responseModel.responseJson));
        if (model.status == MyStrings.success) {
          CustomSnackBar.success(successList: model.message ?? [MyStrings.success]);
          update();
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    }
    isLoading = false;
    otpController.text = '';
    selectedRideId = '-1';
    update();
  }

  bool isEndBtnLoading = false;
  bool isAcceptPaymentBtnLoading = false;

  Future<void> endRide(String rideId) async {
    isEndBtnLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.endRide(id: rideId);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson((responseModel.responseJson));
        if (model.status == MyStrings.success) {
          getActiveRideList();
          CustomSnackBar.success(successList: model.message ?? [MyStrings.success]);
          update();
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    }
    isEndBtnLoading = false;
    update();
  }

  Future<void> acceptPaymentRide(String rideId) async {
    isAcceptPaymentBtnLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.acceptCashPayment(id: rideId);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson((responseModel.responseJson));
        if (model.status == MyStrings.success) {
          CustomSnackBar.success(successList: model.message ?? [MyStrings.success]);
          update();
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    }
    isAcceptPaymentBtnLoading = true;
    update();
  }

  void resetLoading() {
    isLoading = true;
    update();
  }
}
