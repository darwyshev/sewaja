// File: lib/app/modules/edit_profile/controllers/edit_profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cityController = TextEditingController();

  final userPhoto = 'assets/profile/avatar.jpg'.obs;
  final isPasswordVisible = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Load user data (bisa dari API atau local storage)
    nameController.text = 'Prayoga Darius';
    emailController.text = 'prayogawiryawan@gmail.com';
    passwordController.text = '**********';
    cityController.text = 'Malang, Jawa Timur';
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      
      if (image != null) {
        userPhoto.value = image.path;
        Get.snackbar(
          'Berhasil',
          'Foto profil berhasil diubah',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFC0E862),
          colorText: Colors.black,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih foto',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void saveProfile() {
    // Validasi
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

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

    // Simpan data (kirim ke API atau local storage)
    Get.snackbar(
      'Berhasil',
      'Profil berhasil diperbarui',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFC0E862),
      colorText: Colors.black,
    );

    // Kembali ke halaman profil
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cityController.dispose();
    super.onClose();
  }
}