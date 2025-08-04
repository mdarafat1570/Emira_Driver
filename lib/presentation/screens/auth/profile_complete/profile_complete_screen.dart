import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_icons.dart';
import 'package:ovoride_driver/core/utils/my_images.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/data/controller/account/profile_complete_controller.dart';
import 'package:ovoride_driver/data/repo/account/profile_repo.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/custom_loader/custom_loader.dart';
import 'package:ovoride_driver/presentation/components/divider/custom_spacer.dart';
import 'package:ovoride_driver/presentation/components/image/my_local_image_widget.dart';
import 'package:ovoride_driver/presentation/components/image/my_network_image_widget.dart';
import 'package:ovoride_driver/presentation/components/text-form-field/custom_text_field.dart';
import 'package:ovoride_driver/presentation/components/text/label_text.dart';
import 'package:ovoride_driver/presentation/components/will_pop_widget.dart';
import 'package:ovoride_driver/presentation/screens/auth/registration/widget/country_bottom_sheet.dart';
import 'package:ovoride_driver/presentation/screens/auth/registration/widget/zone_bottom_sheet.dart';

class ProfileCompleteScreen extends StatefulWidget {
  const ProfileCompleteScreen({super.key});

  @override
  State<ProfileCompleteScreen> createState() => _ProfileCompleteScreenState();
}

class _ProfileCompleteScreenState extends State<ProfileCompleteScreen> {
  bool isNumberBlank = false;
  bool isZoneEmpty = false;

