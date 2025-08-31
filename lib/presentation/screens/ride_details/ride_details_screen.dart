import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:ovoride_driver/core/utils/app_status.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_animation.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/data/controller/map/ride_map_controller.dart';
import 'package:ovoride_driver/data/controller/pusher/pusher_ride_controller.dart';
import 'package:ovoride_driver/data/controller/ride/ride_details/ride_details_controller.dart';
import 'package:ovoride_driver/data/controller/ride/ride_meassage/ride_meassage_controller.dart';
import 'package:ovoride_driver/data/repo/meassage/meassage_repo.dart';
import 'package:ovoride_driver/data/repo/ride/ride_repo.dart';
import 'package:ovoride_driver/presentation/screens/ride_details/section/ride_details_bottom_sheet_section.dart';
import 'package:ovoride_driver/presentation/screens/ride_details/widgets/poly_line_map.dart';

class RideDetailsScreen extends StatefulWidget {
  final String rideId;

  const RideDetailsScreen({super.key, required this.rideId});

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  Timer? time;
  DraggableScrollableController draggableScrollableController = DraggableScrollableController();

  @override
  void initState() {
    Get.put(RideRepo(apiClient: Get.find()));
    Get.put(RideMapController());
    Get.put(MessageRepo(apiClient: Get.find()));
    Get.put(RideMessageController(repo: Get.find()));
    final controller = Get.put(RideDetailsController(repo: Get.find(), mapController: Get.find()));
    Get.put(PusherRideController(apiClient: Get.find(), controller: Get.find(), detailsController: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await controller.getRideDetails(widget.rideId);
      Get.find<PusherRideController>().ensureConnection();
      if (controller.ride.status == AppStatus.RIDE_ACTIVE) {
        time = Timer.periodic(Duration(seconds: 30), (timer) {
          controller.updateLocation();
        });
      }
      if (controller.ride.paymentStatus == "2" && controller.ride.paymentStatus != "1") {
        //  controller.onShowPaymentDialog(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    time?.cancel();
    // Get.find<PusherRideController>().clearData();
  }

  Future _zoomBasedOnExtent(double extent) async {
    var controller = Get.find<RideMapController>();
    var polylinePoints = controller.polylineCoordinates;
    if (controller.mapController == null || polylinePoints.isEmpty) return;
    // If sheet is small (below 0.5), fit the map to show the entire polyline
    // If sheet is large (above 0.5), focus on specific part of the route
    if (extent > 0.5) {
      //   // Bottom sheet is smaller/lower, fit polyline to view
      controller.fitPolylineBounds(polylinePoints);
    } else {
      controller.mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: polylinePoints[polylinePoints.length ~/ 2], zoom: 12 - (extent - 0.35) * 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideDetailsController>(
      builder: (controller) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (bool didPop, d) async {
              if (didPop) return;
              Get.back();
            },
            child: Scaffold(
              body: Stack(
                children: [
                  controller.isLoading ? Container(height: context.height, width: double.infinity, color: MyColor.colorWhite, child: LottieBuilder.asset(MyAnimation.map)) : const PolyLineMapScreen(),
                  Positioned(
                    top: 0,
                    child: SafeArea(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.space10),
                          decoration: BoxDecoration(color: MyColor.primaryColor, borderRadius: BorderRadius.circular(20)),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: MyColor.colorWhite, size: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bottomSheet: controller.isLoading
                  ? Container(color: MyColor.colorWhite, height: context.height / 4, child: const SizedBox.shrink())
                  : AnimatedPadding(
                      padding: EdgeInsetsDirectional.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.decelerate,
                      child: DraggableScrollableSheet(
                        controller: draggableScrollableController,
                        snap: true,
                        shouldCloseOnMinExtent: true,
                        expand: false,
                        initialChildSize: 0.5, // initial height (percentage of screen height)
                        minChildSize: 0.4, // minimum height when fully collapsed
                        maxChildSize: 0.65, // maximum height when fully expanded
                        snapSizes: [0.4, 0.5, 0.65],
                        builder: (context, scrollController) {
                          return NotificationListener<DraggableScrollableNotification>(
                            onNotification: (notification) {
                              _zoomBasedOnExtent(notification.extent);
                              return true;
                            },
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return RideDetailsBottomSheetSection(scrollController: scrollController, constraints: constraints, draggableScrollableController: draggableScrollableController);
                              },
                            ),
                          );
                        },
                      ),
                    ),
              floatingActionButton: controller.isLoading
                  ? SizedBox.shrink()
                  : InkWell(
                      onTap: () {
                        controller.openGoogleMaps();
                      },
                      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25), side: BorderSide.none),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: controller.ride.status == AppStatus.RIDE_RUNNING ? MyColor.primaryColor : MyColor.colorBlack,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(controller.ride.status == AppStatus.RIDE_RUNNING ? CupertinoIcons.location_fill : CupertinoIcons.location, color: MyColor.colorWhite),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
