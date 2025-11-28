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
        // 🔥 PASTIKAN PROFILE ROW ADA
        await _ensureProfileExists(res.user!);
        return true;
      } else {
        Get.snackbar('Error', 'Login gagal', 
            backgroundColor: Colors.red, colorText: Colors.white);
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
  Future<bool> register(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      print("📝 Registering user: $email");
      
      final res = await supabase.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      if (res.user != null) {
        print("✅ User registered: ${res.user!.id}");
        
        // 🔥 PASTIKAN PROFILE ROW DIBUAT
        await _ensureProfileExists(res.user!);
        
        return true;
      } else {
        Get.snackbar('Error', 'Register gagal', 
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } on AuthException catch (e) {
      print("❌ AuthException: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
      return false;
    } catch (e) {
      print("❌ Register error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Register gagal: $e'), backgroundColor: Colors.red),
      );
      return false;
    }
  }

  /// LOGIN GOOGLE (SUPABASE)
  Future<bool> loginWithGoogle() async {
    try {
      print("🔐 Starting Google Sign-In...");
      
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("⚠️ User cancelled Google Sign-In");
        return false;
      }

      print("✅ Google user: ${googleUser.email}");
      
      final googleAuth = await googleUser.authentication;

      final res = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      final user = res.user;
      if (user == null) {
        print("❌ No user returned from Supabase");
        return false;
      }

      print("✅ Supabase user: ${user.id}");

      // 🔥 PASTIKAN PROFILE ROW ADA
      await _ensureProfileExists(user);

      return true;
    } catch (e) {
      print("❌ Google Sign-In error: $e");
      Get.snackbar("Error", "Google Sign-In gagal: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  /// 🔥 HELPER: PASTIKAN PROFILE ROW EXISTS
  Future<void> _ensureProfileExists(User user) async {
    try {
      print("🔍 Checking if profile exists for user: ${user.id}");
      
      // Cek apakah profile sudah ada
      final existing = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (existing == null) {
        print("⚠️ Profile not found, creating new profile...");
        
        // Buat profile baru
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

        print("📤 Inserting profile: $newProfile");

        await supabase.from('profiles').insert(newProfile);
        
        print("✅ Profile created successfully!");
      } else {
        print("✅ Profile already exists");
      }
    } catch (e) {
      print("❌ Error ensuring profile exists: $e");
      // Don't throw error, just log it
      // Karena ini non-critical, user masih bisa login
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