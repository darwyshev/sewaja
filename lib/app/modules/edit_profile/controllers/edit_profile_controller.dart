import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sewaja/services/profile_service.dart';

class EditProfileController extends GetxController {
  final ProfileService profileService = ProfileService();

  final nameC = TextEditingController();
  final cityC = TextEditingController();

  final userPhoto = ''.obs;
  File? photoFile;

  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final data = await profileService.getProfile();
    if (data != null) {
      nameC.text = data['full_name'] ?? '';
      cityC.text = data['city'] ?? '';
      userPhoto.value = 
        (data['avatar_url'] != null && data['avatar_url'].toString().isNotEmpty)
            ? data['avatar_url']
            : 'assets/profile/avatar.jpg';

    }
  }

  Future<void> pickImage() async {
    final XFile? img =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);

    if (img != null) {
      photoFile = File(img.path);
      userPhoto.value = img.path; // preview lokal
    }
  }

  Future<void> saveProfile() async {
    String? uploadedUrl;

    if (photoFile != null) {
      uploadedUrl = await profileService.uploadProfilePhoto(photoFile!);
    }

    await profileService.updateProfile(
      fullName: nameC.text,
      city: cityC.text,
      avatarUrl: uploadedUrl ??
      (userPhoto.value.startsWith('http') ? userPhoto.value : null),
    );

    Get.snackbar(
      "Berhasil",
      "Profil berhasil diperbarui",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );

    Get.back();
  }

  @override
  void onClose() {
    nameC.dispose();
    cityC.dispose();
    super.onClose();
  }
}
