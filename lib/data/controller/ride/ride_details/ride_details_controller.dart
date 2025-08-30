import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/app_status.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/data/controller/map/ride_map_controller.dart';
import 'package:ovoride_driver/data/model/authorization/authorization_response_model.dart';
import 'package:ovoride_driver/data/model/global/response_model/response_model.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/data/model/ride/ride_details_response_model.dart';
import 'package:ovoride_driver/data/repo/ride/ride_repo.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovoride_driver/presentation/screens/ride_details/widgets/payment_receive_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class RideDetailsController extends GetxController {
  RideRepo repo;
  RideMapController mapController;
  RideDetailsController({required this.repo, required this.mapController});

  RideModel ride = RideModel(id: '-1');

  bool isCashPaymentRequest = false;

  void updateRide(RideModel newRide) {
    ride = newRide;
    update();
    printX('update ride from event');
  }

  String currency = '';
  String currencySym = '';
  String userImageUrl = '';
  bool isLoading = true;
  bool isRunning = false;
  LatLng pickupLatLng = const LatLng(0, 0);
  LatLng destinationLatLng = const LatLng(0, 0);

  Future<void> getRideDetails(String id, {bool shouldLoading = true}) async {
    currency = repo.apiClient.getCurrency();
    currencySym = repo.apiClient.getCurrency(isSymbol: true);
    isLoading = shouldLoading;
    update();

    try {
      ResponseModel responseModel = await repo.getRideDetails(id);
      if (responseModel.statusCode == 200) {
        RideDetailsResponseModel model = RideDetailsResponseModel.fromJson((responseModel.responseJson));
        if (model.status == MyStrings.success) {
          RideModel? tRide = model.data?.ride;
          userImageUrl = model.data?.userImagePath ?? '';
          if (tRide != null) {
            ride = tRide;
            isRunning = tRide.isRunning == '1' ? true : false;
            pickupLatLng = LatLng(StringConverter.formatDouble(tRide.pickupLatitude.toString(), precision: 16), StringConverter.formatDouble(tRide.pickupLongitude.toString(), precision: 16));
            destinationLatLng = LatLng(StringConverter.formatDouble(tRide.destinationLatitude.toString(), precision: 16), StringConverter.formatDouble(tRide.destinationLongitude.toString(), precision: 16));
          }
          update();
          mapController.loadMap(pickup: pickupLatLng, destination: destinationLatLng);
          if (ride.isRunning == "1" || ride.status == "1") {
            await mapController.setCustomMarkerIcon(isRunning: true);
          }
          if (ride.paymentStatus == "3" && shouldLoading == true) {
            onShowPaymentDialog(Get.context!);
          }
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    } finally {
      isLoading = false;
      update();
    }
  }

  TextEditingController otpController = TextEditingController();

  bool isStartBtnLoading = false;
  bool isRideStart = false;
  Future<void> startRide(String rideId) async {
    isStartBtnLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.startRide(id: ride.id ?? '-1', otp: otpController.text);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson((responseModel.responseJson));
        if (model.status == MyStrings.success) {
          isRideStart = true;
          CustomSnackBar.success(successList: model.message ?? [MyStrings.success]);
          getRideDetails(rideId, shouldLoading: false);
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
    isStartBtnLoading = false;
    otpController.text = '';
    update();
  }

  bool isEndBtnLoading = false;

  Future<void> endRide(String rideId) async {
    isEndBtnLoading = true;
    update();
    try {
      ResponseModel responseModel = await repo.endRide(id: rideId);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson((responseModel.responseJson));
        if (model.status == MyStrings.success) {
          getRideDetails(rideId, shouldLoading: false);
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

  bool isCancelBtnLoading = false;
  Future<void> cancelRide() async {
    isCancelBtnLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.endRide(id: ride.id ?? '');
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson((responseModel.responseJson));
        if (model.status == MyStrings.success) {
          Get.back();
          CustomSnackBar.success(successList: model.message ?? [MyStrings.success]);
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    }
    isCancelBtnLoading = false;
    update();
  }

  bool isAcceptPaymentBtnLoading = false;
  Future<void> acceptPaymentRide(String rideId, BuildContext context) async {
    isAcceptPaymentBtnLoading = true;
    update();
    try {
      ResponseModel responseModel = await repo.acceptCashPayment(id: rideId);
      if (responseModel.statusCode == 200) {
        RideDetailsResponseModel model = RideDetailsResponseModel.fromJson((responseModel.responseJson));
        if (model.status == MyStrings.success) {
          isCashPaymentRequest = false;
          RideModel? tRide = model.data?.ride;
          if (tRide != null) {
            ride = tRide;
          }
          update();
          CustomSnackBar.success(successList: model.message ?? [MyStrings.success]);
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    } finally {
      Get.back();
      isAcceptPaymentBtnLoading = false;
      update();
    }
  }

  TextEditingController reviewMsgController = TextEditingController();
  double rating = 0.0;
  void updateRating(double rate) {
    rating = rate;
    update();
  }

  bool isReviewLoading = false;
  Future<void> reviewRide(String rideId) async {
    isReviewLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.reviewRide(id: rideId, rating: rating.toString(), review: reviewMsgController.text);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson((responseModel.responseJson));
        if (model.status == MyStrings.success) {
          Get.back();
          printX(model.status);
          reviewMsgController.text = '';
          rating = 0.0;
          update();
          Get.offAllNamed(RouteHelper.allRideScreen);
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

  void onShowPaymentDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return PaymentReceiveDialog();
        });
  }

  Future<void> updateLocation() async {
    try {
      ResponseModel responseModel = await repo.updateLocation(id: ride.id ?? '');
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson((responseModel.responseJson));
        if (model.status == MyStrings.success) {
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
    isReviewLoading = false;
    update();
  }

//
  void changeCashPaymentRequest(bool value) {
    isCashPaymentRequest = value;
    update();
  }

  //

  Future<void> openGoogleMaps() async {
    final String pickup = UrlContainer.googleDirection.replaceAll("{lat}", "${ride.pickupLatitude},").replaceAll("{long}", ride.pickupLongitude.toString());
    final String destination = UrlContainer.googleDirection.replaceAll("{lat}", "${ride.destinationLatitude},").replaceAll("{long}", ride.destinationLongitude.toString());

    final String url = UrlContainer.googleDirection.replaceAll("{lat}", "${ride.pickupLatitude},").replaceAll("{long}", ride.pickupLongitude.toString());

    printX("URL>>> $url");

    if (await canLaunchUrl(Uri.parse(ride.status == AppStatus.RIDE_RUNNING ? destination : pickup))) {
      await launchUrl(Uri.parse(ride.status == AppStatus.RIDE_RUNNING ? destination : pickup), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open Google Maps.';
    }
  }
}
