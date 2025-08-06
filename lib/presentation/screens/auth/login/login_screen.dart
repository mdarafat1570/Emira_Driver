import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/auth/login_controller.dart';
import 'package:ovoride_driver/data/repo/auth/login_repo.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/text-form-field/custom_text_field.dart';
import 'package:ovoride_driver/presentation/components/text/default_text.dart';
import 'package:ovoride_driver/presentation/components/will_pop_widget.dart';
import '../../../../core/utils/my_icons.dart';
import '../../../../core/utils/my_images.dart';
import '../../../components/divider/custom_spacer.dart';
import '../../../components/image/custom_svg_picture.dart';
import '../social_auth/social_auth_section.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  bool _isScrolling = false;

  @override
  void initState() {
    Get.put(LoginRepo(apiClient: Get.find()));
    Get.put(LoginController(loginRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(checkScrollPosition);
      Get.find<LoginController>().remember = false;
    });
  }

  void checkScrollPosition() {
    printX("testing scroll ${scrollController.position.pixels}");

    if (scrollController.position.pixels >= 120) {
      scrollController.jumpTo(120);
    }
  }

  void scrollToBottom() {
    if (!_isScrolling) {
      _isScrolling = true;
      scrollController
          .animateTo(
            scrollController.position.minScrollExtent,
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
          )
          .then((_) => _isScrolling = false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark),
      child: WillPopWidget(
        nextRoute: '',
        child: Scaffold(
          backgroundColor: MyColor.colorWhite,
          body: GetBuilder<LoginController>(
            builder: (controller) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: Dimensions.screenPaddingHV,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    spaceDown(Dimensions.space15),

                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        MyImages.appLogoWhite,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        height: 200,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          spaceDown(Dimensions.space20),
                          FittedBox(
                            child: Text(
                              MyStrings.loginScreenTitle.tr,
                              maxLines: 1,
                              style: boldExtraLarge.copyWith(fontSize: 32, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(height: Dimensions.space5),
                          Text(
                            MyStrings.loginScreenSubTitle.tr,
                            style: lightDefault.copyWith(color: MyColor.bodyText, fontSize: Dimensions.fontLarge),
                          ),
                          spaceDown(Dimensions.space20),
                          SocialAuthSection(),
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                spaceDown(Dimensions.space20),
                                CustomTextField(
                                  animatedLabel: true,
                                  needOutlineBorder: true,
                                  controller: controller.emailController,
                                  labelText: MyStrings.usernameOrEmail.tr,
                                  onChanged: (value) {},
                                  focusNode: controller.emailFocusNode,
                                  nextFocus: controller.passwordFocusNode,
                                  textInputType: TextInputType.emailAddress,
                                  inputAction: TextInputAction.next,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: CustomSvgPicture(image: MyIcons.user, color: MyColor.primaryColor),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return MyStrings.fieldErrorMsg.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                spaceDown(Dimensions.space20),
                                CustomTextField(
                                  animatedLabel: true,
                                  needOutlineBorder: true,
                                  labelText: MyStrings.password.tr,
                                  controller: controller.passwordController,
                                  focusNode: controller.passwordFocusNode,
                                  onChanged: (value) {},
                                  isShowSuffixIcon: true,
                                  isPassword: true,
                                  textInputType: TextInputType.text,
                                  inputAction: TextInputAction.done,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: CustomSvgPicture(image: MyIcons.password, color: MyColor.primaryColor),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return MyStrings.fieldErrorMsg.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                spaceDown(Dimensions.space15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: Dimensions.space15,
                                          height: 25,
                                          child: Checkbox(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.space5)),
                                            activeColor: MyColor.primaryColor,
                                            checkColor: MyColor.colorWhite,
                                            value: controller.remember,
                                            side: WidgetStateBorderSide.resolveWith(
                                              (states) => BorderSide(width: 1.0, color: controller.remember ? MyColor.getTextFieldEnableBorder() : MyColor.getTextFieldDisableBorder()),
                                            ),
                                            onChanged: (value) {
                                              controller.changeRememberMe();
                                            },
                                          ),
                                        ),
                                        spaceSide(Dimensions.space8),
                                        InkWell(
                                            onTap: () {
                                              controller.changeRememberMe();
                                            },
                                            splashFactory: NoSplash.splashFactory,
                                            child: DefaultText(
                                              text: MyStrings.rememberMe.tr,
                                              textColor: MyColor.getBodyTextColor(),
                                              fontSize: 14,
                                            ))
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.clearTextField();
                                        Get.toNamed(RouteHelper.forgotPasswordScreen);
                                      },
                                      child: DefaultText(text: MyStrings.forgotPassword.tr, textColor: MyColor.redCancelTextColor, fontSize: 14),
                                    )
                                  ],
                                ),
                                spaceDown(Dimensions.space25),
                                RoundedButton(
                                  isLoading: controller.isSubmitLoading,
                                  text: MyStrings.signIn.tr,
                                  color: MyColor.primaryColor,
                                  press: () {
                                    if (formKey.currentState!.validate()) {
                                      controller.loginUser();
                                    }
                                  },
                                ),
                                spaceDown(Dimensions.space30),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(MyStrings.doNotHaveAccount.tr, overflow: TextOverflow.ellipsis, style: regularLarge.copyWith(color: MyColor.getBodyTextColor(), fontWeight: FontWeight.normal, fontSize: 14)),
                                    const SizedBox(width: Dimensions.space5),
                                    IconButton(
                                      onPressed: () {
                                        Get.offAndToNamed(RouteHelper.registrationScreen);
                                      },
                                      icon: Text(
                                        MyStrings.signUp.tr,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: boldLarge.copyWith(color: MyColor.getPrimaryColor()),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
