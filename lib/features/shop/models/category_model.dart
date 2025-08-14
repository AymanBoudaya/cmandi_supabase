import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String name;
  String image;
  String parentId;
  bool isFeatured;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isFeatured,
    this.parentId = '',
  });

  /// Empty helper function
  static CategoryModel empty() {
    return CategoryModel(
      id: '',
      image: '',
      name: '',
      isFeatured: false,
    );
  }

  /// Convert CategoryModel to Json structure so that you can store datat in Firebase
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Image': image,
      'ParentId': parentId,
      'IsFeatured': isFeatured,
    };
  }

  /// Map Json oriented document snapshot from firebase to UserModel

  factory CategoryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final json = document.data()!;
      return CategoryModel(
        id: document.id,
        name: json['Name'] ?? '',
        image: json['Image'] ?? '',
        parentId: json['ParentId'] ?? '',
        isFeatured: json['IsFeatured'] ?? false,
      );
    } else {
      return CategoryModel.empty();
    }
  }
}
