import 'package:flutter/cupertino.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/account/profile_complete_controller.dart';
import 'package:ovoride_driver/presentation/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:ovoride_driver/presentation/components/bottom-sheet/custom_bottom_sheet.dart';

class ZoneBottomSheet {
  static void bottomSheet(BuildContext context, ProfileCompleteController controller) {
    CustomBottomSheet(
      child: Container(
        height: MediaQuery.of(context).size.height * .8,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: MyColor.getCardBgColor(),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BottomSheetHeaderRow(header: MyStrings.selectYourZone, bottomSpace: 15),
            const SizedBox(height: 4),
            Flexible(
              child: ListView.builder(
                  itemCount: controller.filteredZone.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var zoneItem = controller.filteredZone[index];

                    return GestureDetector(
                      onTap: () {
                        controller.selectZone(zoneItem);
                        Navigator.pop(context);
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: MyColor.transparentColor,
                          border: controller.filteredZone.last.id != controller.filteredZone[index].id ? Border(bottom: BorderSide(color: MyColor.getTextColor(), width: 0.5)) : null,
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsetsDirectional.only(end: Dimensions.space10),
                              child: Icon(
                                CupertinoIcons.location,
                                color: MyColor.hintTextColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(end: Dimensions.space10),
                              child: Text(
                                '${zoneItem.name}',
                                style: boldDefault.copyWith(color: MyColor.colorBlack),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    ).customBottomSheet(context);
  }
}
