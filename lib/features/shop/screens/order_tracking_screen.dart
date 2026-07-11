// مسار الملف: lib/features/shop/screens/order_tracking_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';

class OrderTrackingScreen extends StatefulWidget {
  final dynamic orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late final Stream<List<Map<String, dynamic>>> _orderStream;

  @override
  void initState() {
    super.initState();
    _orderStream = Supabase.instance.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('id', widget.orderId)
        .limit(1);
  }

  // تحديد المرحلة الحالية للطلب بناءً على الحالة
  int _getCurrentStep(String status) {
    switch (status) {
      case 'processing':
        return 1;
      case 'delivered':
        return 3;
      case 'cancelled':
        return -1;
      case 'pending':
      default:
        return 0;
    }
  }

  // بناء خطوة التتبع
  Widget _buildTrackStep({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isCompleted,
    required bool isCurrent,
    bool showLine = true,
  }) {
    final color = isCurrent
        ? AppTheme.strawberryPink
        : (isCompleted ? AppTheme.chocolateText : Colors.grey.shade300);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl, // مهم لترتيب الأيقونة والنص بشكل صحيح
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCurrent ? AppTheme.strawberryPink.withOpacity(0.12) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: isCurrent ? 2.5 : 2),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            if (showLine)
              Container(
                width: 2,
                height: 50,
                color: isCompleted ? AppTheme.chocolateText : Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isCurrent ? AppTheme.strawberryPink : AppTheme.chocolateText,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ],
    );
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
                          'تتبع حالة الطلب',
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
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _orderStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: AppTheme.strawberryPink),
                        );
                      }
                      if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 60, color: Colors.grey.shade400),
                              const SizedBox(height: 16),
                              const Text(
                                'عذراً، لم نتمكن من العثور على بيانات الطلب.',
                                style: TextStyle(fontSize: 18, color: AppTheme.chocolateText),
                              ),
                            ],
                          ),
                        );
                      }

                      final order = snapshot.data!.first;
                      final String status = order['status'] ?? 'pending';
                      final int currentStep = _getCurrentStep(status);

                      if (status == 'cancelled') {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.red.shade400, width: 2),
                                ),
                                child: Icon(Icons.cancel_outlined, size: 70, color: Colors.red.shade400),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'تم إلغاء هذا الطلب من قبل الإدارة',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.chocolateText),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                label: const Text('العودة للمتجر'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.strawberryPink,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // عرض التتبع مع البطاقات الزجاجية
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // بطاقة معلومات الطلب
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pink.withOpacity(0.08),
                                    blurRadius: 25,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.receipt_long_rounded, color: AppTheme.strawberryPink, size: 20),
                                              const SizedBox(width: 6),
                                              Text(
                                                '#${order['id'].toString().substring(0, 4)}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: AppTheme.chocolateText,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.55),
                                            child: Text(
                                              order['order_details'] ?? '',
                                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppTheme.strawberryPink.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(
                                            color: AppTheme.strawberryPink.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          '${order['total_price']} ل.س',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.strawberryPink,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // خط التتبع الزمني (Timeline) داخل بطاقة زجاجية
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pink.withOpacity(0.08),
                                    blurRadius: 25,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                  child: Column(
                                    children: [
                                      _buildTrackStep(
                                        title: 'تم استلام الطلب ⏳',
                                        subtitle: 'طلبك الآن قيد الانتظار للمراجعة من قبل فريقنا.',
                                        icon: Icons.access_time,
                                        isCompleted: currentStep >= 0,
                                        isCurrent: currentStep == 0,
                                      ),
                                      _buildTrackStep(
                                        title: 'جاري التحضير 👩‍🍳',
                                        subtitle: 'نقوم الآن بتحضير وتزيين الدونات الطازجة الخاصة بك بكل حب.',
                                        icon: Icons.soup_kitchen_outlined,
                                        isCompleted: currentStep >= 1,
                                        isCurrent: currentStep == 1,
                                      ),
                                      _buildTrackStep(
                                        title: 'في الطريق إليك 🛵',
                                        subtitle: 'خرج الكابتن لتوصيل صندوق السعادة إلى عنوانك المحدد.',
                                        icon: Icons.delivery_dining_outlined,
                                        isCompleted: currentStep >= 2,
                                        isCurrent: currentStep == 2,
                                        showLine: true,
                                      ),
                                      _buildTrackStep(
                                        title: 'تم التوصيل بنجاح 🎉',
                                        subtitle: 'نتمنى أن نكون قد صنعنا لك السعادة! بالهناء والشفاء دائمًا.',
                                        icon: Icons.celebration_outlined,
                                        isCompleted: currentStep == 3,
                                        isCurrent: currentStep == 3,
                                        showLine: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // زر العودة للتصفح
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                label: const Text('العودة للتصفح', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.strawberryPink,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 4,
                                  shadowColor: AppTheme.strawberryPink.withOpacity(0.3),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
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