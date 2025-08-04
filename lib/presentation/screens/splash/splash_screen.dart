import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_images.dart';
import 'package:ovoride_driver/core/utils/util.dart';
import 'package:ovoride_driver/data/controller/localization/localization_controller.dart';
import 'package:ovoride_driver/data/controller/splash/splash_controller.dart';
import 'package:ovoride_driver/data/repo/auth/general_setting_repo.dart';
import 'package:ovoride_driver/presentation/components/custom_no_data_found_class.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    MyUtils.splashScreen();

    Get.put(GeneralSettingRepo(apiClient: Get.find()));
    Get.put(LocalizationController(sharedPreferences: Get.find()));
    final controller = Get.put(SplashController(repo: Get.find(), localizationController: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.gotoNextPage();
    });
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: MyColor.screenBgColor, statusBarIconBrightness: Brightness.dark, systemNavigationBarColor: MyColor.transparentColor, systemNavigationBarIconBrightness: Brightness.dark));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (controller) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(statusBarColor: MyColor.primaryColor, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light),
        child: Scaffold(
          backgroundColor: controller.noInternet ? MyColor.colorWhite : MyColor.primaryColor,
          body: controller.noInternet
              ? NoDataOrInternetScreen(
                  isNoInternet: true,
                  onChanged: () {
                    controller.gotoNextPage();
                  },
                )
              : Stack(
                  children: [
                    Align(alignment: Alignment.center, child: Image.asset(MyImages.appLogoIcon, height: 100, width: 100)),
                  ],
                ),
        ),
      ),
    );
  }
}
