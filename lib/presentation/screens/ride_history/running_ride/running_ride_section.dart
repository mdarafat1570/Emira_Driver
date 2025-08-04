import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/data/controller/running_ride/running_ride_controller.dart';
import 'package:ovoride_driver/data/repo/ride/ride_repo.dart';
import 'package:ovoride_driver/presentation/components/shimmer/ride_shimmer.dart';
import 'package:ovoride_driver/presentation/screens/ride_history/running_ride/widget/running_ride_card.dart';

import '../../../../core/utils/my_strings.dart';
import '../../../components/no_data.dart';

class RunningRideSection extends StatefulWidget {
  bool isInterCity;
  RunningRideSection({super.key, required this.isInterCity});

  @override
  State<RunningRideSection> createState() => _RunningRideSectionState();
}

class _RunningRideSectionState extends State<RunningRideSection> {
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {}
  }

  @override
  void initState() {
    Get.put(RideRepo(apiClient: Get.find()));
    final controller = Get.put(RunningRideController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      controller.loadData(widget.isInterCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RunningRideController>(builder: (controller) {
      return RefreshIndicator(
        onRefresh: () async {
          controller.getRunningRideList(p: 1, shouldLoading: true);
        },
        child: controller.isLoading
            ? SingleChildScrollView(
                child: Column(
                  children: List.generate(10, (index) => const RideShimmer()),
                ),
              )
            : controller.runningRideList.isEmpty && controller.isLoading == false
                ? const NoDataWidget(isRide: true, text: MyStrings.sorryThereIsNoPendingRideFound)
                : Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.space15),
                          itemCount: controller.runningRideList.length,
                          itemBuilder: (c, index) {
                            return RunningRideCard(
                              currency: controller.defaultCurrencySymbol,
                              isActive: false,
                              ride: controller.runningRideList[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      );
    });
  }
}
