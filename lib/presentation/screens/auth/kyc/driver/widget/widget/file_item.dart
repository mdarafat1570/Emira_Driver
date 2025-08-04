import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/controller/driver_kyc_controller/driver_kyc_controller.dart';
import 'package:ovoride_driver/data/model/global/formdata/global_kyc_form_data.dart';
import 'package:ovoride_driver/presentation/screens/auth/kyc/driver/widget/widget/choose_file_list_item.dart';

class ConfirmWithdrawFileItem extends StatefulWidget {
  final int index;

  const ConfirmWithdrawFileItem({super.key, required this.index});

  @override
  State<ConfirmWithdrawFileItem> createState() => _ConfirmWithdrawFileItemState();
}

class _ConfirmWithdrawFileItemState extends State<ConfirmWithdrawFileItem> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverKycController>(builder: (controller) {
      GlobalFormModel? model = controller.formList[widget.index];
      return GestureDetector(
          onTap: () {
            controller.pickFile(widget.index);
          },
          child: ChooseFileItem(fileName: model.selectedValue ?? MyStrings.chooseFile));
    });
  }
}
