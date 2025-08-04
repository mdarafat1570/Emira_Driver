import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/my_images.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/core/utils/util.dart';
import 'package:ovoride_driver/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/image/my_network_image_widget.dart';
import 'package:ovoride_driver/presentation/components/text/label_text.dart';
import 'package:ovoride_driver/presentation/screens/withdraw/add_withdraw_screen/widget/withdraw_method_list_bottom_sheet.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../data/controller/withdraw/add_new_withdraw_controller.dart';
import '../../../../data/repo/withdraw/withdraw_repo.dart';
import '../../../components/app-bar/custom_appbar.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/text-form-field/custom_amount_text_field.dart';
import '../../../components/text-form-field/custom_drop_down_button_with_text_field2.dart';
import 'info_widget.dart';

class AddWithdrawMethod extends StatefulWidget {
  const AddWithdrawMethod({super.key});

  @override
  State<AddWithdrawMethod> createState() => _AddWithdrawMethodState();
}

class _AddWithdrawMethodState extends State<AddWithdrawMethod> {
  @override
  void initState() {
    Get.put(WithdrawRepo(apiClient: Get.find()));
    final controller = Get.put(AddNewWithdrawController(
      repo: Get.find(),
    ));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadDepositMethod();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNewWithdrawController>(builder: (controller) {
      return Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(
          title: MyStrings.addWithdraw.tr,
          actionsWidget: [
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.withdrawScreen);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 7, right: 10, bottom: 7, top: 7),
                padding: const EdgeInsets.all(Dimensions.space7),
                decoration: const BoxDecoration(color: MyColor.colorWhite, shape: BoxShape.circle),
                child: const Icon(Icons.history, color: MyColor.primaryColor, size: 15),
              ),
            ),
          ],
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: Dimensions.screenPaddingHV1,
                  decoration: BoxDecoration(
                    color: MyColor.getScreenBgColor(),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: MyColor.colorWhite,
                          boxShadow: MyUtils.getShadow2(blurRadius: 10),
                          borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelText(text: MyStrings.paymentMethod.tr),
                            const SizedBox(height: Dimensions.space10),
                            GestureDetector(
                              onTap: () {
                                CustomBottomSheet(child: WithdrawMethodListBottomSheet()).customBottomSheet(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: MyColor.colorWhite,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: MyColor.borderColor, width: .5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        controller.withdrawMethod?.id == -1
                                            ? Image.asset(
                                                MyImages.amount,
                                                width: Dimensions.space35,
                                                height: Dimensions.space35,
                                                fit: BoxFit.fitWidth,
                                                color: MyColor.primaryColor,
                                              )
                                            : MyImageWidget(
                                                imageUrl: "${UrlContainer.domainUrl}/${controller.imagePath}/${controller.withdrawMethod?.image}",
                                                width: 30,
                                                height: 30,
                                                boxFit: BoxFit.fitWidth,
                                                radius: 4,
                                              ),
                                        const SizedBox(width: Dimensions.space10),
                                        Text(
                                          (controller.withdrawMethod?.name ?? '').tr,
                                          style: regularDefault,
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_drop_down, color: MyColor.iconColor),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: Dimensions.space15),
                            CustomAmountTextField(
                              labelText: MyStrings.amount.tr,
                              hintText: MyStrings.enterAmount.tr,
                              inputAction: TextInputAction.done,
                              currency: controller.currency,
                              controller: controller.amountController,
                              onChanged: (value) {
                                if (value.toString().isEmpty) {
                                  controller.changeInfoWidgetValue(0);
                                } else {
                                  double amount = double.tryParse(value.toString()) ?? 0;
                                  controller.changeInfoWidgetValue(amount);
                                }
                                return;
                              },
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: controller.authorizationList.length > 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Dimensions.space15),
                            CustomDropDownTextField2(
                              labelText: MyStrings.authorizationMethod.tr,
                              selectedValue: controller.selectedAuthorizationMode,
                              onChanged: (value) {
                                controller.changeAuthorizationMode(value);
                              },
                              items: controller.authorizationList.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text((value.toString()).tr, style: regularDefault.copyWith(color: MyColor.getTextColor())),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      controller.mainAmount > 0 ? const InfoWidget() : const SizedBox.shrink(),
                      const SizedBox(height: Dimensions.space30),
                      RoundedButton(
                        isLoading: controller.submitLoading,
                        text: MyStrings.submit.tr,
                        press: () {
                          controller.submitWithdrawRequest();
                        },
                      ),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
