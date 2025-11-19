// File: lib/app/modules/home/controllers/home_controller.dart

import 'package:get/get.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final selectedCategory = 'Semua'.obs;

  final List<String> categories = [
    'Semua',
    'Outdoor',
    'Sport',
    'Perabotan',
  ];

  // Dummy data produk
  final List<Product> products = [
    Product(
      name: 'Tenda Quechua',
      price: 150000,
      image: 'assets/products/tenda.jpg',
      rating: 5.0,
      reviews: 40,
    ),
    Product(
      name: 'Sepeda Kuno Klasik',
      price: 55000,
      image: 'assets/products/sepeda.jpg',
      rating: 5.0,
      reviews: 149,
    ),
    Product(
      name: 'Sepatu Bola',
      price: 45000,
      image: 'assets/products/sepatu.jpg',
      rating: 5.0,
      reviews: 89,
    ),
    Product(
      name: 'Kamera Canon',
      price: 200000,
      image: 'assets/products/kamera.jpg',
      rating: 5.0,
      reviews: 99,
    ),
  ];

  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  void changeBottomNav(int index) {
    currentIndex.value = index;
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

class Product {
  final String name;
  final int price;
  final String image;
  final double rating;
  final int reviews;

  Product({
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
    required this.reviews,
  });
}