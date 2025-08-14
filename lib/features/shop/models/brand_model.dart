class BrandModel {
  String id;
  String name;
  String image;
  bool? isFeatured;
  int? productsCount;

  BrandModel({
    required this.id,
    required this.name,
    required this.image,
    this.isFeatured,
    this.productsCount,
  });

  // Empty Helper Function
  static BrandModel empty() {
    return BrandModel(id: '', image: '', name: '');
  }

  /// Conver model to JSON structure so that you can store data in Firestore
  toJson() {
    return {
      'Id': id,
      'Name': name,
      'Image': image,
      'ProductsCount': productsCount,
      'IsFeatured': isFeatured,
    };
  }

  /// Map from firebase to user model
  factory BrandModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) {
      return BrandModel.empty();
    }
    return BrandModel(
      id: data['Id'] ?? '',
      name: data['Name'] ?? '',
      image: data['Image'] ?? '',
      isFeatured: data['IsFeatured'] ?? false,
      productsCount: data['ProductsCount'] as int?,
    );
  }

  /// Map from firebase snapshot to user model
  factory BrandModel.fromMap(Map<String, dynamic> data) {
    // Map Json record to the Model
    return BrandModel(
      id: data['Id']?.toString() ?? '', // Adjust if UUID
      name:
          data['Name'] ??
          '', // lowercase if your DB column names follow SQL conventions
      image: data['Image'] ?? '',
      productsCount: data['ProductsCount'] ?? '',
      isFeatured: data['IsFeatured'] ?? false,
    );
  }
}
