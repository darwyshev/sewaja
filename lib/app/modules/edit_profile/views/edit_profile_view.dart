import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.nameC.text.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildAvatarSection(),
                      const SizedBox(height: 40),

                      // NAMA LENGKAP
                      _buildTextField(
                        label: 'Nama Lengkap',
                        controller: controller.nameC,
                      ),
                      const SizedBox(height: 24),

                      // KOTA
                      _buildTextField(
                        label: 'Kota',
                        controller: controller.cityC,
                      ),

                      const SizedBox(height: 40),
                      _buildConfirmButton(),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Ubuntu',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Stack(
        children: [
          Obx(() {
            final path = controller.userPhoto.value;

            // 🔥 FIX: Gunakan Image.network untuk URL, File untuk local, Asset untuk default
            Widget avatarWidget;

            if (path.startsWith('http')) {
              // Network image dari Supabase
              avatarWidget = ClipOval(
                child: Image.network(
                  path,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print("❌ Error loading network image: $error");
                    return Image.asset(
                      'assets/profile/avatar.jpg',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              );
            } else if (path.isNotEmpty && File(path).existsSync()) {
              // Local file dari image picker
              avatarWidget = ClipOval(
                child: Image.file(
                  File(path),
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              );
            } else {
              // Fallback ke asset default
              avatarWidget = ClipOval(
                child: Image.asset(
                  'assets/profile/avatar.jpg',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: controller.isUploading.value 
                      ? Colors.blue 
                      : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Stack(
                children: [
                  avatarWidget,
                  if (controller.isUploading.value)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
          Positioned(
            bottom: 0,
            right: 0,
            child: Obx(() => GestureDetector(
              onTap: controller.isUploading.value ? null : controller.pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: controller.isUploading.value 
                      ? Colors.grey 
                      : const Color(0xFFC0E862),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.isUploading.value ? Icons.hourglass_bottom : Icons.edit,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black.withOpacity(0.6),
            fontFamily: 'Ubuntu',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Ubuntu',
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.3),
                fontFamily: 'Ubuntu',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.isLoading.value || controller.isUploading.value
            ? null
            : controller.saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0E1111),
          disabledBackgroundColor: const Color(0xFF0E1111).withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: controller.isLoading.value || controller.isUploading.value
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Konfirmasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Ubuntu',
                ),
              ),
      ),
    ));
  }
}