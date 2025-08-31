import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/data/model/global/formdata/global_kyc_form_data.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

import 'my_strings.dart';

class MyUtils {
  static void vibrate() async {
    print('vibrate');
    // if (await Vibration.hasVibrator() ?? false) {
    Vibration.vibrate(duration: 1000);
    HapticFeedback.heavyImpact();
    // }
  }

  static void splashScreen() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: MyColor.getPrimaryColor(), statusBarIconBrightness: Brightness.light, systemNavigationBarColor: MyColor.getPrimaryColor(), systemNavigationBarIconBrightness: Brightness.light));
  }

  static void allScreen() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: MyColor.getPrimaryColor(), statusBarIconBrightness: Brightness.light, systemNavigationBarColor: MyColor.colorWhite, systemNavigationBarIconBrightness: Brightness.dark));
  }

  static dynamic getShadow() {
    return [
      BoxShadow(blurRadius: 15.0, offset: const Offset(0, 25), color: Colors.grey.shade500.withValues(alpha: 0.6), spreadRadius: -35.0),
    ];
  }

  static void copy({required String text}) {
    Clipboard.setData(ClipboardData(text: text)).then((value) {
      CustomSnackBar.success(successList: [MyStrings.successfullyCopiedToClipboard]);
    });
  }

  static dynamic getBottomSheetShadow() {
    return [
      BoxShadow(
        color: Colors.grey.shade400.withValues(alpha: 0.08),
        spreadRadius: 3,
        blurRadius: 4,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static dynamic getShadow2({double blurRadius = 8}) {
    return [
      BoxShadow(
        color: MyColor.getShadowColor().withValues(alpha: 0.3),
        blurRadius: blurRadius,
        spreadRadius: 3,
        offset: const Offset(0, 10),
      ),
      BoxShadow(
        color: MyColor.getShadowColor().withValues(alpha: 0.3),
        spreadRadius: 1,
        blurRadius: blurRadius,
        offset: const Offset(0, 1),
      ),
    ];
  }

  static dynamic getCardShadow() {
    return [
      BoxShadow(
        color: Colors.grey.shade400.withValues(alpha: 0.05),
        spreadRadius: 2,
        blurRadius: 2,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static Future<void> launchPhone(url) async {
    await launchUrl(Uri.parse("tel:$url"));
  }

  static dynamic getCardTopShadow() {
    return [
      BoxShadow(
        color: Colors.grey.shade400.withValues(alpha: 0.05),
        offset: const Offset(0, 0),
        blurRadius: 20,
        spreadRadius: 0,
      ),
    ];
  }

  static dynamic getBottomNavShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 20,
        spreadRadius: 0,
        offset: const Offset(0, 0),
      ),
    ];
  }

  static String getOperationTitle(String value) {
    String number = value;
    RegExp regExp = RegExp(r'^(\d+)(\w+)$');
    Match? match = regExp.firstMatch(number);
    if (match != null) {
      String? num = match.group(1) ?? '';
      String? unit = match.group(2) ?? '';
      String title = '${MyStrings.last.tr} $num ${unit.capitalizeFirst}';
      return title.tr;
    } else {
      return value.tr;
    }
  }

  static String maskSensitiveInformation(String input) {
    try {
      if (input.isEmpty) {
        return '';
      }

      final int maskLength = input.length ~/ 2;

      final String mask = '*' * maskLength;

      final String maskedInput = maskLength > 4 ? input.replaceRange(5, maskLength, mask) : input.replaceRange(0, maskLength, mask);

      return maskedInput;
    } catch (e) {
      return input;
    }
  }

  void stopLandscape() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  static List<GlobalFormModel> dynamicFormSelectValueFormatter(List<GlobalFormModel>? dynamicFormList) {
    List<GlobalFormModel> mainFormList = [];

    if (dynamicFormList != null && dynamicFormList.isNotEmpty) {
      mainFormList.clear();

      for (var element in dynamicFormList) {
        if (element.type == 'select') {
          bool? isEmpty = element.options?.isEmpty;
          bool empty = isEmpty ?? true;
          if (element.options != null && empty != true) {
            if (!element.options!.contains(MyStrings.selectOne)) {
              element.options?.insert(0, MyStrings.selectOne);
            }

            element.selectedValue = element.options?.first;
            mainFormList.add(element);
          }
        } else {
          mainFormList.add(element);
        }
      }
    }
    return mainFormList;
  }

  static bool isImage(String path) {
    if (path.contains('.jpg')) {
      return true;
    }
    if (path.contains('.png')) {
      return true;
    }
    if (path.contains('.jpeg')) {
      return true;
    }
    return false;
  }

  static bool isDoc(String path) {
    if (path.contains('.doc')) {
      return true;
    }
    if (path.contains('.docs')) {
      return true;
    }
    return false;
  }

  static String maskEmail(String email) {
    try {
      if (email.isEmpty) {
        return '';
      }

      List<String> parts = email.split('@');
      String maskedPart = maskString(parts[0]);

      if (parts.length > 2) {
        return "$maskedPart@${parts[1]}";
      } else {
        return "$maskedPart@${parts[1]}";
      }
    } catch (e) {
      return email;
    }
  }

  static String maskString(String str) {
    if (str.length <= 2) {
      return str.substring(0, 1) + "*" * (str.length - 1);
    } else {
      return str.substring(0, 1) + "*" * (str.length - 2) + str.substring(str.length - 1);
    }
  }

  static Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }
}
