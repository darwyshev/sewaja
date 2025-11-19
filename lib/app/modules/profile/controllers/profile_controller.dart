// File: lib/app/modules/profile/controllers/profile_controller.dart

import 'package:get/get.dart';

class ProfileController extends GetxController {
  // User data (bisa diganti dengan data dari API)
  final userName = 'Prayoga Darius'.obs;
  final userEmail = 'prayogawiryawan@gmail.com'.obs;
  final userPhoto = 'assets/profile/avatar.jpg'.obs;

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

  void editProfile() {
    Get.toNamed('/edit-profile');
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
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