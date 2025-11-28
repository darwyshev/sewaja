// File: lib/app/modules/profile/controllers/profile_controller.dart

import 'package:get/get.dart';
import 'package:sewaja/services/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService profileService = ProfileService();

  // Observable data
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhoto = ''.obs;

  var userKota = ''.obs;

  // Menu items dengan icons
  final List<ProfileMenuItem> topMenuItems = [
    ProfileMenuItem(
      icon: '⚙️',
      title: 'Pengaturan',
      onTap: () => Get.toNamed('/settings'),
    ),
    ProfileMenuItem(
      icon: '📋',
      title: 'Pesananku',
      onTap: () => Get.toNamed('/orders'),
    ),
    ProfileMenuItem(
      icon: '📍',
      title: 'Alamat',
      onTap: () => Get.toNamed('/address'),
    ),
    ProfileMenuItem(
      icon: '⚙️',
      title: 'Status Akun',
      onTap: () => Get.toNamed('/account-status'),
    ),
  ];

  final List<ProfileMenuItem> bottomMenuItems = [
    ProfileMenuItem(
      icon: '🛒',
      title: 'Barangku',
      onTap: () => Get.toNamed('/my-items'),
    ),
    ProfileMenuItem(
      icon: '💰',
      title: 'Pendapatan',
      onTap: () => Get.toNamed('/income'),
    ),
    ProfileMenuItem(
      icon: '❓',
      title: 'Bantuan & Dukungan',
      onTap: () => Get.toNamed('/help'),
    ),
    ProfileMenuItem(
      icon: '📜',
      title: 'Riwayat Transaksi',
      onTap: () => Get.toNamed('/transaction-history'),
    ),
  ];
  
  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final data = await profileService.getProfile();
    if (data != null) {
      userName.value = data['full_name'] ?? '-';
      userEmail.value = data['email'] ?? '-';
      userPhoto.value = data['avatar_url'] ?? 'assets/profile/avatar.jpg';

      userKota.value = data['city'] ?? '-';
    }
  }

  void editProfile() {
    Get.toNamed('/edit-profile')!.then((_) {
      // Refresh data setelah edit
      loadProfile();
    });
  }
}

class ProfileMenuItem {
  final String icon;
  final String title;
  final Function onTap;

  ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
