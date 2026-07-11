// مسار الملف: lib/features/splash/screens/onboarding_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../shop/screens/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "سعادة بنكهة الفخامة",
      "description": "اكتشف تشكيلة استثنائية من الدونات المحضرة يومياً بأجود المكونات لترضي ذوقك الرفيع.",
      "icon": Icons.donut_large_rounded,
      "gradient": [Color(0xffFF6B8A), Color(0xffFF9EB5)],
    },
    {
      "title": "صمم صندوق سعادتك",
      "description": "اختر نكهاتك المفضلة ونسّق بوكس التوفير الخاص بك بخطوات بسيطة وواجهة تفاعلية.",
      "icon": Icons.design_services_rounded,
      "gradient": [Color(0xffFF9EB5), Color(0xffFFC3D6)],
    },
    {
      "title": "توصيل سريع وأنيق",
      "description": "تتبع طلبك لحظة بلحظة حتى يصل الصندوق إلى باب منزلك طازجاً وبأبهى حلة.",
      "icon": Icons.delivery_dining_rounded,
      "gradient": [Color(0xffFFC3D6), Color(0xffFFD8E5)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffFFE5EC),
              Color(0xffFFD8E5),
              Color(0xffFFC3D6),
            ],
          ),
        ),
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                // زر التخطي العلوي
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      ),
                      child: const Text(
                        'تخطي',
                        style: TextStyle(
                          color: AppTheme.chocolateText,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                // محتوى الصفحات
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (value) {
                      setState(() {
                        _currentPage = value;
                      });
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      final data = _onboardingData[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // أيقونة داخل حاوية دائرية مع توهج
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: data["gradient"],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.strawberryPink.withOpacity(0.3),
                                    blurRadius: 50,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Icon(
                                data["icon"],
                                color: Colors.white,
                                size: 80,
                              ),
                            ),
                            const SizedBox(height: 50),
                            // بطاقة زجاجية للنص
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                child: Container(
                                  padding: const EdgeInsets.all(28),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.4),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.pink.withOpacity(0.06),
                                        blurRadius: 30,
                                        offset: const Offset(0, 12),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        data["title"],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.chocolateText,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        data["description"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.chocolateText.withOpacity(0.8),
                                          height: 1.7,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // المؤشر والزر السفلي
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      // نقاط المؤشر
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _onboardingData.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            height: 10,
                            width: _currentPage == index ? 32 : 10,
                            decoration: BoxDecoration(
                              gradient: _currentPage == index
                                  ? const LinearGradient(
                                      colors: [Color(0xffFF6B8A), Color(0xffFF3D6B)],
                                    )
                                  : null,
                              color: _currentPage == index
                                  ? null
                                  : Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: _currentPage == index
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.strawberryPink.withOpacity(0.3),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // زر التنقل
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPage == _onboardingData.length - 1) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                              );
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.strawberryPink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 6,
                            shadowColor: AppTheme.strawberryPink.withOpacity(0.4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentPage == _onboardingData.length - 1
                                    ? 'ابدأ الطلب الآن 🎉'
                                    : 'التالي',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (_currentPage != _onboardingData.length - 1)
                                const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}