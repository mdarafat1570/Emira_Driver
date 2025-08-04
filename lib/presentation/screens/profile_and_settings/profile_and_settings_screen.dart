import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/data/controller/account/profile_controller.dart';
import 'package:ovoride_driver/data/repo/account/profile_repo.dart';
import 'package:ovoride_driver/data/services/api_client.dart';
import 'package:ovoride_driver/presentation/components/divider/custom_spacer.dart';
import 'package:ovoride_driver/presentation/components/shimmer/user_shimmer.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovoride_driver/presentation/components/text/header_text.dart';
import 'package:ovoride_driver/presentation/screens/profile_and_settings/widgets/delete_account_bottom_sheet.dart';

import '../../../core/route/route.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/my_images.dart';
import '../../../core/utils/my_strings.dart';
import '../../../core/utils/style.dart';
import '../../../core/utils/util.dart';
import '../../components/app-bar/custom_appbar.dart';
import '../../components/bottom-sheet/custom_bottom_sheet.dart';
import '../../components/divider/custom_divider.dart';
import '../../components/image/my_network_image_widget.dart';
import 'widgets/account_user_card.dart';
import 'widgets/menu_row_widget.dart';

class ProfileAndSettingsScreen extends StatefulWidget {
  const ProfileAndSettingsScreen({super.key});

  @override
  State<ProfileAndSettingsScreen> createState() => _ProfileAndSettingsScreenState();
}

