// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/model/global/payment_method/app_payment_gateway.dart';
import 'package:ovoride_driver/presentation/components/image/my_network_image_widget.dart';

class PaymentMethodCard extends StatelessWidget {
  final VoidCallback press;
  AppPaymentGateway paymentMethod;
  final String assetPath;
  bool selected = false;
  PaymentMethodCard({super.key, required this.press, required this.paymentMethod, required this.assetPath, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsetsDirectional.only(top: 10),
        child: Material(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.space10),
            side: BorderSide(
              color: selected ? MyColor.primaryColor : MyColor.rideBorderColor.withValues(alpha: .9),
            ),
          ),
          color: Colors.white,
          child: CheckboxListTile(
            value: selected,
            checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.space10)),
            onChanged: (val) {
              press();
            },
            contentPadding: const EdgeInsetsDirectional.only(start: Dimensions.space20, end: Dimensions.space20, top: Dimensions.space1, bottom: Dimensions.space1),
            activeColor: MyColor.primaryColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyImageWidget(
                  imageUrl: '$assetPath/${paymentMethod.method?.image}',
                  width: Dimensions.space40,
                  height: Dimensions.space40,
                  boxFit: BoxFit.fitWidth,
                  radius: 4,
                ),
                const SizedBox(width: Dimensions.space10),
                Expanded(
                  child: Text(paymentMethod.name ?? '', style: semiBoldDefault.copyWith(color: MyColor.colorBlack), maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
