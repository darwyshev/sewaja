import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthService {
  final supabase = Supabase.instance.client;
  Future<void> login(
    String? email,
    String password,
    BuildContext context,
  ) async {
    try {
      // Debug: cek email dan password
      print('Email: $email');
      print('Password: $password');

      // Validasi email tidak null atau empty
      if (email == null || email.isEmpty) {
        throw Exception('Email tidak boleh kosong');
      }

      if (password.isEmpty) {
        throw Exception('Password tidak boleh kosong');
      }

      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? user = res.user;
      if (user != null) {
        Get.offAllNamed('/home');
      }
    } on AuthException catch (e) {
      print('AuthException: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    } catch (e) {
      print('Login Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
