import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/presentation/components/text/small_text.dart';
import 'package:ovoride_driver/presentation/screens/withdraw/confirm_withdraw_screen/widget/withdraw_file_item.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../data/controller/withdraw/withdraw_confirm_controller.dart';
import '../../../../data/model/global/formdata/global_kyc_form_data.dart';
import '../../../../data/repo/account/profile_repo.dart';
import '../../../components/app-bar/custom_appbar.dart';
import '../../../components/buttons/rounded_button.dart';
import '../../../components/checkbox/custom_check_box.dart';
import '../../../components/custom_drop_down_button_with_text_field.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/custom_radio_button.dart';
import '../../../components/text-form-field/custom_text_field.dart';
import '../../../components/text/label_text_with_instructions.dart';

class WithdrawConfirmScreen extends StatefulWidget {
  const WithdrawConfirmScreen({super.key});

  @override
  State<WithdrawConfirmScreen> createState() => _WithdrawConfirmScreenState();
}

class _WithdrawConfirmScreenState extends State<WithdrawConfirmScreen> {
  String gatewayName = '';

  @override
  void initState() {
    gatewayName = Get.arguments[1];
    dynamic model = Get.arguments[0];

    Get.put(ProfileRepo(apiClient: Get.find()));
    final controller = Get.put(WithdrawConfirmController(repo: Get.find(), profileRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initData(model);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawConfirmController>(
        builder: (controller) => Scaffold(
            backgroundColor: MyColor.colorWhite,
            appBar: const CustomAppBar(title: MyStrings.withdrawConfirm),
            body: controller.isLoading
                ? const CustomLoader()
                : SingleChildScrollView(
                    padding: Dimensions.previewPaddingHV,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 25),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: MyColor.colorWhite, borderRadius: BorderRadius.circular(Dimensions.defaultRadius), border: Border.all(color: MyColor.borderColor, width: 1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: controller.formList.length,
                              itemBuilder: (ctx, index) {
                                GlobalFormModel? model = controller.formList[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    model.type == 'text' || model.type == 'number' || model.type == 'email' || model.type == 'url'
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomTextField(
                                                hintText: (model.name ?? '').toLowerCase().capitalizeFirst,
                                                isShowInstructionWidget: true,
                                                instructions: model.instruction,
                                                needOutlineBorder: true,
                                                labelText: model.name ?? '',
                                                isRequired: model.isRequired == 'optional' ? false : true,
                                                textInputType: model.type == 'number'
                                                    ? TextInputType.number
                                                    : model.type == 'email'
                                                        ? TextInputType.emailAddress
                                                        : model.type == 'url'
                                                            ? TextInputType.url
                                                            : TextInputType.text,
                                                onChanged: (value) {
                                                  controller.changeSelectedValue(value, index);
                                                },
                                                validator: (value) {
                                                  if (model.isRequired != 'optional' && value.toString().isEmpty) {
                                                    return '${model.name.toString().capitalizeFirst} ${MyStrings.isRequired}';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                              const SizedBox(height: Dimensions.space10),
                                            ],
                                          )
                                        : model.type == 'textarea'
                                            ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomTextField(
                                                    instructions: model.instruction,
                                                    needOutlineBorder: true,
                                                    isShowInstructionWidget: true,
                                                    labelText: model.name ?? '',
                                                    isRequired: model.isRequired == 'optional' ? false : true,
                                                    hintText: (model.name ?? '').capitalizeFirst,
                                                    textInputType: TextInputType.multiline,
                                                    maxLines: 5,
                                                    onChanged: (value) {
                                                      controller.changeSelectedValue(value, index);
                                                    },
                                                    validator: (value) {
                                                      if (model.isRequired != 'optional' && value.toString().isEmpty) {
                                                        return '${model.name.toString().capitalizeFirst} ${MyStrings.isRequired}';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),
                                                  const SizedBox(height: Dimensions.space10),
                                                ],
                                              )
                                            : model.type == 'select'
                                                ? Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      LabelTextInstruction(
                                                        text: model.name ?? '',
                                                        isRequired: model.isRequired == 'optional' ? false : true,
                                                        instructions: model.instruction,
                                                      ),
                                                      const SizedBox(
                                                        height: Dimensions.textToTextSpace,
                                                      ),
                                                      CustomDropDownWithTextField(
                                                          list: model.options ?? [],
                                                          onChanged: (value) {
                                                            controller.changeSelectedValue(value, index);
                                                          },
                                                          selectedValue: model.selectedValue),
                                                      const SizedBox(height: Dimensions.space10)
                                                    ],
                                                  )
                                                : model.type == 'radio'
                                                    ? Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          LabelTextInstruction(
                                                            text: model.name ?? '',
                                                            isRequired: model.isRequired == 'optional' ? false : true,
                                                            instructions: model.instruction,
                                                          ),
                                                          CustomRadioButton(
                                                            title: model.name,
                                                            selectedIndex: controller.formList[index].options?.indexOf(model.selectedValue ?? '') ?? 0,
                                                            list: model.options ?? [],
                                                            onChanged: (selectedIndex) {
                                                              controller.changeSelectedRadioBtnValue(index, selectedIndex);
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    : model.type == 'checkbox'
                                                        ? Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              LabelTextInstruction(
                                                                text: model.name ?? '',
                                                                isRequired: model.isRequired == 'optional' ? false : true,
                                                                instructions: model.instruction,
                                                              ),
                                                              CustomCheckBox(
                                                                selectedValue: controller.formList[index].cbSelected,
                                                                list: model.options ?? [],
                                                                onChanged: (value) {
                                                                  controller.changeSelectedCheckBoxValue(index, value);
                                                                },
                                                              ),
                                                            ],
                                                          )
                                                        : model.type == 'file'
                                                            ? Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  LabelTextInstruction(
                                                                    text: model.name ?? '',
                                                                    isRequired: model.isRequired == 'optional' ? false : true,
                                                                    instructions: model.instruction,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(vertical: Dimensions.textToTextSpace),
                                                                    child: WithdrawFileItem(index: index),
                                                                  ),
                                                                ],
                                                              )
                                                            : model.type == 'datetime'
                                                                ? Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.symmetric(vertical: Dimensions.textToTextSpace),
                                                                        child: CustomTextField(
                                                                            isShowInstructionWidget: true,
                                                                            instructions: model.instruction,
                                                                            isRequired: model.isRequired == 'optional' ? false : true,
                                                                            hintText: (model.name ?? '').toString().capitalizeFirst,
                                                                            needOutlineBorder: true,
                                                                            labelText: model.name ?? '',
                                                                            controller: controller.formList[index].textEditingController,
                                                                            textInputType: TextInputType.datetime,
                                                                            readOnly: true,
                                                                            validator: (value) {
                                                                              if (model.isRequired != 'optional' && value.toString().isEmpty) {
                                                                                return '${model.name.toString().capitalizeFirst} ${MyStrings.isRequired}';
                                                                              } else {
                                                                                return null;
                                                                              }
                                                                            },
                                                                            onTap: () {
                                                                              controller.changeSelectedDateTimeValue(index, context);
                                                                            },
                                                                            onChanged: (value) {
                                                                              controller.changeSelectedValue(value, index);
                                                                            }),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : model.type == 'date'
                                                                    ? Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.symmetric(vertical: Dimensions.textToTextSpace),
                                                                            child: CustomTextField(
                                                                                isShowInstructionWidget: true,
                                                                                instructions: model.instruction,
                                                                                isRequired: model.isRequired == 'optional' ? false : true,
                                                                                hintText: (model.name ?? '').toString().capitalizeFirst,
                                                                                needOutlineBorder: true,
                                                                                labelText: model.name ?? '',
                                                                                controller: controller.formList[index].textEditingController,
                                                                                textInputType: TextInputType.datetime,
                                                                                readOnly: true,
                                                                                validator: (value) {
                                                                                  if (model.isRequired != 'optional' && value.toString().isEmpty) {
                                                                                    return '${model.name.toString().capitalizeFirst} ${MyStrings.isRequired}';
                                                                                  } else {
                                                                                    return null;
                                                                                  }
                                                                                },
                                                                                onTap: () {
                                                                                  controller.changeSelectedDateOnlyValue(index, context);
                                                                                },
                                                                                onChanged: (value) {
                                                                                  controller.changeSelectedValue(value, index);
                                                                                }),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : model.type == 'time'
                                                                        ? Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: Dimensions.textToTextSpace),
                                                                                child: CustomTextField(
                                                                                    isShowInstructionWidget: true,
                                                                                    instructions: model.instruction,
                                                                                    isRequired: model.isRequired == 'optional' ? false : true,
                                                                                    hintText: (model.name ?? '').toString().capitalizeFirst,
                                                                                    needOutlineBorder: true,
                                                                                    labelText: model.name ?? '',
                                                                                    controller: controller.formList[index].textEditingController,
                                                                                    textInputType: TextInputType.datetime,
                                                                                    readOnly: true,
                                                                                    validator: (value) {
                                                                                      if (model.isRequired != 'optional' && value.toString().isEmpty) {
                                                                                        return '${model.name.toString().capitalizeFirst} ${MyStrings.isRequired}';
                                                                                      } else {
                                                                                        return null;
                                                                                      }
                                                                                    },
                                                                                    onTap: () {
                                                                                      controller.changeSelectedTimeOnlyValue(index, context);
                                                                                    },
                                                                                    onChanged: (value) {
                                                                                      controller.changeSelectedValue(value, index);
                                                                                    }),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : const SizedBox(),
                                    const SizedBox(height: Dimensions.space10),
                                  ],
                                );
                              }),
                          if (controller.isTFAEnable) ...[
                            const SizedBox(height: Dimensions.space5),
                            SmallText(text: MyStrings.twoFactorAuth),
                            const SizedBox(height: Dimensions.space10),
                            PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: regularDefault.copyWith(color: MyColor.getTextColor()),
                              length: 6,
                              textStyle: regularDefault.copyWith(color: MyColor.getTextColor()),
                              obscureText: false,
                              obscuringCharacter: '*',
                              blinkWhenObscuring: false,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(shape: PinCodeFieldShape.box, borderWidth: 1, borderRadius: BorderRadius.circular(5), fieldHeight: 40, fieldWidth: 40, inactiveColor: MyColor.getTextFieldDisableBorder(), inactiveFillColor: Colors.transparent, activeFillColor: Colors.transparent, activeColor: MyColor.primaryColor, selectedFillColor: Colors.transparent, selectedColor: MyColor.primaryColor),
                              cursorColor: MyColor.colorWhite,
                              animationDuration: const Duration(milliseconds: 100),
                              enableActiveFill: true,
                              keyboardType: TextInputType.number,
                              beforeTextPaste: (text) {
                                return true;
                              },
                              onChanged: (value) {
                                controller.twoFactorCode = value;
                                controller.update();
                              },
                            ),
                          ],
                          const SizedBox(height: Dimensions.space25),
                          RoundedButton(
                            isLoading: controller.submitLoading,
                            press: () {
                              controller.submitConfirmWithdrawRequest();
                            },
                            text: MyStrings.submit.tr,
                          ),
                        ],
                      ),
                    ),
                  )));
  }
}
