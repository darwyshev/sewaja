import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sewaja/services/auth_service.dart';

class SignupController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // validasi singkat — gunakan return untuk stop eksekusi
    if (email.isEmpty) {
      Get.snackbar('Error', 'Email tidak boleh kosong',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (password.isEmpty) {
      Get.snackbar('Error', 'Password tidak boleh kosong',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (password != confirmPasswordController.text.trim()) {
      Get.snackbar('Error', 'Password tidak sama',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final ok = await AuthService().register(email, password, Get.context!);
      if (ok) {
        // sukses -> arahkan ke login
      } else {
        // sudah ditampilkan di service, tapi kalau perlu tampilkan tambahan:
        Get.snackbar('Error', 'Gagal membuat akun', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void signUpWithGoogle() async {
    isLoading.value = true;
    final ok = await AuthService().loginWithGoogle();
    isLoading.value = false;
    if (ok) {
      // setelah login with google, cek profile apakah lengkap
      final profile = await AuthService().supabase.from('profiles').select().eq('id', AuthService().supabase.auth.currentUser!.id).maybeSingle();
      if (profile == null) {
        // kalau kamu punya route complete-profile, arahkan ke situ
        Get.offAllNamed('/complete-profile');
      } else {
        Get.offAllNamed('/home');
      }
    }
  }

  void goToLogin() {
    Get.toNamed('/login');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
