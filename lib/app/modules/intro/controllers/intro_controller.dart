import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class IntroController extends GetxController {
  final PageController pageController = PageController();
  final currentPage = 0.obs;

  // Data intro slides
  final List<IntroData> introPages = [
    IntroData(
      image: 'assets/intro-1.png',
      title: 'Selamat datang di SEWAJA',
      description: 'Tempatnya nyewa barang-barang bekas, gak perlu beli baru!',
    ),
    IntroData(
      image: 'assets/intro-2.png',
      title: 'Butuh barang sementara?',
      description: 'Tinggal cari barangnya, booking, pinjam. Beres!',
    ),
    IntroData(
      image: 'assets/intro-3.png',
      title: 'Mulai sekarang juga',
      description: 'Cari barang yang kamu butuhkan atau booking untuk hari lain!',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      currentPage.value = pageController.page?.round() ?? 0;
    });
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < introPages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to home
      Get.offAllNamed(Routes.HOME);
    }
  }

  void skipIntro() {
    Get.offAllNamed(Routes.HOME);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class IntroData {
  final String image;
  final String title;
  final String description;

  IntroData({
    required this.image,
    required this.title,
    required this.description,
  });
}