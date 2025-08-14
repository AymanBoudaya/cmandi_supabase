// gerant_model.dart
import 'user_model.dart';

class GerantModel extends UserModel {
  // Exemple d’attributs spécifiques au gérant
  List<String> commandesEnCours;

  GerantModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.username,
    required super.email,
    required super.phoneNumber,
    required super.profilePicture,
    this.commandesEnCours = const [],
  });
}
