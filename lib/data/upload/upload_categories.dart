import '../../features/shop/models/category_model.dart';
import '../../utils/constants/image_strings.dart';

class UploadCategories {
  UploadCategories._();

  /// Dummy categories list
  static final List<CategoryModel> dummyCategories = [
    CategoryModel(
      id: '1',
      name: 'Café',
      image: TImages.coffee,
      isFeatured: true,
      parentId: '',
    ),
    CategoryModel(
      id: '2',
      name: 'Mlewi',
      image: TImages.mlewiCategory,
      isFeatured: true,
      parentId: '',
    ),
    CategoryModel(
      id: '3',
      name: 'Boissons',
      image: TImages.boissonsCategory,
      isFeatured: true,
      parentId: '',
    ),
    CategoryModel(
      id: '4',
      name: 'Petit Déjeuner',
      image: TImages.petitdej,
      isFeatured: true,
      parentId: '',
    ),
    CategoryModel(
      id: '5',
      name: 'Boissons',
      image: TImages.clothIcon,
      parentId: '1',
      isFeatured: true,
    ),
  ];
}
