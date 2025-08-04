import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/controller/ride/ride_screen_settings_controller.dart';
import 'package:ovoride_driver/presentation/components/app-bar/custom_appbar.dart';
import 'package:ovoride_driver/presentation/screens/ride_history/accepted_ride_section/accepted_ride_section.dart';
import 'package:ovoride_driver/presentation/screens/ride_history/active_ride/active_ride_section.dart';
import 'package:ovoride_driver/presentation/screens/ride_history/all_ride/all_ride_section.dart';
import 'package:ovoride_driver/presentation/screens/ride_history/running_ride/running_ride_section.dart';

class CityRideScreen extends StatefulWidget {
  final bool isShowBackButton;

  const CityRideScreen({super.key, required this.isShowBackButton});

  @override
  State<CityRideScreen> createState() => _CityRideScreenState();
}

class _CityRideScreenState extends State<CityRideScreen> {
  @override
  void initState() {
    Get.put(RideScreenSettingsController());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(),
      appBar: CustomAppBar(
        bgColor: MyColor.primaryColor,
        title: MyStrings.cityRide.tr,
        isShowBackBtn: widget.isShowBackButton,
      ),
      body: GetBuilder<RideScreenSettingsController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Column(
              children: [
                DefaultTabController(
                  length: 4,
                  initialIndex: controller.selectedTab,
                  child: Container(
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: MyColor.colorWhite))),
                    child: TabBar(
                      physics: const BouncingScrollPhysics(),
                      dividerColor: MyColor.borderColor,
                      indicator: const BoxDecoration(border: Border(bottom: BorderSide(color: MyColor.primaryColor, width: 2))),
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: MyColor.primaryColor,
                      unselectedLabelColor: MyColor.colorBlack,
                      onTap: (i) {
                        controller.changeTab(i);
                      },
                      tabs: [
                        Tab(text: MyStrings.allRide.tr),
                        Tab(text: MyStrings.accepted.tr),
                        Tab(text: MyStrings.activeRide.tr),
                        Tab(text: MyStrings.runningRide.tr),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space10),
                    child: Builder(
                      builder: (context) {
                        if (controller.selectedTab == 0) {
                          return AllRideSection(isInterCity: false);
                        }
                        if (controller.selectedTab == 1) {
                          return AcceptedRideSection(isInterCity: false);
                        }
                        if (controller.selectedTab == 2) {
                          return ActiveRideSection(isInterCity: false);
                        } else {
                          return RunningRideSection(isInterCity: false);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
