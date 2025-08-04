import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/core/utils/util.dart';
import 'package:ovoride_driver/presentation/components/app-bar/action_button_icon_widget.dart';
import 'package:ovoride_driver/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:ovoride_driver/presentation/components/image/my_network_image_widget.dart';
import 'package:ovoride_driver/presentation/components/text/label_text.dart';
import 'package:ovoride_driver/presentation/screens/deposits/new_deposit/widget/payment_method_list_bottom_sheet.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../data/controller/deposit/add_new_deposit_controller.dart';
import '../../../../data/repo/deposit/deposit_repo.dart';
import '../../../components/app-bar/custom_appbar.dart';
import '../../../components/buttons/rounded_button.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/text-form-field/custom_amount_text_field.dart';
import 'info_widget.dart';

class NewDepositScreen extends StatefulWidget {
  const NewDepositScreen({super.key});

  @override
  State<NewDepositScreen> createState() => _NewDepositScreenState();
}

class _NewDepositScreenState extends State<NewDepositScreen> {
  @override
  void initState() {
    Get.put(DepositRepo(apiClient: Get.find()));
    final controller = Get.put(AddNewDepositController(depositRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getDepositMethod();
    });
  }

  @override
  void dispose() {
    Get.find<AddNewDepositController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNewDepositController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(
          title: MyStrings.deposit,
          actionsWidget: [
            ActionButtonIconWidget(
              pressed: () {
                Get.toNamed(RouteHelper.depositsScreen);
              },
              icon: Icons.history,
            ),
          ],
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : SingleChildScrollView(
                padding: Dimensions.screenPaddingHV,
                child: Form(
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
                                CustomBottomSheet(child: PaymentMethodListBottomSheet()).customBottomSheet(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: MyColor.colorWhite,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: MyColor.borderColor, width: .5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        MyImageWidget(
                                          imageUrl: "${UrlContainer.domainUrl}/${controller.imagePath}/${controller.paymentMethod?.method?.image}",
                                          width: 30,
                                          height: 30,
                                          boxFit: BoxFit.fitWidth,
                                          radius: 4,
                                        ),
                                        const SizedBox(width: Dimensions.space10),
                                        Text(
                                          (controller.paymentMethod?.method?.name ?? '').tr,
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
                      controller.paymentMethod?.name != MyStrings.selectOne ? const InfoWidget() : const SizedBox(),
                      const SizedBox(height: 35),
                      RoundedButton(
                        isLoading: controller.submitLoading,
                        text: MyStrings.submit,
                        textColor: MyColor.getTextColor(),
                        width: double.infinity,
                        press: () {
                          controller.submitDeposit();
                        },
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
