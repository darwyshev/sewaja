// File: lib/app/modules/welcome/bindings/welcome_binding.dart

import 'package:get/get.dart';
import '../controllers/welcome_controller.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(
      () => WelcomeController(),
    );
  }
}