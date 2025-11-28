import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  /// LOGIN EMAIL / PASSWORD
  Future<bool> login(
    String? email,
    String password,
    BuildContext context,
  ) async {
    try {
      if (email == null || email.isEmpty) {
        Get.snackbar('Error', 'Email tidak boleh kosong',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }

      if (password.isEmpty) {
        Get.snackbar('Error', 'Password tidak boleh kosong',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }

      final res = await supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (res.user != null) {
        return true;
      } else {
        Get.snackbar('Error', 'Login gagal', backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: $e'), backgroundColor: Colors.red),
      );
      return false;
    }
  }

  /// REGISTER EMAIL / PASSWORD
  /// Returns true if successful (user created)
  Future<bool> register(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final res = await supabase.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      if (res.user != null) {
        // jangan navigate di service — controller yang mengatur navigasi
        // ensure profile row exists (some setups insert via trigger; this is a safety net)
        try {
          final user = res.user!;
          final profile = await supabase.from('profiles').select().eq('id', user.id).maybeSingle();
          if (profile == null) {
            await supabase.from('profiles').insert({
              'id': user.id,
              'full_name': '',
              'avatar_url': null,
              'city': null,
              'updated_at': DateTime.now().toIso8601String(),
            });
          }
        } catch (_) {
          // ignore insert error here; it's non-fatal (but should be logged)
        }

        return true;
      } else {
        Get.snackbar('Error', 'Register gagal', backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Register gagal: $e'), backgroundColor: Colors.red),
      );
      return false;
    }
  }

  /// LOGIN GOOGLE (SUPABASE)
  /// returns true if login succeeded
  Future<bool> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;

      final res = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      final user = res.user;
      if (user == null) return false;

      // Ensure profile row exists (if your DB already has trigger, this will just detect)
      final existing = await supabase.from('profiles').select().eq('id', user.id).maybeSingle();
      if (existing == null) {
        await supabase.from('profiles').insert({
          'id': user.id,
          'full_name': user.userMetadata?['name'] ?? user.email ?? '',
          'avatar_url': user.userMetadata?['picture'] ?? null,
          'city': null,
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      return true;
    } catch (e) {
      Get.snackbar("Error", "Google Sign-In gagal: $e");
      return false;
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await supabase.auth.signOut();
    Get.offAllNamed('/login');
  }

  /// GET CURRENT USER
  User? get currentUser => supabase.auth.currentUser;
}
