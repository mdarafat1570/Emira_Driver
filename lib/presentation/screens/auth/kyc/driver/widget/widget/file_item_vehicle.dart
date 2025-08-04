import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/controller/vehicle_verification/vehicle_verification_controller.dart';
import 'package:ovoride_driver/data/model/global/formdata/global_kyc_form_data.dart';
import 'package:ovoride_driver/presentation/screens/auth/kyc/driver/widget/widget/choose_file_list_item.dart';

class FileItemForVehicle extends StatefulWidget {
  final int index;

  const FileItemForVehicle({super.key, required this.index});

  @override
  State<FileItemForVehicle> createState() => _FileItemForVehicleState();
}

class _FileItemForVehicleState extends State<FileItemForVehicle> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VehicleVerificationController>(builder: (controller) {
      GlobalFormModel? model = controller.formList[widget.index];
      return InkWell(
          onTap: () {
            controller.pickFile(widget.index);
          },
          child: ChooseFileItem(fileName: model.selectedValue ?? MyStrings.chooseFile));
    });
  }
}
