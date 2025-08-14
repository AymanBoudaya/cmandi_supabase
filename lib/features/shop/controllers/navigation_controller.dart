import 'package:get/get.dart';

import '../../personalization/screens/settings/settings.dart';
import '../screens/home/home.dart';
import '../screens/store/store.dart';
import '../screens/wishlist/wishlist.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    HomeScreen(),
    StoreScreen(),
    FavoriteScreen(),
    SettingsScreen(),
  ];
}
