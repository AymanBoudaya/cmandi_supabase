

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../authentication/screens/login/login.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final hidePassword = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.find<UserRepository>();
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  /// extraire l'utilisateur la table supabase
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
      Get.snackbar('Erreur', 'Impossible de récupérer les données utilisateur');
    } finally {
      profileLoading.value = false;
    }
  }

  /// Save user Record from any registration provider
  Future<void> saveUserRecord(User? supabaseUser) async {
    try {
      if (supabaseUser != null) {
        // Convert Name to First and Last Name (si displayName est stocké côté Supabase metadata)
        final displayName = supabaseUser.userMetadata?['full_name'] ?? '';
        final nameParts = UserModel.nameParts(displayName);
        final username = UserModel.generateUsername(displayName);

        // Map data (adapter selon ton modèle UserModel)
        final user = UserModel(
          id: supabaseUser.id,
          email: supabaseUser.email ?? '',
          firstName: nameParts.isNotEmpty ? nameParts[0] : '',
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
          username: username,
          phone: supabaseUser.phone ?? '',
          role: 'Client',
          orderIds: [],
          profileImageUrl: supabaseUser.userMetadata?['avatar_url'] ?? '',
        );

        // Sauvegarde (dans Supabase table "users" au lieu de Firestore !)
        await userRepository.saveUserRecord(user);
      }
    } catch (e) {
      TLoaders.warningSnackBar(
        title: 'Data not saved',
        message:
            "Something went wrong while saving your information. You can resave your data in your profile.",
      );
    }
  }

  /// Delete account Warning
  /*
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(AppSizes.md),
      title: 'Supprimer compte',
      middleText:
          "Êtes vous sûr? Cette action est irréversible et supprimera toutes vos données.",
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Text("Supprimer"),
        ),
      ),
      cancel: OutlinedButton(
          onPressed: () => Navigator.of(Get.overlayContext!).pop(),
          child: const Text('Annuler')),
    );
  }*/

  /// Delet user account
  /*
  void deleteUserAccount() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog(
          "Nous sommes en train de supprimer votre compte...",
          TImages.docerAnimation);

      /// First re-authenticate the user

      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;

      if (provider.isNotEmpty) {
        // Reverify auth email
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          TFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password') {
          TFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show error message
      TLoaders.warningSnackBar(title: "Erreur", message: e.toString());
    }
  }*/

  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          "Nous sommes en train de vérifier votre compte...",
          TImages.docerAnimation);

      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
              verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      TFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }
}
