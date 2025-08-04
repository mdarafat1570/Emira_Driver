import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_images.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/auth/forget_password/forget_password_controller.dart';
import 'package:ovoride_driver/data/repo/auth/login_repo.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/text-form-field/custom_text_field.dart';
import 'package:ovoride_driver/presentation/components/text/default_text.dart';

import '../../../../../core/utils/my_icons.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(LoginRepo(apiClient: Get.find()));
    Get.put(ForgetPasswordController(loginRepo: Get.find()));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
          backgroundColor: MyColor.getScreenBgColor(),
          body: GetBuilder<ForgetPasswordController>(
            builder: (auth) => SafeArea(
              child: SingleChildScrollView(
                padding: Dimensions.screenPaddingHV,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      MyImages.appLogoWhite,
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        MyIcons.bg,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        height: 200,
                      ),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(top: context.height * .03, bottom: Dimensions.space50 * 1),
                      padding: const EdgeInsetsDirectional.only(
                        top: Dimensions.space20,
                        start: Dimensions.space20,
                        end: Dimensions.space20,
                        bottom: Dimensions.space20,
                      ),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Dimensions.cardRadius)),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Dimensions.space30),
                            Align(alignment: Alignment.center, child: Text(MyStrings.recoverAccount.tr, style: boldExtraLarge.copyWith(fontSize: Dimensions.fontExtraLarge + 5))),
                            const SizedBox(height: 15),
                            DefaultText(
                              text: MyStrings.forgetPasswordSubText.tr,
                              textStyle: regularDefault.copyWith(color: MyColor.getTextColor().withValues(alpha: 0.8)),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: Dimensions.space40),
                            CustomTextField(
                                animatedLabel: true,
                                needOutlineBorder: true,
                                labelText: MyStrings.usernameOrEmail.tr,
                                hintText: MyStrings.usernameOrEmailHint.tr,
                                textInputType: TextInputType.emailAddress,
                                inputAction: TextInputAction.done,
                                controller: auth.emailOrUsernameController,
                                onSuffixTap: () {},
                                onChanged: (value) {
                                  return;
                                },
                                validator: (value) {
                                  if (auth.emailOrUsernameController.text.isEmpty) {
                                    return MyStrings.enterEmailOrUserName.tr;
                                  } else {
                                    return null;
                                  }
                                }),
                            const SizedBox(height: Dimensions.space25),
                            RoundedButton(
                              isLoading: auth.submitLoading,
                              press: () {
                                if (_formKey.currentState!.validate()) {
                                  auth.submitForgetPassCode();
                                }
                              },
                              text: MyStrings.submit.tr,
                            ),
                            const SizedBox(height: Dimensions.space40)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
