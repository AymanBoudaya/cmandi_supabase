import 'user_model.dart';

class ClientModel extends UserModel {
  List<String> historiqueCommandes;
  ClientModel({required super.id, required super.firstName, required super.lastName, required super.username, required super.email, required super.phoneNumber, required super.profilePicture, this.historiqueCommandes = const[]});

}