// File: lib/services/profile_service.dart

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileService {
  final supabase = Supabase.instance.client;

  final String bucketName = "profiles";

  /// =========================
  ///  GET PROFILE (with auto-create)
  /// =========================
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        print("❌ User tidak login");
        return null;
      }

      print("🔍 Fetching profile for user: ${user.id}");

      var data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      // 🔥 JIKA PROFILE TIDAK ADA, BUAT BARU
      if (data == null) {
        print("⚠️ Profile not found, creating new profile...");
        
        final newProfile = {
          'id': user.id,
          'full_name': user.userMetadata?['full_name'] ?? 
                       user.userMetadata?['name'] ?? 
                       user.email ?? 
                       '',
          'avatar_url': user.userMetadata?['avatar_url'] ?? 
                        user.userMetadata?['picture'] ?? 
                        null,
          'city': null,
          'updated_at': DateTime.now().toIso8601String(),
        };

        await supabase.from('profiles').insert(newProfile);
        
        print("✅ New profile created!");
        
        // Fetch lagi setelah insert
        data = await supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();
      }

      print("✅ Profile data: $data");
      return data;
    } catch (e) {
      print("❌ Error getting profile: $e");
      Get.snackbar(
        "Error",
        "Gagal memuat profil: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  /// =========================
  ///  UPDATE PROFILE DATA
  /// =========================
  Future<bool> updateProfile({
    required String fullName,
    required String city,
    String? avatarUrl,
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        print("❌ User tidak login");
        Get.snackbar(
          "Error",
          "User tidak ditemukan!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      print("📝 Updating profile for user: ${user.id}");
      print("   - Full Name: $fullName");
      print("   - City: $city");
      print("   - Avatar URL: $avatarUrl");

      // 🔥 PASTIKAN PROFILE ROW ADA DULU
      await getProfile(); // Ini akan auto-create jika belum ada

      final updateData = {
        'full_name': fullName,
        'city': city,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        updateData['avatar_url'] = avatarUrl;
      }

      print("📤 Sending update data: $updateData");

      final response = await supabase
          .from('profiles')
          .update(updateData)
          .eq('id', user.id)
          .select();

      print("✅ Update response: $response");
      
      if (response.isEmpty) {
        print("⚠️ Update response is empty, but might still be successful");
        // Verify dengan fetch lagi
        final verify = await supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();
        print("🔍 Verification: $verify");
      }
      
      return true;
    } on PostgrestException catch (e) {
      print("❌ PostgrestException: ${e.message}");
      print("   Details: ${e.details}");
      print("   Hint: ${e.hint}");
      Get.snackbar(
        "Error",
        "Gagal update profil: ${e.message}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } catch (e) {
      print("❌ Error updating profile: $e");
      Get.snackbar(
        "Error",
        "Gagal update profil: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  /// =========================
  ///  UPLOAD PROFILE IMAGE (Fixed with better error handling)
  /// =========================
  Future<String?> uploadProfilePhoto(File file) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        print("❌ User tidak login");
        return null;
      }

      print("📤 Uploading profile photo for user: ${user.id}");

      final ext = extension(file.path);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = "${user.id}_$timestamp$ext";

      print("   - File name: $fileName");
      print("   - File size: ${await file.length()} bytes");

      // Read file as bytes
      final bytes = await file.readAsBytes();

      // Detect MIME type
      String contentType = 'image/jpeg';
      if (ext == '.png') {
        contentType = 'image/png';
      } else if (ext == '.jpg' || ext == '.jpeg') {
        contentType = 'image/jpeg';
      } else if (ext == '.gif') {
        contentType = 'image/gif';
      } else if (ext == '.webp') {
        contentType = 'image/webp';
      }

      print("   - Content Type: $contentType");

      // Upload dengan retry mechanism
      int retries = 3;
      String? publicUrl;

      while (retries > 0) {
        try {
          // Upload file
          await supabase.storage.from(bucketName).uploadBinary(
                fileName,
                bytes,
                fileOptions: FileOptions(
                  upsert: true,
                  contentType: contentType,
                  cacheControl: '3600',
                ),
              );

          print("✅ Upload successful!");

          // Get public URL dengan timestamp untuk force refresh
          publicUrl = supabase.storage
              .from(bucketName)
              .getPublicUrl(fileName);

          print("🔗 Public URL: $publicUrl");

          // Verify URL is accessible
          await _verifyImageUrl(publicUrl);
          
          return publicUrl;
        } catch (e) {
          retries--;
          print("⚠️ Upload attempt failed, retries left: $retries");
          if (retries == 0) rethrow;
          await Future.delayed(const Duration(seconds: 1));
        }
      }

      return publicUrl;
    } on StorageException catch (e) {
      print("❌ StorageException: ${e.message}");
      print("   Status Code: ${e.statusCode}");
      
      if (e.message.contains('not found') || e.statusCode == '404') {
        Get.snackbar(
          "Error",
          "Bucket 'profiles' tidak ditemukan. Pastikan bucket sudah dibuat dan public.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      } else if (e.statusCode == '400') {
        Get.snackbar(
          "Error",
          "Upload gagal. Pastikan bucket 'profiles' adalah PUBLIC dan policies sudah benar.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          "Error",
          "Gagal upload foto: ${e.message}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      return null;
    } catch (e) {
      print("❌ Error uploading photo: $e");
      Get.snackbar(
        "Error",
        "Gagal upload foto: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  /// Verify image URL is accessible
  Future<void> _verifyImageUrl(String url) async {
    try {
      print("🔍 Verifying image URL...");
      // Simple check - try to get the URL
      final response = await supabase.storage
          .from(bucketName)
          .createSignedUrl(url.split('/').last, 60);
      print("✅ Image URL verified: $response");
    } catch (e) {
      print("⚠️ Image verification warning: $e");
      // Don't throw, just warn
    }
  }
}