class _ProfileAndSettingsScreenState extends State<ProfileAndSettingsScreen> {
  @override
  void initState() {
    Get.put(ProfileRepo(apiClient: Get.find()));
    final controller = Get.put(ProfileController(profileRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadProfileInfo();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: const CustomAppBar(
        title: MyStrings.accountAndSettings,
        isShowBackBtn: false,
      ),
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          return RefreshIndicator(
            color: MyColor.colorWhite,
            backgroundColor: MyColor.primaryColor,
            onRefresh: () async {
              controller.loadProfileInfo();
            },
            child: SingleChildScrollView(
              padding: Dimensions.screenPaddingHV,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  controller.isLoading
                      ? const UserShimmer()
                      : Container(
                          decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(Dimensions.space12), boxShadow: MyUtils.getCardShadow()),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(start: Dimensions.space15, end: Dimensions.space15, top: Dimensions.space15, bottom: Dimensions.space15),
                            child: AccountUserCard(
                              fullName: "${controller.firstNameController.text} ${controller.lastNameController.text}".toTitleCase(),
                              username: controller.driver.username,
                              subtitle: "+${controller.driver.mobile}",
                              rating: controller.driver.avgRating,
                              imgWidget: controller.driver.image == null || controller.driver.image == 'null' || controller.driver.image!.isEmpty
                                  ? Image.asset(MyImages.defaultAvatar, height: 85)
                                  : Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(border: Border.all(color: MyColor.borderColor, width: .5), shape: BoxShape.circle),
                                      child: MyImageWidget(imageUrl: controller.imageUrl, isProfile: true, height: 65, width: 65, radius: 50, errorWidget: Image.asset(MyImages.defaultAvatar, height: 50)),
                                    ),
                            ),
                          ),
                        ),
                  spaceDown(10),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.myWalletScreen);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Dimensions.space15),
                      decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(Dimensions.space12), boxShadow: MyUtils.getCardShadow()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HeaderText(text: MyStrings.totalBalance, textStyle: regularLarge.copyWith(color: MyColor.bodyText)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: HeaderText(text: '${Get.find<ApiClient>().getCurrency(isSymbol: true)}${controller.isLoading ? '0.00' : StringConverter.formatNumber(controller.driver.balance ?? '0')}', textStyle: boldLarge.copyWith(color: MyColor.colorBlack, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  spaceDown(10),
                  Container(
                    padding: const EdgeInsets.all(Dimensions.space15),
                    decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(Dimensions.space12), boxShadow: MyUtils.getCardShadow()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeaderText(text: MyStrings.account.tr.toUpperCase(), textStyle: regularLarge.copyWith(color: MyColor.bodyText)),
                        const SizedBox(height: Dimensions.space20),
                        MenuRowWidget(image: MyImages.user, label: MyStrings.profile, onPressed: () => Get.toNamed(RouteHelper.profileScreen)),
                        const CustomDivider(space: Dimensions.space15),
                        MenuRowWidget(
                          image: MyImages.review,
                          label: MyStrings.review,
                          onPressed: () => Get.toNamed(RouteHelper.driverReviewScreen, arguments: '${controller.driver.avgRating}'),
                        ),
                        const CustomDivider(space: Dimensions.space15),
                        MenuRowWidget(image: MyImages.wallet, label: MyStrings.myWallet, onPressed: () => Get.toNamed(RouteHelper.myWalletScreen)),
                        const CustomDivider(space: Dimensions.space15),
                        MenuRowWidget(image: MyImages.addMoney, label: MyStrings.deposit, onPressed: () => Get.toNamed(RouteHelper.newDepositScreenScreen)),
                        const CustomDivider(space: Dimensions.space15),
                        MenuRowWidget(image: MyImages.changePassword, label: MyStrings.changePassword, onPressed: () => Get.toNamed(RouteHelper.changePasswordScreen)),
                        const CustomDivider(space: Dimensions.space15),
                        MenuRowWidget(image: MyImages.twoFa, label: MyStrings.twoFactorAuth, onPressed: () => Get.toNamed(RouteHelper.twoFactorSetupScreen)),
                        spaceDown(Dimensions.space10),
                      ],
                    ),
                  ),
                  spaceDown(Dimensions.space15),
                  Container(
                    padding: const EdgeInsets.all(Dimensions.space15),
                    decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(Dimensions.space12), boxShadow: MyUtils.getShadow()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeaderText(text: MyStrings.rides.tr.toUpperCase(), textStyle: regularLarge.copyWith(color: MyColor.bodyText)),
                        const SizedBox(height: Dimensions.space20),
                        MenuRowWidget(
                            image: MyImages.city,
                            label: MyStrings.cityRide,
                            onPressed: () {
                              Get.toNamed(RouteHelper.cityRideScreen, arguments: [true]);
                            }),
                        const CustomDivider(space: Dimensions.space15),
                        MenuRowWidget(image: MyImages.intercity, label: MyStrings.interCityRide, onPressed: () => Get.toNamed(RouteHelper.interCityRideScreen, arguments: [true])),
                        spaceDown(Dimensions.space10),
                      ],
                    ),
                  ),
                  spaceDown(Dimensions.space15),
                  Container(
                    padding: const EdgeInsets.all(Dimensions.space15),
                    decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(Dimensions.space12), boxShadow: MyUtils.getShadow()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeaderText(text: MyStrings.history.tr.toUpperCase(), textStyle: regularLarge.copyWith(color: MyColor.bodyText)),
                        const SizedBox(height: Dimensions.space20),
                        MenuRowWidget(image: MyImages.payable, label: MyStrings.paymentHistory, onPressed: () => Get.toNamed(RouteHelper.paymentHistoryScreen)),
                        const CustomDivider(space: Dimensions.space15),
                        MenuRowWidget(image: MyImages.transaction, label: MyStrings.transactionHistory, onPressed: () => Get.toNamed(RouteHelper.transactionHistoryScreen, arguments: [MyStrings.interCity, true])),
                        const CustomDivider(space: Dimensions.space15),
                        MenuRowWidget(image: MyImages.transaction, label: MyStrings.depositHistory, onPressed: () => Get.toNamed(RouteHelper.depositsScreen)),
                        spaceDown(Dimensions.space10),
                      ],
                    ),
                  ),
                  spaceDown(Dimensions.space15),
                  Container(
                    padding: const EdgeInsets.all(Dimensions.space15),
                    decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(Dimensions.space12), boxShadow: MyUtils.getShadow()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeaderText(text: MyStrings.settingsAndSupport.tr.toUpperCase(), textStyle: regularLarge.copyWith(color: MyColor.bodyText)),
                        const SizedBox(height: Dimensions.space20),
                        if (Get.find<ApiClient>().isMultiLanguageEnabled()) ...[
                          MenuRowWidget(image: MyImages.language, label: MyStrings.language, onPressed: () => Get.toNamed(RouteHelper.languageScreen)),
                          const CustomDivider(space: Dimensions.space15),
                        ],
                        MenuRowWidget(image: MyImages.support, label: MyStrings.supportTicket, onPressed: () => Get.toNamed(RouteHelper.allTicketScreen)),
                        const CustomDivider(space: Dimensions.space15),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: Dimensions.space12),
                          color: MyColor.transparentColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(controller.profileRepo.apiClient.isNotificationAudioEnable() ? CupertinoIcons.speaker : CupertinoIcons.speaker_slash, color: MyColor.getRideSubTitleColor(), size: 24),
                                  const SizedBox(width: Dimensions.space15),
                                  Text(
                                    MyStrings.soundNotification.tr,
                                    style: regularDefault.copyWith(color: MyColor.getTextColor()),
                                  ),
                                ],
                              ),
                              Switch(
                                activeTrackColor: MyColor.greenSuccessColor,
                                activeColor: MyColor.colorWhite,
                                inactiveTrackColor: MyColor.redCancelTextColor,
                                inactiveThumbColor: MyColor.colorWhite,
                                trackOutlineColor: WidgetStateProperty.all(MyColor.colorWhite),
                                value: controller.profileRepo.apiClient.isNotificationAudioEnable(),
                                onChanged: (value) {
                                  controller.profileRepo.apiClient.storeNotificationAudioEnable(value);
                                  controller.update();
                                },
                              ),
                            ],
                          ),
                        ),
                        spaceDown(Dimensions.space10),
                      ],
                    ),
                  ),
                  spaceDown(Dimensions.space15),
                  Container(
                    padding: const EdgeInsets.all(Dimensions.space15),
                    decoration: BoxDecoration(color: MyColor.getCardBgColor(), borderRadius: BorderRadius.circular(Dimensions.space12), boxShadow: MyUtils.getShadow()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeaderText(text: MyStrings.more.tr.toUpperCase(), textStyle: regularLarge.copyWith(color: MyColor.bodyText)),
                        const SizedBox(height: Dimensions.space20),
                        MenuRowWidget(image: MyImages.policy, label: MyStrings.policies, onPressed: () => Get.toNamed(RouteHelper.privacyScreen)),
                        const CustomDivider(space: Dimensions.space15),
                        MenuRowWidget(
                          image: MyImages.faq,
                          label: MyStrings.faq.tr,
                          onPressed: () async {
                            Get.toNamed(RouteHelper.faqScreen);
                          },
                        ),
                        const CustomDivider(space: Dimensions.space15),
                        MenuRowWidget(
                          image: MyImages.rateUs,
                          label: MyStrings.rateUs.tr,
                          onPressed: () async {
                            if (await controller.inAppReview.isAvailable()) {
                              controller.inAppReview.requestReview();
                            } else {
                              CustomSnackBar.error(errorList: [MyStrings.pleaseUploadYourAppOnPlayStore]);
                            }
                          },
                        ),
                        const CustomDivider(space: Dimensions.space15),
                        MenuRowWidget(
                          image: MyImages.userDelete,
                          label: controller.isDeleteBtnLoading ? "${MyStrings.loading}..." : MyStrings.deleteAccount,
                          onPressed: () {
                            CustomBottomSheet(bgColor: MyColor.getScreenBgColor(), child: DeleteAccountBottomSheetBody(controller: controller)).customBottomSheet(context);
                          },
                        ),
                        const CustomDivider(space: Dimensions.space15),
                        MenuRowWidget(
                          image: MyImages.logout,
                          imgColor: MyColor.redCancelTextColor,
                          textColor: MyColor.redCancelTextColor,
                          label: controller.logoutLoading ? "${MyStrings.loading}..." : MyStrings.logout,
                          onPressed: () {
                            controller.logout();
                          },
                        ),
                        spaceDown(Dimensions.space10),
                      ],
                    ),
                  ),
                  spaceDown(Dimensions.space50 * 2)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
