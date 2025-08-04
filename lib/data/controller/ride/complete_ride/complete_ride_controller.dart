import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/model/authorization/authorization_response_model.dart';
import 'package:ovoride_driver/data/model/global/response_model/response_model.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/data/model/ride/complete_ride_response_model.dart';
import 'package:ovoride_driver/data/repo/ride/ride_repo.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';

import '../../../../core/route/route.dart';

class AllRideController extends GetxController {
  RideRepo repo;
  AllRideController({required this.repo});

  bool isLoading = true;

  TextEditingController reviewMsgController = TextEditingController();
  double rating = 0.0;

  String imagePath = "";
  String defaultCurrency = "";
  String defaultCurrencySymbol = "";
  String username = "";
  int page = 0;
  bool isInterCity = false;
  Future<void> initialData(bool isICity) async {
    page = 0;
    rating = 0.0;
    defaultCurrency = repo.apiClient.getCurrency();
    defaultCurrencySymbol = repo.apiClient.getCurrency(isSymbol: true);
    username = repo.apiClient.getUserName();
    allRideList = [];
    isInterCity = isICity;
    update();
  }

  List<RideModel> allRideList = [];
  String? nextPageUrl;
  Future<void> getAllRideList({int? p, bool shouldLoading = true}) async {
    page = p ?? page + 1;
    if (page == 1) {
      allRideList.clear();
      isLoading = true;
      update();
    }

    try {
      ResponseModel responseModel = await repo.getAllRideList(page.toString(), isICity: isInterCity);
      if (responseModel.statusCode == 200) {
        allRideList.clear();
        AllRideResponseModel model = AllRideResponseModel.fromJson((responseModel.responseJson));
        if (model.status == MyStrings.success) {
          imagePath = model.data?.userImagePath ?? '';
          nextPageUrl = model.data?.allRides?.nextPageUrl;
          allRideList.addAll(model.data?.allRides?.data ?? []);
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

  bool isReviewLoading = false;
  Future<void> reviewRide(String rideId, {isFromRideDetails = false}) async {
    isReviewLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.reviewRide(id: rideId, rating: rating.toString(), review: reviewMsgController.text);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson((responseModel.responseJson));

        if (model.status == MyStrings.success) {
          printX(model.status);
          reviewMsgController.text = '';
          rating = 0.0;
          page = 0;
          update();
          if (isFromRideDetails) {
            Get.offAllNamed(RouteHelper.dashboard);
          } else {
            getAllRideList();
            Get.back();
          }
          CustomSnackBar.success(successList: model.message ?? []);
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    }
    isReviewLoading = false;
    update();
  }

  void updateRating(double rate) {
    rating = rate;
    update();
  }

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }

  void resetLoading() {
    isLoading = false;
    update();
  }
}
