import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import '../../../core/helper/string_format_helper.dart';
import '../../../core/route/route.dart';
import '../../../core/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../model/auth/login/login_response_model.dart';
import '../../model/global/response_model/response_model.dart';
import '../../model/user/user.dart';
import '../../repo/auth/social_login_repo.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialLoginController extends GetxController {
  SocialLoginRepo repo;
  SocialLoginController({required this.repo});

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  bool isGoogleSignInLoading = false;

  Future<void> signInWithGoogle() async {
    try {
      isGoogleSignInLoading = true;
      update();
      const List<String> scopes = <String>['email', 'profile'];
      googleSignIn.signOut();
      await googleSignIn.initialize();
      var googleUser = await googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      if (googleAuth.idToken == null) {
        isGoogleSignInLoading = false;
        update();
        return;
      }
      final GoogleSignInClientAuthorization? authorization = await googleUser.authorizationClient.authorizationForScopes(scopes);
      printX(authorization?.accessToken);

      await socialLoginUser(
        provider: 'google',
        accessToken: authorization?.accessToken ?? '',
      );
    } catch (e) {
      printX(e.toString());
      // CustomSnackBar.error(errorList: [e.toString()]);
    }

    isGoogleSignInLoading = false;
    update();
  }

  bool isAppleSignInLoading = false;
  Future signInWithApple() async {
    isAppleSignInLoading = true;
    update();
    try {
      final AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName]);
      printX(credential.email);
      printX(credential.givenName);
      printX(credential.familyName);
      printX(credential.authorizationCode);
      printX(credential.identityToken);
      socialLoginUser(accessToken: credential.identityToken ?? '', provider: 'apple');
    } catch (e) {
      printX(e.toString());
      CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
    } finally {
      isAppleSignInLoading = false;
      update();
    }
  }

  Future socialLoginUser({
    String accessToken = '',
    String? provider,
  }) async {
    try {
      ResponseModel responseModel = await repo.socialLoginUser(
        accessToken: accessToken,
        provider: provider,
      );
      if (responseModel.statusCode == 200) {
        LoginResponseModel loginModel = LoginResponseModel.fromJson((responseModel.responseJson));
        if (loginModel.status.toString().toLowerCase() == MyStrings.success.toLowerCase()) {
          String accessToken = loginModel.data?.accessToken ?? "";
          String tokenType = loginModel.data?.tokenType ?? "";
          User? user = loginModel.data?.user;
          await RouteHelper.checkUserStatusAndGoToNextStep(user, accessToken: accessToken, tokenType: tokenType, isRemember: true);
        } else {
          CustomSnackBar.error(errorList: loginModel.message ?? [MyStrings.loginFailedTryAgain.tr]);
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printX(e.toString());
    }
  }
}
