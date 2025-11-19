import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/intro_controller.dart';

class IntroView extends GetView<IntroController> {
  const IntroView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: controller.introPages.length,
              itemBuilder: (context, index) {
                return _buildIntroPage(controller.introPages[index]);
              },
            ),
          ),
          SafeArea(child: _buildBottomSection()),
        ],
      ),
    );
  }

  Widget _buildIntroPage(IntroData intro) {
    return Column(
      children: [
        // Image Section - Full width and top
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(intro.image),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        // Text Section
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  intro.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),
                Text(
                  intro.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF000000).withOpacity(0.6),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Page Indicators
          Obx(
            () => Row(
              children: List.generate(
                controller.introPages.length,
                (index) => Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: controller.currentPage.value == index ? 32 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: controller.currentPage.value == index
                        ? const Color(0xFF000000)
                        : const Color(0xFF000000).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          // Next Button
          Obx(
            () => GestureDetector(
              onTap: controller.nextPage,
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFC0E862),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.currentPage.value ==
                          controller.introPages.length - 1
                      ? Icons.check
                      : Icons.arrow_forward,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
