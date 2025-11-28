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

  final isLoading = false.obs;
  final isUploading = false.obs;

  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      print("🔄 Loading profile...");
      
      final data = await profileService.getProfile();
      
      if (data != null) {
        nameC.text = data['full_name'] ?? '';
        cityC.text = data['city'] ?? '';
        
        final avatarUrl = data['avatar_url'];
        userPhoto.value = (avatarUrl != null && avatarUrl.toString().isNotEmpty)
            ? avatarUrl
            : 'assets/profile/avatar.jpg';

        print("✅ Profile loaded:");
        print("   - Name: ${nameC.text}");
        print("   - City: ${cityC.text}");
        print("   - Avatar: ${userPhoto.value}");
      } else {
        print("⚠️ No profile data found");
      }
    } catch (e) {
      print("❌ Error loading profile: $e");
      Get.snackbar(
        "Error",
        "Gagal memuat profil: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      print("📷 Opening image picker...");
      
      final XFile? img = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
      );

      if (img != null) {
        photoFile = File(img.path);
        userPhoto.value = img.path; // preview lokal
        
        print("✅ Image picked: ${img.path}");
        print("   - Size: ${await photoFile!.length()} bytes");
      } else {
        print("⚠️ No image selected");
      }
    } catch (e) {
      print("❌ Error picking image: $e");
      Get.snackbar(
        "Error",
        "Gagal memilih gambar: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> saveProfile() async {
    try {
      // Validasi input
      if (nameC.text.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Nama lengkap tidak boleh kosong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (cityC.text.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Kota tidak boleh kosong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      isLoading.value = true;
      print("💾 Saving profile...");

      String? uploadedUrl;

      // Upload foto jika ada
      if (photoFile != null) {
        print("📤 Uploading photo...");
        isUploading.value = true;
        
        uploadedUrl = await profileService.uploadProfilePhoto(photoFile!);
        
        isUploading.value = false;
        
        if (uploadedUrl == null) {
          print("❌ Photo upload failed");
          Get.snackbar(
            "Error",
            "Gagal upload foto. Profil akan disimpan tanpa foto baru.",
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          print("✅ Photo uploaded: $uploadedUrl");
        }
      }

      // Tentukan avatar URL yang akan disimpan
      String? finalAvatarUrl;
      if (uploadedUrl != null) {
        finalAvatarUrl = uploadedUrl;
      } else if (userPhoto.value.startsWith('http')) {
        finalAvatarUrl = userPhoto.value;
      }

      print("📝 Updating profile with:");
      print("   - Name: ${nameC.text}");
      print("   - City: ${cityC.text}");
      print("   - Avatar URL: $finalAvatarUrl");

      // Update profil
      final success = await profileService.updateProfile(
        fullName: nameC.text.trim(),
        city: cityC.text.trim(),
        avatarUrl: finalAvatarUrl,
      );

      if (success) {
        print("✅ Profile updated successfully!");
        
        Get.snackbar(
          "Berhasil",
          "Profil berhasil diperbarui",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Kembali ke halaman profil
        Get.back();
      } else {
        print("❌ Profile update failed");
      }
    } catch (e) {
      print("❌ Error saving profile: $e");
      Get.snackbar(
        "Error",
        "Gagal menyimpan profil: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      isUploading.value = false;
    }
  }

  @override
  void onClose() {
    nameC.dispose();
    cityC.dispose();
    super.onClose();
  }
}