// File: lib/app/modules/login/controllers/login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Pre-fill untuk testing (bisa dihapus)
    emailController.text = 'prayogawiryawan@gmail.com';
    passwordController.text = '**********';
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void login() {
    // Validasi
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

    // Proses login (kirim ke API)
    isLoading.value = true;
    
    // Simulasi API call
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar(
        'Berhasil',
        'Login berhasil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFC0E862),
        colorText: Colors.black,
      );
      
      // Navigate to home
      Get.offAllNamed('/home');
    });
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
}