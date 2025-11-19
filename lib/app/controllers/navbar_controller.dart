import 'package:get/get.dart';

class NavbarController extends GetxController {
  final currentIndex = 0.obs;

  void changeBottomNav(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        Get.offNamed('/home');
        break;
      case 1:
        Get.offNamed('/chat');
        break;
      case 2:
        Get.offNamed('/cart');
        break;
      case 3:
        Get.offNamed('/profile');
        break;
    }
  }
}
