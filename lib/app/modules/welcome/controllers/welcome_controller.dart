// File: lib/app/modules/welcome/controllers/welcome_controller.dart

import 'package:get/get.dart';

class WelcomeController extends GetxController {
  
  void goToSignUp() {
    Get.toNamed('/signup');
  }

  void goToLogin() {
    Get.toNamed('/login');
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}