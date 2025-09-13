import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_images.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/auth/auth/registration_controller.dart';
import 'package:ovoride_driver/data/repo/auth/general_setting_repo.dart';
import 'package:ovoride_driver/data/repo/auth/signup_repo.dart';
import 'package:ovoride_driver/presentation/components/custom_loader/custom_loader.dart';
import 'package:ovoride_driver/presentation/components/custom_no_data_found_class.dart';
import 'package:ovoride_driver/presentation/components/will_pop_widget.dart';
import 'package:ovoride_driver/presentation/screens/auth/registration/widget/registration_form.dart';

import '../../../../core/utils/my_icons.dart';
import '../../../components/divider/custom_spacer.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(RegistrationRepo(apiClient: Get.find()));
    Get.put(RegistrationController(registrationRepo: Get.find(), generalSettingRepo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<RegistrationController>().initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.dark),
      child: GetBuilder<RegistrationController>(
        builder: (controller) => WillPopWidget(
          nextRoute: RouteHelper.loginScreen,
          child: Scaffold(
            backgroundColor: MyColor.screenBgColor,
            body: controller.noInternet
                ? NoDataOrInternetScreen(
                    isNoInternet: true,
                    onChanged: () {
                      controller.initData();
                    },
                  )
                : controller.isLoading
                    ? CustomLoader()
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: Dimensions.screenPaddingHV,
                        child: SafeArea(
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  spaceDown(Dimensions.space15),
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
                                ],
                              ),
                              Container(
                                margin: const EdgeInsetsDirectional.only(
                                  top: Dimensions.space10,
                                  bottom: Dimensions.space50 * 1,
                                ),
                                padding: const EdgeInsetsDirectional.only(top: Dimensions.space20, start: Dimensions.space20, end: Dimensions.space20, bottom: Dimensions.space20),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Dimensions.cardRadius)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    spaceDown(Dimensions.space20),
                                    Text(MyStrings.regScreenTitle.tr, style: boldExtraLarge.copyWith(fontSize: 32, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: Dimensions.space5),
                                    Text(
                                      MyStrings.regScreenSubTitle.tr,
                                      style: regularDefault.copyWith(color: MyColor.getBodyTextColor(), fontSize: 16),
                                    ),
                                    spaceDown(Dimensions.space20),
                                    // SocialAuthSection(),
                                    spaceDown(Dimensions.space15),
                                    const RegistrationForm()
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
