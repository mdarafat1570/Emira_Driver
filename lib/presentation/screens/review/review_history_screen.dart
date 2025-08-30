import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/review/review_controller.dart';
import 'package:ovoride_driver/data/repo/review/review_repo.dart';
import 'package:ovoride_driver/presentation/components/divider/custom_spacer.dart';
import 'package:ovoride_driver/presentation/components/image/my_network_image_widget.dart';
import 'package:ovoride_driver/presentation/screens/review/widget/review_list.dart';

import '../../../core/helper/string_format_helper.dart';

class ReviewHistoryScreen extends StatefulWidget {
  const ReviewHistoryScreen({super.key});

  @override
  State<ReviewHistoryScreen> createState() => _ReviewHistoryScreenState();
}

class _ReviewHistoryScreenState extends State<ReviewHistoryScreen> {
  bool isReviewTab = true;
  @override
  void initState() {
    Get.put(ReviewRepo(apiClient: Get.find()));
    final controller = Get.put(ReviewController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      controller.getReview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: CustomAppBar(title: MyStrings.myRatings),
      backgroundColor: MyColor.colorWhite,
      body: GetBuilder<ReviewController>(
        builder: (controller) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: Dimensions.space15, right: Dimensions.space15, top: Dimensions.space15),
              child: Container(
                color: MyColor.colorWhite,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(color: MyColor.primaryColor, shape: BoxShape.circle),
                              child: Icon(Icons.arrow_back_ios, color: MyColor.colorWhite, size: 20),
                            ),
                          ),
                          SizedBox(width: Dimensions.space10),
                        ],
                      ),
                    ),
                    spaceDown(Dimensions.space20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.mediumRadius)),
                      child: Column(
                        children: [
                          MyImageWidget(
                            imageUrl: '${controller.driverImagePath}/${controller.driver?.image}',
                            height: 80,
                            width: 80,
                            radius: 40,
                            isProfile: true,
                          ),
                          spaceDown(Dimensions.space10),
                          Text(controller.driver?.email ?? '', style: lightDefault.copyWith(color: MyColor.bodyText)),
                          Text('${controller.driver?.firstname ?? ''} ${controller.driver?.lastname ?? ''}', style: semiBoldDefault.copyWith(color: MyColor.primaryColor, fontSize: 24)),
                        ],
                      ),
                    ),
                    // spaceDown(Dimensions.space20),
                    RatingBar.builder(
                      initialRating: double.tryParse(controller.driver?.avgRating ?? "0") ?? 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      itemBuilder: (context, _) => const Icon(Icons.star_rate_rounded, color: Colors.amber),
                      ignoreGestures: true,
                      itemSize: 50,
                      onRatingUpdate: (v) {},
                    ),
                    spaceDown(Dimensions.space5),
                    Text('${MyStrings.yourAverageRatingIs.tr} ${double.tryParse(controller.driver?.avgRating ?? "0") ?? 0}'.toCapitalized(), style: boldDefault.copyWith(color: MyColor.getBodyTextColor().withValues(alpha: 0.8))),
                    spaceDown(Dimensions.space20),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(MyStrings.riderReviews.tr, style: boldOverLarge.copyWith(fontWeight: FontWeight.w400, color: MyColor.getHeadingTextColor())),
                    ),
                    spaceDown(Dimensions.space20),
                    MyReviewList(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
