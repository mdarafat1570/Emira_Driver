import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/account/change_password_controller.dart';
import 'package:ovoride_driver/data/repo/account/change_password_repo.dart';
import 'package:ovoride_driver/presentation/components/app-bar/custom_appbar.dart';
import 'package:ovoride_driver/presentation/components/divider/custom_spacer.dart';
import 'package:ovoride_driver/presentation/screens/account/change-password/widget/change_password_form.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../components/card/app_body_card.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  void initState() {
    Get.put(ChangePasswordRepo(apiClient: Get.find()));
    Get.put(ChangePasswordController(changePasswordRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ChangePasswordController>().clearData();
    });
  }

  @override
  void dispose() {
    Get.find<ChangePasswordController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: MyColor.screenBgColor, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(title: MyStrings.changePassword),
        body: GetBuilder<ChangePasswordController>(
          builder: (controller) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: Dimensions.screenPaddingHV,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBodyWidgetCard(
                      //  margin: EdgeInsetsDirectional.only(top: context.height * .1, bottom: Dimensions.space50 * 1),
                      padding: const EdgeInsetsDirectional.only(
                        top: Dimensions.space20,
                        start: Dimensions.space20,
                        end: Dimensions.space20,
                        bottom: Dimensions.space20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          spaceDown(Dimensions.space30),
                          Text(
                            MyStrings.changePassword.tr,
                            style: regularExtraLarge.copyWith(color: MyColor.getTextColor(), fontWeight: FontWeight.w500),
                          ),
                          spaceDown(Dimensions.space10),
                          Text(
                            MyStrings.createPasswordSubText.tr,
                            textAlign: TextAlign.center,
                            style: regularDefault.copyWith(color: MyColor.getTextColor().withValues(alpha: 0.8)),
                          ),
                          spaceDown(Dimensions.space30),
                          const ChangePasswordForm()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
