import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/utils/dimensions.dart';
import '../../../../../../core/utils/my_color.dart';
import '../../../../../../core/utils/my_images.dart';
import '../../../../../../core/utils/my_strings.dart';
import '../../../../../../core/utils/style.dart';
import '../../../components/snack_bar/show_custom_snackbar.dart';

class EnableQRCodeWidget extends StatelessWidget {
  final String qrImage;
  final String secret;
  const EnableQRCodeWidget({super.key, required this.qrImage, required this.secret});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: MyColor.transparentColor,
              borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
            ),
            child: Image.network(qrImage, width: 220, height: 220, errorBuilder: (ctx, object, trx) {
              return Image.asset(
                MyImages.placeHolderImage,
                fit: BoxFit.cover,
                width: 220,
                height: 220,
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          MyStrings.setupKey.tr,
          style: boldExtraLarge.copyWith(color: MyColor.getHeadingTextColor()),
        ),
        SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.space10),
          child: Padding(
            padding: const EdgeInsets.all(0.8),
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                strokeWidth: 1,
                dashPattern: const [5, 5],
                color: MyColor.colorGrey.withValues(alpha: 0.5),
                radius: const Radius.circular(Dimensions.defaultRadius),
              ),
              child: Container(
                decoration: BoxDecoration(color: MyColor.colorWhite, borderRadius: BorderRadius.circular(Dimensions.defaultRadius - 1)),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        secret,
                        style: boldExtraLarge.copyWith(fontSize: Dimensions.fontDefault + 5, color: MyColor.colorBlack),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                            text: secret,
                          )).then((_) {
                            CustomSnackBar.success(successList: [MyStrings.copiedToClipBoard.tr], duration: 2);
                          });
                        },
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.space5),
                            child: Icon(
                              Icons.copy,
                              color: MyColor.colorGrey.withValues(alpha: 0.5),
                              size: 10,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Center(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: MyStrings.useQRCODETips2.tr, style: regularDefault.copyWith(color: MyColor.getHeadingTextColor())),
                TextSpan(
                    text: ' ${MyStrings.download}',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri url = Uri.parse("https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en");

                        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                          throw Exception('Could not launch $url');
                        }
                      },
                    style: boldExtraLarge.copyWith(color: MyColor.colorRed)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
