class CategoryModel {
  String id;
  String name;
  String image;
  String parentId;
  bool isFeatured;

  CategoryModel({
    this.id = '',
    required this.name,
    required this.image,
    required this.isFeatured,
    this.parentId = '',
  });

  /// Empty helper function
  static CategoryModel empty() {
    return CategoryModel(
        id: '', image: '', name: '', isFeatured: false, parentId: '');
  }

  /// Convert CategoryModel to Json structure so that you can store datat in Firebase
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'parentId': parentId,
      'isFeatured': isFeatured,
    };
  }

  /// Map Json oriented document snapshot from firebase to UserModel

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    try {
      return CategoryModel(
        id: json['id'].toString(),
        name: json['name'],
        image: json['image'] ?? '',
        parentId: json['parentId'] ?? '',
        isFeatured: json['isFeatured'] ?? false,
      );
    } catch (e) {
      return CategoryModel.empty();
    }
  }
}
