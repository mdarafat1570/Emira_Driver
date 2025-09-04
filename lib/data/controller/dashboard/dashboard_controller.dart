import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/shared_preference_helper.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
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

    // Initialize location with context from Get
    await checkPermissionWithDialog(Get.context!);

    runningRide = RideModel(id: "-1");
    isLoading = shouldLoad;
    update();
    await loadData();
    isLoading = false;
    update();
  }

  GlobalDriverInfo driver = GlobalDriverInfo(id: '-1');

  /// Enhanced location permission handling with user-friendly dialogs
  Future<bool> checkPermissionWithDialog(BuildContext context) async {
    try {
      var status = await Geolocator.checkPermission();
      printX("Current location permission status: $status");

      if (status == LocationPermission.whileInUse || status == LocationPermission.always) {
        await getCurrentLocation();
        return true;
      }

      if (status == LocationPermission.deniedForever) {
        await _showSettingsDialog(context);
        return false;
      }

      // Show permission request dialog for better UX
      bool? userAccepted = await _showLocationPermissionDialog(context);

      if (userAccepted == true) {
        var requestStatus = await Geolocator.requestPermission();
        printX("Permission request result: $requestStatus");

        if (requestStatus == LocationPermission.whileInUse ||
            requestStatus == LocationPermission.always) {
          await getCurrentLocation();
          return true;
        } else if (requestStatus == LocationPermission.deniedForever) {
          CustomSnackBar.error(
            errorList: ["Location permission is permanently denied. Please enable it from settings."],
          );
        } else {
          CustomSnackBar.error(errorList: ["Location access is required for driver operations"]);
        }
      } else {
        CustomSnackBar.error(errorList: ["Location access is required to accept rides and navigate"]);
      }

      return false;
    } catch (e) {
      printX("Error in location permission: ${e.toString()}");
      CustomSnackBar.error(errorList: ["Failed to request location permission. Please try again."]);
      return false;
    }
  }

  /// Show location permission request dialog
  Future<bool?> _showLocationPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),

                Text("Driver Location Required",
                    style: boldLarge, textAlign: TextAlign.center),
                const SizedBox(height: 16),

                Text(
                  "As a driver, location access is essential for:\n\n"
                      "🚗 Accepting nearby ride requests\n"
                      "📍 Real-time navigation to passengers\n"
                      "⭐ Providing accurate arrival times\n"
                      "🛡️ Enhanced safety and tracking",
                  style: boldLarge.copyWith(fontSize: 14, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                Text(
                  "Your location helps us match you with nearby passengers and ensures safe, efficient rides.",
                  style: boldSmall.copyWith(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey[400]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Not Now",
                          style: boldSmall.copyWith(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Allow Button
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: MyColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Enable Location",
                          style: boldSmall.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show settings dialog for permanently denied permission (don't open settings)
  Future<void> _showSettingsDialog(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_off,
                  color: Colors.orange,
                  size: 36,
                ),
                const SizedBox(height: 16),
                Text(
                  "Location Access Denied",
                  style: boldLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Location permission has been permanently denied. You can manually enable it in your device settings if you change your mind.\n\nWithout location access, you won't be able to receive ride requests or navigate to passengers.",
                  style: boldSmall.copyWith(fontSize: 14, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColor.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "I Understand",
                      style: boldSmall.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getCurrentLocation() async {
    try {
      printX('Starting driver location request...');

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      printX('Location services enabled: $serviceEnabled');

      if (!serviceEnabled) {
        CustomSnackBar.error(
          errorList: ["Location services are disabled. Please enable them in your device settings."],
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      printX('Current permission status: $permission');

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        CustomSnackBar.error(
          errorList: ["Location permission is required for driver operations."],
        );
        return;
      }

      printX('Getting driver current position...');

      currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
          timeLimit: const Duration(seconds: 15),
        ),
      );

      printX('Driver position obtained: ${currentPosition!.latitude}, ${currentPosition!.longitude}');

      try {
        printX('Getting address from coordinates...');
        final placemarks = await placemarkFromCoordinates(
          currentPosition!.latitude,
          currentPosition!.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks[0];
          List<String> addressParts = [];

          if (place.street?.isNotEmpty == true) addressParts.add(place.street!);
          if (place.subThoroughfare?.isNotEmpty == true) addressParts.add(place.subThoroughfare!);
          if (place.thoroughfare?.isNotEmpty == true) addressParts.add(place.thoroughfare!);
          if (place.locality?.isNotEmpty == true) addressParts.add(place.locality!);
          if (place.country?.isNotEmpty == true) addressParts.add(place.country!);

          currentAddress = addressParts.isNotEmpty
              ? addressParts.join(', ')
              : "Driver location found (${currentPosition!.latitude.toStringAsFixed(4)}, ${currentPosition!.longitude.toStringAsFixed(4)})";

          printX('Driver address resolved: $currentAddress');
        } else {
          currentAddress = "Driver location found (${currentPosition!.latitude.toStringAsFixed(4)}, ${currentPosition!.longitude.toStringAsFixed(4)})";
          printX('No placemarks found for driver, using coordinates');
        }
      } catch (addressError) {
        printX('Driver address resolution failed: $addressError');
        currentAddress = "Driver location found (${currentPosition!.latitude.toStringAsFixed(4)}, ${currentPosition!.longitude.toStringAsFixed(4)})";
      }

      update();
      printX('Driver location update completed: $currentAddress');

    } catch (e) {
      printX('Driver location error details: $e');

      String errorMessage = "Failed to get driver location.";

      if (e.toString().contains('timeout')) {
        errorMessage = "Location request timed out. Please try again.";
      } else if (e.toString().contains('network')) {
        errorMessage = "Network error while getting location. Check your internet connection.";
      } else if (e.toString().contains('permission')) {
        errorMessage = "Location permission denied. Please enable it for driver operations.";
      } else if (e.toString().contains('disabled')) {
        errorMessage = "Location services are disabled. Please enable them.";
      }

      CustomSnackBar.error(errorList: [errorMessage]);
    }
  }

  List<RideModel> rideList = [];
  List<RideModel> pendingRidesList = [];
  RideModel? runningRide;
  bool isLoaderLoading = false;

  Future<void> onlineStatus({bool isFromRideDetails = false}) async {
    // Check location permission first
    bool hasPermission = await checkPermissionWithDialog(Get.context!);

    if (!hasPermission) {
      CustomSnackBar.error(errorList: [MyStrings.pleaseEnableLocationPermission.tr]);
      return;
    }

    try {
      ResponseModel responseModel = await repo.onlineStatus(
          lat: currentPosition?.latitude.toString() ?? "",
          long: currentPosition?.longitude.toString() ?? ""
      );

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

  /// Refresh location manually
  Future<void> refreshLocation() async {
    currentAddress = "${MyStrings.loading.tr}...";
    update();
    await getCurrentLocation();
  }
}