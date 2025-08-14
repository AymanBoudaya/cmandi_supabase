/*
import 'package:caferesto/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
*/
import 'package:flutter/services.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/authentication/screens/login/login.dart';
import '../../../features/authentication/screens/onboarding/onboarding.dart';
import '../../../features/authentication/screens/signup.widgets/verify_email.dart';
import '../../../navigation_menu.dart';
import '../../../utils/local_storage/storage_utility.dart';

class AuthenticationRepository extends GetxController {
  //  Getter statique, accessible globalement via .instance
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = Supabase.instance.client.auth;

  Session? get session => _auth.currentSession;
  User? get authUser => _auth.currentUser;

  /// Called from main.dart on app launch
  @override
  void onReady() {
    //super.onReady();
    // Remove the native splash screen
    FlutterNativeSplash.remove();

    // Redirect to the appropriate screen
    screenRedirect();
  }

  /// Function to show relevant screen
  screenRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {
      // si l'utilisateur est authentifié
      if (user.emailConfirmedAt != null) {
        // Initializing user specific storage
        await TLocalStorage.init(user.id);

        Get.offAll(() => const NavigationMenu());
      } else {
        Get.offAll(
          () => VerifyEmailScreen(
            // si on utilise _auth.currentUser => (! erreur ajouter ?) meme pour authUser les deux sont des getters qui peuvent etre nuls
            // Dart dit : « Je ne suis pas sûr que currentUser n’est plus null. Tu dois utiliser ? ou le stocker dans une variable.
            email: user.email ?? '',
          ),
        );
      }
    } else {
      // Local Storage
      deviceStorage.writeIfNull('IsFirstTime', true);

      // Check if it's the first time launching the app
      deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(
              () => const LoginScreen(),
            ) // Redirect to login Screen
          : Get.offAll(
              () => const OnBoardingScreen(),
            ); // Redirect to On barding Screen
    }
  }

  /// [EmailAuthentication] - LOGIN
  Future<AuthResponse> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) throw 'Invalid credentials.';
      return response;
    } on AuthException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message ?? 'Platform error occurred.';
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /* --- Email & Password sign-in ---*/
  /// [EmailAuthentication] - REGISTER
  Future<AuthResponse> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        emailRedirectTo:
            'https://your-project.supabase.co/auth/v1/callback', // 🔹 à configurer
      );
      return response;
    } on AuthException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message ?? 'Platform error occurred.';
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [EmailVerification] - MAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      final email = authUser?.email;
      if (email == null) throw 'No authenticated user found.';
      await _auth.resend(email: email, type: OtpType.signup);
    } on AuthException catch (e) {
      throw e.message;
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [LogoutUser] - Valid for any authentication
  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAll(() => const LoginScreen());
    } on AuthException catch (e) {
      throw e.message;
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [ReAuthenticate] - RE-AUTHENTICATE USER
  Future<void> reAuthenticateWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await loginWithEmailAndPassword(email, password);
  }

  /* --- Federated identity & social sign-in ---*/
  /// [GoogleAuthentication] - GOOGLE
  /// Google sign-in avec Supabase (via OAuth)
  /*Future<AuthResponse?> signInWithGoogle() async {
    try {
      final response = await _auth.signInWithOAuth(
        Provider.google,
        redirectTo:
            'io.supabase.flutter://login-callback/', // Android/iOS deep link
      );
      return response;
    } on AuthException catch (e) {
      throw e.message;
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }*/

  /// [EmailAuthentication] - FORGOT PASSWORD
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw e.message;
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> deleteAccount() async {
    try {
      // Supabase n'a pas d'API "delete user" côté client => doit passer par une fonction RPC sécurisée côté serveur
      throw 'Account deletion must be handled server-side via Supabase Admin API.';
    } catch (e) {
      throw e.toString();
    }
  }
}
