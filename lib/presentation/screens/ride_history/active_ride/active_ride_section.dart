import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/data/controller/ride/accept_ride/active_ride_controller.dart';
import 'package:ovoride_driver/data/repo/ride/ride_repo.dart';
import 'package:ovoride_driver/presentation/components/shimmer/ride_shimmer.dart';
import 'package:ovoride_driver/presentation/screens/ride_history/active_ride/widget/active_ride_card.dart';

import '../../../../core/utils/my_strings.dart';
import '../../../components/no_data.dart';

class ActiveRideSection extends StatefulWidget {
  bool isInterCity;
  ActiveRideSection({super.key, required this.isInterCity});

  @override
  State<ActiveRideSection> createState() => _ActiveRideSectionState();
}

class _ActiveRideSectionState extends State<ActiveRideSection> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Get.put(RideRepo(apiClient: Get.find()));
    final controller = Get.put(ActiveRideController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      controller.initialData(widget.isInterCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActiveRideController>(builder: (controller) {
      return RefreshIndicator(
        onRefresh: () async {
          controller.getActiveRideList(p: 1, shouldLoading: true);
        },
        child: controller.isLoading
            ? SingleChildScrollView(
                child: Column(
                  children: List.generate(10, (index) => const RideShimmer()),
                ),
              )
            : controller.pendingRides.isEmpty && controller.isLoading == false
                ? const NoDataWidget(
                    isRide: true,
                    text: MyStrings.sorryThereIsNoPendingRideFound,
                  )
                : Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.space15),
                          itemCount: controller.pendingRides.length,
                          itemBuilder: (c, index) {
                            return ActiveRidesCard(
                              currency: controller.defaultCurrencySymbol,
                              isActive: false,
                              ride: controller.pendingRides[index],
                              imageUrl: '${UrlContainer.domainUrl}/${controller.imagePath}/${controller.pendingRides[index].user?.avatar}',
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
