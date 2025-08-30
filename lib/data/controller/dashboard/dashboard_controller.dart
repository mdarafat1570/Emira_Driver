import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/shared_preference_helper.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/model/authorization/authorization_response_model.dart';
import 'package:ovoride_driver/data/model/dashboard/dashboard_response_model.dart';
import 'package:ovoride_driver/data/model/global/response_model/response_model.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/data/model/global/user/global_driver_model.dart';
import 'package:ovoride_driver/data/repo/dashboard/dashboard_repo.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/utils/url_container.dart';

class DashBoardController extends GetxController {
  DashBoardRepo repo;
  DashBoardController({required this.repo});
  TextEditingController amountController = TextEditingController();

  int selectedIndex = 0;

  String? profileImageUrl;

  bool isLoading = true;
  Position? currentPosition;
  String currentAddress = "${MyStrings.loading.tr}...";
  bool userOnline = true;
  String? nextPageUrl;
  int page = 0;
  double mainAmount = 0;

  bool isDriverVerified = true;
  bool isVehicleVerified = true;

  bool isVehicleVerificationPending = false;
  bool isDriverVerificationPending = false;

  String currency = '';
  String currencySym = '';
  String userImagePath = '';

  Future<void> initialData({bool shouldLoad = true}) async {
    page = 0;
    mainAmount = 0;
    nextPageUrl;
    amountController.text = '';
    currency = repo.apiClient.getCurrency();
    currencySym = repo.apiClient.getCurrency(isSymbol: true);
    checkPermission();
    runningRide = RideModel(id: "-1");
    isLoading = shouldLoad;
    update();
    await loadData();
    isLoading = false;
    update();
  }

  GlobalDriverInfo driver = GlobalDriverInfo(id: '-1');

  // void checkPermission() async {
  //   var status = await Permission.location.status;
  //   if (!status.isGranted) {
  //     await Permission.location.request().then((value) async {
  //       getCurrentLocation();
  //     }).onError((error, stackTrace) {
  //       CustomSnackBar.error(errorList: ["Please enable your location permission"]);
  //     });
  //   } else {
  //     getCurrentLocation();
  //   }
  // }

  Future<void> checkPermission() async {
    try {
      var status = await Geolocator.requestPermission();
      printX("Location Permission Status: $status");

      if (status == LocationPermission.denied) {
        var requestStatus = await Geolocator.requestPermission();
        if (requestStatus == LocationPermission.whileInUse || requestStatus == LocationPermission.always) {
          getCurrentLocation();
        } else {
          CustomSnackBar.error(errorList: ["Please enable location permission"]);
        }
      } else if (status == LocationPermission.deniedForever) {
        CustomSnackBar.error(errorList: ["Location permission is permanently denied. Please enable it from settings."]);
        await openAppSettings(); // Opens device settings
      } else if (status == LocationPermission.whileInUse) {
        getCurrentLocation();
      }
    } catch (e) {
      printX("Error in location permission: ${e.toString()}");
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
      currentPosition = await geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.best));
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );
      currentAddress = "";
      currentAddress = "${placemarks[0].street} ${placemarks[0].subThoroughfare} ${placemarks[0].thoroughfare},${placemarks[0].subLocality},${placemarks[0].locality},${placemarks[0].country}";

      update();
    } catch (e) {
      printX("Error>>>>>>>: $e");
      CustomSnackBar.error(errorList: [MyStrings.somethingWentWrongWhileTakingLocation]);
    }
  }

  List<RideModel> rideList = [];
  List<RideModel> pendingRidesList = [];
  RideModel? runningRide;
  bool isLoaderLoading = false;
  Future<void> onlineStatus({bool isFromRideDetails = false}) async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      await getCurrentLocation();
    } else {
      await Permission.location.request().then((value) async {
        await getCurrentLocation();
      }).onError((error, stackTrace) {
        CustomSnackBar.error(errorList: [MyStrings.pleaseEnableLocationPermission.tr]);
      });
    }

    try {
      ResponseModel responseModel = await repo.onlineStatus(lat: currentPosition?.latitude.toString() ?? "", long: currentPosition?.longitude.toString() ?? "");
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson((responseModel.responseJson));
        if (model.status == MyStrings.success) {
          if (model.data?.online.toString() == 'true') {
            userOnline = true;
          } else {
            userOnline = false;
          }
          isLoaderLoading = false;
          update();
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    } finally {
      isLoaderLoading = false;
      update();
    }
  }

  void changeOnlineStatus(bool value) {
    userOnline = value;
    update();
    printX('updateOnlineStatus>>>>$value');
    onlineStatus();
  }

  Future<void> loadData() async {
    pendingRidesList = [];
    runningRide = RideModel(id: "-1");
    isLoading = true;
    update();

    rideList.clear();
    isLoading = true;
    update();

    ResponseModel responseModel = await repo.getData();

    if (responseModel.statusCode == 200) {
      DashBoardRideResponseModel model = DashBoardRideResponseModel.fromJson((responseModel.responseJson));
      if (model.status == MyStrings.success) {
        nextPageUrl = model.data?.ride?.nextPageUrl;
        userImagePath = '${UrlContainer.domainUrl}/${model.data?.userImagePath}';
        rideList.addAll(model.data?.ride?.data ?? []);
        pendingRidesList.addAll(model.data?.pendingRides ?? []);

        isDriverVerified = model.data?.driverInfo?.dv == "1" ? true : false;
        isVehicleVerified = model.data?.driverInfo?.vv == "1" ? true : false;

        isVehicleVerificationPending = model.data?.driverInfo?.vv == "2" ? true : false;
        isDriverVerificationPending = model.data?.driverInfo?.dv == "2" ? true : false;

        bool value = model.data?.driverInfo?.onlineStatus == "1" ? true : false;
        userOnline = value;

        driver = model.data?.driverInfo ?? GlobalDriverInfo(id: '-1');
        runningRide = model.data?.runningRide ?? RideModel(id: '-1');
        repo.apiClient.sharedPreferences.setString(SharedPreferenceHelper.userProfileKey, model.data?.driverInfo?.imageWithPath ?? '');

        profileImageUrl = "${UrlContainer.domainUrl}/${model.data?.driverImagePath}/${model.data?.driverInfo?.image}";

        update();
      } else {
        CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    isLoading = false;
    update();
  }

  bool isSendLoading = false;
  Future<void> sendBid(String rideId) async {
    isSendLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.createBid(amount: mainAmount.toString(), id: rideId);
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson((responseModel.responseJson));
        if (model.status == "success") {
          Get.back();
          loadData();
          CustomSnackBar.success(successList: model.message ?? [MyStrings.somethingWentWrong]);
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e);
    }
    isSendLoading = false;
    update();
  }

  void updateMainAmount(double amount) {
    mainAmount = amount;
    amountController.text = StringConverter.formatNumber(amount.toString());
    update();
  }

  Future<void> checkAndGotoMapScreen() async {
    if (runningRide?.id != "-1") {
      Get.toNamed(RouteHelper.rideDetailsScreen, arguments: runningRide?.id ?? '-1');
    }
  }
}
