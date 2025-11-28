// File: lib/app/modules/login/controllers/login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sewaja/services/auth_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  final authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    // Pre-fill untuk testing (bisa dihapus)
    emailController.text = 'aku@mail.com';
    passwordController.text = '12345678';
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void login() async {
  if (emailController.text.isEmpty) {
    Get.snackbar(
      'Error',
      'Email tidak boleh kosong',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  if (passwordController.text.isEmpty) {
    Get.snackbar(
      'Error',
      'Password tidak boleh kosong',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  isLoading.value = true;

  final success = await authService.login(
    emailController.text,
    passwordController.text,
    Get.context!,
  );

  isLoading.value = false;

  if (success) {
    // 🔥 INI YANG TIDAK KAMU PUNYA
    Get.offAllNamed('/home');
  }
}

  void loginWithGoogle() {
    Get.snackbar(
      'Info',
      'Login dengan Google',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFC0E862),
      colorText: Colors.black,
    );
    // Implement Google Sign In
  }

  void forgotPassword() {
    Get.snackbar(
      'Info',
      'Fitur lupa password',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFC0E862),
      colorText: Colors.black,
    );
    // Navigate to forgot password page
  }

  void goToSignUp() {
    Get.toNamed('/signup');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void loginGoogle() {
  authService.loginWithGoogle();
}
}
