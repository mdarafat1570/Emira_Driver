import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/controller/dashboard/dashboard_controller.dart';
import 'package:ovoride_driver/data/controller/pusher/global_pusher_controller.dart';
import 'package:ovoride_driver/data/controller/ride/accept_ride/active_ride_controller.dart';
import 'package:ovoride_driver/data/controller/ride/accepted_ride/accepted_ride_controller.dart';
import 'package:ovoride_driver/data/controller/ride/complete_ride/complete_ride_controller.dart';
import 'package:ovoride_driver/data/controller/running_ride/running_ride_controller.dart';
import 'package:ovoride_driver/data/repo/dashboard/dashboard_repo.dart';
import 'package:ovoride_driver/data/repo/ride/ride_repo.dart';
import 'package:ovoride_driver/presentation/components/annotated_region/annotated_region_widget.dart';
import 'package:ovoride_driver/presentation/components/bottom-nav-bar/nav_bar_item_widget.dart';
import 'package:ovoride_driver/presentation/screens/ride_history/intercity_ride_screen.dart';
import 'package:ovoride_driver/presentation/screens/ride_history/ride_screen.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_images.dart';
import 'package:ovoride_driver/presentation/components/will_pop_widget.dart';
import 'package:ovoride_driver/presentation/screens/profile_and_settings/profile_and_settings_screen.dart';
import 'package:ovoride_driver/presentation/screens/rides/new_rides/new_ride_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  void initState() {
    Get.put(RideRepo(apiClient: Get.find()));
    Get.put(DashBoardRepo(apiClient: Get.find()));
    Get.put(DashBoardController(repo: Get.find()));
    var globalPusherController = Get.put(GlobalPusherController(apiClient: Get.find(), dashBoardController: Get.find()));
    Get.put(AcceptedRideController(repo: Get.find()));
    Get.put(ActiveRideController(repo: Get.find()));
    Get.put(RunningRideController(repo: Get.find()));
    Get.put(AllRideController(repo: Get.find()));
    //
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      globalPusherController.ensureConnection();
    });
  }

  int selectedIndex = 0;

  List<Widget> screens = [
    NewRidesScreen(),
    CityRideScreen(isShowBackButton: false),
    InterCityRideScreen(isShowBackButton: false),
    ProfileAndSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      child: GetBuilder<DashBoardController>(
        builder: (controller) => Scaffold(
            extendBody: true,
            body: screens[selectedIndex],
            bottomNavigationBar: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              child: AnnotatedRegionWidget(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                  margin: const EdgeInsets.only(bottom: 13, left: 10, right: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: const [BoxShadow(color: Color.fromARGB(20, 0, 0, 0), offset: Offset(0, 3), blurRadius: 1)],
                  ),
                  height: 55,
                  width: Get.context?.width ?? double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      NavBarItem(
                        label: MyStrings.newRide.tr,
                        imagePath: MyImages.homeImage,
                        index: 1,
                        isSelected: selectedIndex == 0,
                        press: () {
                          selectedIndex = 0;
                          controller.selectedIndex = 0;
                          setState(() {});
                        },
                      ),
                      NavBarItem(
                        label: MyStrings.cityRide.tr,
                        imagePath: MyImages.city,
                        index: 0,
                        isSelected: selectedIndex == 1,
                        press: () {
                          Get.find<AcceptedRideController>().resetLoading();
                          Get.find<ActiveRideController>().resetLoading();
                          Get.find<RunningRideController>().resetLoading();
                          Get.find<AllRideController>().resetLoading();
                          selectedIndex = 1;
                          controller.selectedIndex = 1;
                          setState(() {});
                        },
                      ),
                      NavBarItem(
                        label: MyStrings.interCityRide.tr,
                        imagePath: MyImages.intercity,
                        index: 2,
                        isSelected: selectedIndex == 2,
                        press: () {
                          Get.find<AcceptedRideController>().resetLoading();
                          Get.find<ActiveRideController>().resetLoading();
                          Get.find<RunningRideController>().resetLoading();
                          Get.find<AllRideController>().resetLoading();
                          selectedIndex = 2;
                          controller.selectedIndex = 2;
                          setState(() {});
                        },
                      ),
                      NavBarItem(
                        label: MyStrings.menu.tr,
                        imagePath: MyImages.menu,
                        index: 2,
                        isSelected: selectedIndex == 3,
                        press: () {
                          selectedIndex = 3;
                          controller.selectedIndex = 3;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
