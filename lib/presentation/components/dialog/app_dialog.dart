import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_images.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';

class AppDialog {
  Future showRideDetailsDialog(
    BuildContext context, {
    required String title,
    required String description,
    required Function() onTap,
    Color? yes,
    Color? no,
  }) {
    return showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
      builder: (_) {
        return Dialog(
          surfaceTintColor: MyColor.transparentColor,
          insetPadding: EdgeInsets.zero,
          backgroundColor: MyColor.transparentColor,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 100),
          child: LayoutBuilder(builder: (context, constraint) {
            return Container(
              padding: const EdgeInsetsDirectional.only(end: Dimensions.space5, start: Dimensions.space5, top: Dimensions.space30, bottom: Dimensions.space20),
              margin: const EdgeInsets.all(Dimensions.space15 + 1),
              decoration: BoxDecoration(
                color: MyColor.colorWhite,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: MyColor.borderColor, width: 0.6),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.minHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(MyImages.warning_, height: 60, width: 60),
                        const SizedBox(height: Dimensions.space20),
                        Text(title, style: semiBoldDefault.copyWith(color: MyColor.titleColor, fontSize: 20), textAlign: TextAlign.center),
                        Text(description, style: lightDefault.copyWith(color: MyColor.bodyText, fontSize: 16), textAlign: TextAlign.center),
                        const SizedBox(height: Dimensions.space20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  borderRadius: BorderRadius.circular(Dimensions.extraRadius),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space12),
                                    decoration: BoxDecoration(
                                      color: MyColor.transparentColor,
                                      borderRadius: BorderRadius.circular(Dimensions.extraRadius),
                                      border: Border.all(color: MyColor.bodyText, width: 0.6),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Cancel",
                                        style: regularDefault.copyWith(
                                          color: MyColor.primaryColor,
                                          fontSize: Dimensions.fontLarge,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: Dimensions.space10),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Get.back();
                                    onTap();
                                  },
                                  borderRadius: BorderRadius.circular(Dimensions.extraRadius),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space12),
                                    decoration: BoxDecoration(color: yes ?? MyColor.primaryColor, borderRadius: BorderRadius.circular(Dimensions.extraRadius)),
                                    child: Center(
                                      child: Text(
                                        MyStrings.confirm.tr,
                                        style: boldDefault.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontLarge),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: Dimensions.space10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
