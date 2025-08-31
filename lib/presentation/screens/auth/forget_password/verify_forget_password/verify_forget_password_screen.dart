import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_icons.dart';
import 'package:ovoride_driver/core/utils/my_images.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/auth/forget_password/verify_password_controller.dart';
import 'package:ovoride_driver/data/repo/auth/login_repo.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/divider/custom_spacer.dart';
import 'package:ovoride_driver/presentation/components/text/default_text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyForgetPassScreen extends StatefulWidget {
  const VerifyForgetPassScreen({super.key});

  @override
  State<VerifyForgetPassScreen> createState() => _VerifyForgetPassScreenState();
}

class _VerifyForgetPassScreenState extends State<VerifyForgetPassScreen> {
  @override
  void initState() {
    Get.put(LoginRepo(apiClient: Get.find()));
    final controller = Get.put(VerifyPasswordController(loginRepo: Get.find()));

    controller.email = Get.arguments;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
          backgroundColor: MyColor.getScreenBgColor(),
          body: Stack(
            children: [
              GetBuilder<VerifyPasswordController>(
                builder: (controller) => controller.isLoading
                    ? Center(child: CircularProgressIndicator(color: MyColor.getPrimaryColor()))
                    : SingleChildScrollView(
                        padding: Dimensions.screenPaddingHV,
                        child: SafeArea(
                          child: Container(
                            padding: const EdgeInsetsDirectional.only(bottom: Dimensions.space20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(MyImages.appLogoWhite, width: MediaQuery.of(context).size.width / 3),
                                Align(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    MyIcons.bg,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                    height: 200,
                                  ),
                                ),
                                spaceDown(Dimensions.space20),
                                Align(alignment: Alignment.center, child: Text(MyStrings.verifyYourEmail.tr, style: boldExtraLarge.copyWith(fontSize: Dimensions.fontExtraLarge + 5))),
                                const SizedBox(height: Dimensions.space5),
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 25), child: DefaultText(text: '${MyStrings.verifyPasswordSubText.tr} : ${controller.getFormatedMail().tr}', textAlign: TextAlign.center, textColor: MyColor.getContentTextColor())),
                                const SizedBox(height: Dimensions.space40),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.space30),
                                  child: PinCodeTextField(
                                    appContext: context,
                                    pastedTextStyle: regularDefault.copyWith(color: MyColor.getPrimaryColor()),
                                    length: 6,
                                    textStyle: regularDefault.copyWith(color: MyColor.getTextColor()),
                                    obscureText: false,
                                    obscuringCharacter: '*',
                                    blinkWhenObscuring: false,
                                    animationType: AnimationType.scale,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(8),
                                      borderWidth: 1,
                                      fieldHeight: 40,
                                      fieldWidth: 40,
                                      inactiveColor: MyColor.getTextFieldDisableBorder(),
                                      inactiveFillColor: MyColor.getScreenBgColor(),
                                      activeFillColor: MyColor.getScreenBgColor(),
                                      activeColor: MyColor.getPrimaryColor(),
                                      selectedFillColor: MyColor.getScreenBgColor(),
                                      selectedColor: MyColor.getPrimaryColor(),
                                    ),
                                    cursorColor: MyColor.getTextColor(),
                                    animationDuration: const Duration(milliseconds: 100),
                                    enableActiveFill: true,
                                    keyboardType: TextInputType.number,
                                    beforeTextPaste: (text) {
                                      return true;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        controller.currentText = value;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: Dimensions.space25),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    start: Dimensions.space20,
                                    end: Dimensions.space20,
                                  ),
                                  child: RoundedButton(
                                      isLoading: controller.verifyLoading,
                                      text: MyStrings.verify.tr,
                                      press: () {
                                        if (controller.currentText.length != 6) {
                                          controller.hasError = true;
                                        } else {
                                          controller.verifyForgetPasswordCode(controller.currentText);
                                        }
                                      }),
                                ),
                                const SizedBox(height: Dimensions.space25),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DefaultText(text: MyStrings.didNotReceiveCode.tr, textColor: MyColor.getTextColor()),
                                    const SizedBox(width: Dimensions.space5),
                                    controller.isResendLoading
                                        ? const SizedBox(
                                            height: 17,
                                            width: 17,
                                            child: CircularProgressIndicator(
                                              color: MyColor.primaryColor,
                                            ),
                                          )
                                        : TextButton(
                                            onPressed: () {
                                              controller.resendForgetPassCode();
                                            },
                                            child: DefaultText(
                                              text: MyStrings.resend.tr,
                                              textStyle: regularDefault.copyWith(
                                                color: MyColor.getPrimaryColor(),
                                                decoration: TextDecoration.underline,
                                                decorationColor: MyColor.primaryColor,
                                              ),
                                            ),
                                          )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          )),
    );
  }
}