  @override
  void initState() {
    Get.put(ProfileRepo(
      apiClient: Get.find(),
    ));
    final controller = Get.put(ProfileCompleteController(profileRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initialData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: WillPopWidget(
        nextRoute: '',
        child: Scaffold(
          backgroundColor: MyColor.getScreenBgColor(),
          body: GetBuilder<ProfileCompleteController>(builder: (controller) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: Dimensions.screenPaddingHV,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    spaceDown(Dimensions.space15),
                    Image.asset(MyImages.appLogoWhite, width: MediaQuery.of(context).size.width / 3),
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        MyIcons.bg,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        height: 200,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsetsDirectional.only(bottom: Dimensions.space50 * 1),
                      padding: const EdgeInsetsDirectional.only(
                        top: Dimensions.space20,
                        bottom: Dimensions.space20,
                        start: Dimensions.space20,
                        end: Dimensions.space20,
                      ),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Dimensions.cardRadius)),
                      child: controller.isLoading
                          ? const CustomLoader()
                          : Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  spaceDown(Dimensions.space20),
                                  Align(alignment: Alignment.center, child: Text(MyStrings.profileCompleteTitle.tr, style: boldExtraLarge.copyWith(fontSize: Dimensions.fontExtraLarge + 5))),
                                  const SizedBox(height: Dimensions.space5),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      MyStrings.profileCompleteSubTitle.toCapitalized().tr,
                                      textAlign: TextAlign.center,
                                      style: regularDefault.copyWith(color: MyColor.getBodyTextColor(), fontSize: Dimensions.fontLarge),
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.space30),
                                  CustomTextField(
                                    animatedLabel: false,
                                    isRequired: true,
                                    needOutlineBorder: true,
                                    isShowInstructionWidget: true,
                                    labelText: MyStrings.username.tr,
                                    hintText: MyStrings.enterYourUsername.tr,
                                    textInputType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    focusNode: controller.userNameFocusNode,
                                    controller: controller.userNameController,
                                    onChanged: (value) {
                                      return;
                                    },
                                  ),
                                  const SizedBox(height: Dimensions.space25),
                                  const LabelText(text: MyStrings.countryName, isRequired: true),
                                  const SizedBox(height: Dimensions.textToTextSpace),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: MyColor.colorWhite,
                                      border: Border.all(color: isNumberBlank ? MyColor.colorRed : MyColor.primaryColor.withValues(alpha: 0.08)),
                                      borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            CountryBottomSheet.profileBottomSheet(context, controller);
                                          },
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              MyImageWidget(
                                                imageUrl: UrlContainer.countryFlagImageLink.replaceAll("{countryCode}", controller.selectedCountryData.countryCode.toString().toLowerCase()),
                                                height: Dimensions.space25,
                                                width: Dimensions.space40,
                                              ),
                                              spaceSide(Dimensions.space3),
                                              Icon(Icons.keyboard_arrow_down_rounded, color: MyColor.getBodyTextColor()),
                                              spaceSide(Dimensions.space5),
                                              Container(color: MyColor.getBodyTextColor(), width: 1, height: Dimensions.space15),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.only(start: Dimensions.space10),
                                                child: Text("+${controller.selectedCountryData.dialCode}", style: regularMediumLarge.copyWith(fontSize: Dimensions.fontOverLarge)),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.only(start: Dimensions.space5, top: Dimensions.space5 - 1),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                suffixIcon: Padding(
                                                  padding: const EdgeInsets.all(Dimensions.space15),
                                                  child: MyLocalImageWidget(
                                                    imagePath: MyIcons.phone,
                                                    height: 15,
                                                    imageOverlayColor: MyColor.getBodyTextColor(),
                                                  ),
                                                ),
                                                border: InputBorder.none,
                                                filled: false,
                                                contentPadding: const EdgeInsetsDirectional.only(top: 6.7, start: 0, end: 15, bottom: 0),
                                                hintStyle: regularMediumLarge.copyWith(fontSize: Dimensions.fontOverLarge, color: MyColor.getBodyTextColor()),
                                                hintText: MyStrings.enterPhoneNumber000.tr,
                                              ),
                                              controller: controller.mobileNoController,
                                              keyboardType: TextInputType.phone,
                                              style: regularMediumLarge.copyWith(fontSize: Dimensions.fontOverLarge),
                                              cursorColor: MyColor.primaryColor,
                                              onChanged: (value) {
                                                controller.mobileNoController.text.isNotEmpty ? isNumberBlank = false : null;
                                                setState(() {});
                                              },
                                              validator: (value) {
                                                final whitespaceOrEmpty = RegExp(r"^\s*$|^$");
                                                if (whitespaceOrEmpty.hasMatch(value ?? "")) {
                                                  setState(() {
                                                    isNumberBlank = true;
                                                  });
                                                  return;
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  isNumberBlank ? const SizedBox(height: Dimensions.space5) : const SizedBox.shrink(),
                                  isNumberBlank ? Padding(padding: const EdgeInsets.only(left: 8.0), child: Text(MyStrings.enterYourPhoneNumber, style: regularSmall.copyWith(color: MyColor.colorRed))) : const SizedBox.shrink(),
                                  const SizedBox(height: Dimensions.space25),
                                  const LabelText(text: MyStrings.selectYourZone, isRequired: true),
                                  const SizedBox(height: Dimensions.textToTextSpace),
                                  GestureDetector(
                                    onTap: () {
                                      ZoneBottomSheet.bottomSheet(context, controller);
                                    },
                                    child: Container(
                                      width: context.width,
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space12),
                                      decoration: BoxDecoration(border: Border.all(color: isZoneEmpty ? MyColor.colorRed : MyColor.borderColor, width: isZoneEmpty ? 1 : .5), borderRadius: BorderRadius.circular(Dimensions.mediumRadius)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.selectedZone.id == "-1" ? MyStrings.selectYourZone.tr : (controller.selectedZone.name ?? '').toTitleCase(),
                                            style: regularSmall.copyWith(color: controller.selectedZone.id == "-1" ? MyColor.hintTextColor : MyColor.getTextColor()),
                                          ),
                                          const Icon(Icons.arrow_drop_down, color: MyColor.hintTextColor),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isZoneEmpty) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6, left: 12),
                                      child: Text(
                                        MyStrings.selectYourZone.tr,
                                        style: regularDefault.copyWith(color: MyColor.colorRed, fontSize: 13),
                                      ),
                                    )
                                  ],
                                  const SizedBox(height: Dimensions.space25),
                                  CustomTextField(
                                    animatedLabel: false,
                                    needOutlineBorder: true,
                                    labelText: MyStrings.address,
                                    hintText: "${MyStrings.enterYour.tr} ${MyStrings.address.toLowerCase().tr}",
                                    textInputType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    focusNode: controller.addressFocusNode,
                                    controller: controller.addressController,
                                    nextFocus: controller.stateFocusNode,
                                    onChanged: (value) {
                                      return;
                                    },
                                  ),
                                  const SizedBox(height: Dimensions.space25),
                                  CustomTextField(
                                    animatedLabel: false,
                                    needOutlineBorder: true,
                                    labelText: MyStrings.state,
                                    hintText: "${MyStrings.enterYour.tr} ${MyStrings.state.toLowerCase().tr}",
                                    textInputType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    focusNode: controller.stateFocusNode,
                                    controller: controller.stateController,
                                    nextFocus: controller.cityFocusNode,
                                    onChanged: (value) {
                                      return;
                                    },
                                  ),
                                  const SizedBox(height: Dimensions.space25),
                                  CustomTextField(
                                    animatedLabel: false,
                                    needOutlineBorder: true,
                                    labelText: MyStrings.city.tr,
                                    hintText: "${MyStrings.enterYour.tr} ${MyStrings.city.toLowerCase().tr}",
                                    textInputType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    focusNode: controller.cityFocusNode,
                                    controller: controller.cityController,
                                    nextFocus: controller.zipCodeFocusNode,
                                    onChanged: (value) {
                                      return;
                                    },
                                  ),
                                  const SizedBox(height: Dimensions.space25),
                                  CustomTextField(
                                    animatedLabel: false,
                                    needOutlineBorder: true,
                                    labelText: MyStrings.zipCode.tr,
                                    hintText: "${MyStrings.enterYour.tr} ${MyStrings.zipCode.toLowerCase().tr}",
                                    textInputType: TextInputType.text,
                                    inputAction: TextInputAction.done,
                                    focusNode: controller.zipCodeFocusNode,
                                    controller: controller.zipCodeController,
                                    onChanged: (value) {
                                      return;
                                    },
                                  ),
                                  const SizedBox(height: Dimensions.space35),
                                  RoundedButton(
                                    isLoading: controller.submitLoading,
                                    text: MyStrings.completeProfile.tr,
                                    press: () {
                                      if (formKey.currentState!.validate()) {
                                        controller.updateProfile();
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
