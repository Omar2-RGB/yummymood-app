// مسار الملف: lib/features/shop/screens/order_tracking_screen.dart

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/theme/app_theme.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  // بيانات وهمية للطلب (يمكن استبدالها ببيانات حقيقية من Supabase لاحقاً)
  final Map<String, dynamic> _orderData = {
    'id': '1234',
    'details': 'بستاشيو + لوتس + شوكولا',
    'total': '45000',
    'status': 'processing',
  };

  Future<void> _shareOrderOnInstagram() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/my_yummymood_order.png').create();
        await imagePath.writeAsBytes(image);

        await Share.shareXFiles(
          [XFile(imagePath.path)],
          text: 'طلبنا السعادة من YummyMood! 🍩✨ شوفوا النكهات الرهيبة اللي اخترتها!',
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ أثناء المشاركة: $e')),
          );
        }
      }
    }
  }

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
                // AppBar مخصص
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xffFF6B8A),
                        Color(0xffFF9EB5),
                      ],
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'تتبع طلبك',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [Shadow(offset: Offset(0, 2), blurRadius: 6, color: Colors.black26)],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: Icon(
                          Icons.delivery_dining,
                          color: AppTheme.strawberryPink,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                // المحتوى
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // بطاقة الطلب (التي سيتم تصويرها)
                        Screenshot(
                          controller: _screenshotController,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xff2D1B2E),
                                  Color(0xff1E1E1E),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: AppTheme.strawberryPink.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.strawberryPink.withOpacity(0.15),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // أيقونة الدونات مع توهج
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppTheme.strawberryPink.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppTheme.strawberryPink.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.donut_large_rounded,
                                    color: AppTheme.strawberryPink,
                                    size: 50,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'بوكس السعادة الخاص بك',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'تم تحضيره بحب.. في الطريق إليك!',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                const Divider(color: Colors.white12, thickness: 0.5),
                                const SizedBox(height: 16),
                                // تفاصيل الطلب
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'رقم الطلب',
                                      style: TextStyle(color: Colors.white54, fontSize: 14),
                                    ),
                                    Text(
                                      '#${_orderData['id']}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'النكهات',
                                      style: TextStyle(color: Colors.white54, fontSize: 14),
                                    ),
                                    Text(
                                      _orderData['details'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'الإجمالي',
                                      style: TextStyle(color: Colors.white54, fontSize: 14),
                                    ),
                                    Text(
                                      '${_orderData['total']} ل.س',
                                      style: const TextStyle(
                                        color: AppTheme.strawberryPink,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.strawberryPink.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: AppTheme.strawberryPink.withOpacity(0.3),
                                    ),
                                  ),
                                  child: const Text(
                                    'قيد التحضير 👩‍🍳',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // شعار التطبيق
                                const Text(
                                  'YummyMood 🍩',
                                  style: TextStyle(
                                    color: AppTheme.strawberryPink,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // زر المشاركة الفخم
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton.icon(
                            onPressed: _shareOrderOnInstagram,
                            icon: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 26),
                            label: const Text(
                              'شارك طلبك على إنستغرام 📸',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE1306C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 6,
                              shadowColor: const Color(0xFFE1306C).withOpacity(0.4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // زر العودة للتصفح
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back, color: AppTheme.strawberryPink),
                            label: const Text(
                              'العودة للتصفح',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.strawberryPink,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppTheme.strawberryPink.withOpacity(0.4), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
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