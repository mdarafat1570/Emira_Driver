import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/model/authorization/authorization_response_model.dart';
import 'package:ovoride_driver/data/model/global/response_model/response_model.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/data/model/ride/accepted_ride_response_model.dart';
import 'package:ovoride_driver/data/repo/ride/ride_repo.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';

class AcceptedRideController extends GetxController {
  RideRepo repo;
  AcceptedRideController({required this.repo});

  bool isLoading = true;

  String imagePath = "";
  String defaultCurrency = "";
  String defaultCurrencySymbol = "";
  String username = "";
  int page = 0;
  bool isInterCity = false;
  Future<void> initialData(bool isICity) async {
    page = 0;
    defaultCurrency = repo.apiClient.getCurrency();
    defaultCurrencySymbol = repo.apiClient.getCurrency(isSymbol: true);
    username = repo.apiClient.getUserName();
    isInterCity = isICity;
    update();
    await getAcceptedRideList();
    isLoading = false;
    isCancelLoading = false;
    update();
  }

  List<RideModel> rideList = [];
  String? nextPageUrl;
  Future<void> getAcceptedRideList({int? p, bool shouldLoading = true}) async {
    page = p ?? page + 1;
    if (page == 1) {
      rideList = [];
      isLoading = shouldLoading;
      update();
    }

    try {
      ResponseModel responseModel = await repo.acceptedRide(isICity: isInterCity);
      if (responseModel.statusCode == 200) {
        AcceptedRideResponseModel model = AcceptedRideResponseModel.fromJson((responseModel.responseJson));
        if (model.status == MyStrings.success) {
          nextPageUrl = model.data?.rides?.nextPageUrl;
          imagePath = model.data?.userImagePath ?? '';
          printX('model.data?.rides?.data  ${model.data?.rides?.data?.length}');
          rideList.addAll(model.data?.rides?.data ?? []);
          update();
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

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }

  bool isCancelLoading = false;
  TextEditingController cancelReasonController = TextEditingController();
  Future<void> cancelRide(String id) async {
    isCancelLoading = true;
    update();
    try {
      ResponseModel responseModel = await repo.cancelRide(id: id, reason: cancelReasonController.text);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson((responseModel.responseJson));
        if (model.status == "success") {
          cancelReasonController.text = '';
          getAcceptedRideList(p: 1);
          Get.back();
          CustomSnackBar.success(successList: model.message ?? [""]);
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    }
    isCancelLoading = false;
    update();
  }

  void resetLoading() {
    isLoading = true;
    update();
  }
}
