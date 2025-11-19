// File: lib/app/modules/profile/views/profile_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProfileSection(),
                    const SizedBox(height: 20),
                    _buildMenuSection(controller.topMenuItems),
                    const SizedBox(height: 20),
                    _buildMenuSection(controller.bottomMenuItems),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(top: false, child: _buildBottomNav()),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Profil',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Ubuntu',
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        // Avatar with border
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF0E1111), width: 3),
          ),
          child: Obx(
            () => CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(controller.userPhoto.value),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Name
        Obx(
          () => Text(
            controller.userName.value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Ubuntu',
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Email
        Obx(
          () => Text(
            controller.userEmail.value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withOpacity(0.6),
              fontFamily: 'Ubuntu',
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Edit Profile Button
        GestureDetector(
          onTap: controller.editProfile,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0E1111),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Edit Profil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Ubuntu',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(List<ProfileMenuItem> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              _buildMenuItem(
                icon: _getIconData(item.title),
                title: item.title,
                onTap: () => item.onTap(),
              ),
              if (index < items.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.black.withOpacity(0.05),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: const Color(0xFF0E1111)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontFamily: 'Ubuntu'),
              ),
            ),
            const Icon(Icons.chevron_right, size: 24, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String title) {
    switch (title) {
      case 'Pengaturan':
        return Icons.settings;
      case 'Pesananku':
        return Icons.receipt_long;
      case 'Alamat':
        return Icons.location_on;
      case 'Status Akun':
        return Icons.verified_user;
      case 'Barangku':
        return Icons.inventory_2;
      case 'Pendapatan':
        return Icons.wallet;
      case 'Bantuan & Dukungan':
        return Icons.help;
      case 'Riwayat Transaksi':
        return Icons.history;
      default:
        return Icons.circle;
    }
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.chat_bubble, 1),
          _buildNavItem(Icons.shopping_cart, 2),
          _buildNavItem(Icons.person, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = index == 3; // Profile is selected (index 3)
    return GestureDetector(
      onTap: () {
        if (index == 0) Get.offNamed('/home');
        if (index == 1) Get.offNamed('/chat');
        if (index == 2) Get.offNamed('/cart');
        if (index == 3) Get.offNamed('/profile');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC0E862) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
