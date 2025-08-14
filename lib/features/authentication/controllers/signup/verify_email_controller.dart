import 'dart:async';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/popups/loaders.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  /// Send email whenever verify screen appears & set timer for autoredirect
  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  /// Send email verification link
  Future<void> sendEmailVerification() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw "Aucun utilisateur connecté";

      // Envoyer l'email de vérification
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: user.email!,
      );

      TLoaders.successSnackBar(
        title: 'Email envoyé',
        message:
            "Veuillez consulter votre boîte de réception et vérifier votre email.",
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Erreur !', message: e.toString());
    }
  }

  /// Timer to automatically redirect on Email verification
  void setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        // Vérifier si l'email est confirmé
        final response = await Supabase.instance.client.auth.getUser();
        if (response.user?.emailConfirmedAt != null) {
          timer.cancel();
          Get.off(
            () => SuccessScreen(
              image: TImages.successfullyRegisterAnimation,
              title: TTexts.yourAccountCreatedTitle,
              subTitle: TTexts.yourAccountCreatedSubTitle,
              onPressed: () =>
                  AuthenticationRepository.instance.screenRedirect(),
            ),
          );
        }
      }
    });
  }

  /// Manual verification
  Future<void> checkEmailVerificationStatus() async {
    try {
      final response = await Supabase.instance.client.auth.getUser();
      if (response.user?.emailConfirmedAt != null) {
        Get.off(
          () => SuccessScreen(
            image: TImages.successfullyRegisterAnimation,
            title: TTexts.yourAccountCreatedTitle,
            subTitle: TTexts.yourAccountCreatedSubTitle,
            onPressed: () => AuthenticationRepository.instance.screenRedirect(),
          ),
        );
      } else {
        TLoaders.warningSnackBar(
          title: "Non vérifié",
          message: "Votre email n'est pas encore vérifié.",
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Erreur', message: e.toString());
    }
  }
}
