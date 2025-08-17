import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/personalization/models/user_model.dart';
import '../../../utils/exceptions/supabase_auth_exceptions.dart';
import '../../repositories/authentication/authentication_repository.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final SupabaseClient _supabase = Supabase.instance.client;
  final String _table = 'Users'; // Nom de ta table Supabase

  /// Sauvegarder un nouvel utilisateur
  Future<void> saveUserRecord(UserModel user) async {
    try {
      final response = await _supabase.from(_table).insert(user.toJson());
      if (response.isEmpty) throw 'Failed to save user.';
    } on AuthException catch (e) {
      throw SupabaseAuthException(e.message,
          statusCode: int.tryParse(e.statusCode ?? ''));
    } on FormatException {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Récupérer les infos de l'utilisateur connecté
  Future<UserModel> fetchUserDetails() async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.id;
      if (userId == null) throw 'No authenticated user.';

      final response =
          await _supabase.from(_table).select().eq('id', userId).maybeSingle();

      if (response == null) {
        return UserModel.empty();
      }
      return UserModel.fromJson(response);
    } on AuthException catch (e) {
      throw SupabaseAuthException(e.message,
          statusCode: int.tryParse(e.statusCode ?? ''));
    } on FormatException {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Mettre à jour un utilisateur
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      final response = await _supabase
          .from(_table)
          .update(updatedUser.toJson())
          .eq('id', updatedUser.id);

      if (response.isEmpty) throw 'Update failed.';
    } on AuthException catch (e) {
      throw SupabaseAuthException(e.message,
          statusCode: int.tryParse(e.statusCode ?? ''));
    } on FormatException {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Mettre à jour un champ spécifique
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.id;
      if (userId == null) throw 'No authenticated user.';

      final response =
          await _supabase.from(_table).update(json).eq('id', userId);

      if (response.isEmpty) throw 'Update failed.';
    } on AuthException catch (e) {
      throw SupabaseAuthException(e.message,
          statusCode: int.tryParse(e.statusCode ?? ''));
    } on FormatException {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Supprimer un utilisateur
  Future<void> removeUserRecord(String userId) async {
    try {
      final response = await _supabase.from(_table).delete().eq('id', userId);

      if (response.isEmpty) throw 'Delete failed.';
    } on AuthException catch (e) {
      throw SupabaseAuthException(e.message,
          statusCode: int.tryParse(e.statusCode ?? ''));
    } on FormatException {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }
}
