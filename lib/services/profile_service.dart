// File: lib/services/profile_service.dart

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart';

class ProfileService {
  final supabase = Supabase.instance.client;

  final String bucketName = "profiles";

  /// =========================
  ///  GET PROFILE
  /// =========================
  Future<Map<String, dynamic>?> getProfile() async {
    final user = supabase.auth.currentUser;

    if (user == null) return null;

    final data = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return data;
  }

  /// =========================
  ///  UPDATE PROFILE DATA
  /// =========================
  Future<void> updateProfile({
    required String fullName,
    required String city,
    String? avatarUrl,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw "User tidak ditemukan!";

    final updateData = {
      'full_name': fullName,
      'city': city,
    };

    if (avatarUrl != null) {
      updateData['avatar_url'] = avatarUrl;
    }

    await supabase
    .from('profiles')
    .update(updateData)
    .eq('id', user.id)
    .select();
  }

  /// =========================
  ///  UPLOAD PROFILE IMAGE
  /// =========================
  Future<String?> uploadProfilePhoto(File file) async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final ext = extension(file.path); // .jpg / .png
    final fileName = "${user.id}${ext}";

    await supabase.storage.from(bucketName).uploadBinary(
          fileName,
          await file.readAsBytes(),
          fileOptions: const FileOptions(upsert: true),
        );

    final publicUrl =
        supabase.storage.from(bucketName).getPublicUrl(fileName);

    return publicUrl;
  }
}
