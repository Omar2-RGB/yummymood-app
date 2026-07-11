// مسار الملف: lib/features/admin/screens/admin_orders_screen.dart

import 'dart:ui'; // ⬅️ هذا السطر مهم جداً لاستخدام ImageFilter
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  // Stream للحصول على الطلبات لحظياً
  final _ordersStream = Supabase.instance.client
      .from('orders')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false);

  // دالة تحديث حالة الطلب
  Future<void> _updateOrderStatus(dynamic orderId, String newStatus) async {
    try {
      await Supabase.instance.client
          .from('orders')
          .update({'status': newStatus})
          .eq('id', orderId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث حالة الطلب! 🚀'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }

  // دالة للحصول على تكوين الحالة (لون وخلفية ونص)
  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status) {
      case 'processing':
        return {
          'label': 'جاري التحضير 👩‍🍳',
          'color': Colors.blue.shade700,
          'bg': Colors.blue.shade50.withOpacity(0.8),
        };
      case 'delivered':
        return {
          'label': 'تم التوصيل ✅',
          'color': Colors.green.shade700,
          'bg': Colors.green.shade50.withOpacity(0.8),
        };
      case 'cancelled':
        return {
          'label': 'ملغي ❌',
          'color': Colors.red.shade700,
          'bg': Colors.red.shade50.withOpacity(0.8),
        };
      case 'pending':
      default:
        return {
          'label': 'قيد الانتظار ⏳',
          'color': Colors.orange.shade800,
          'bg': Colors.orange.shade50.withOpacity(0.8),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // خلفية متدرجة بألوان وردية ناعمة
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffFFE5EC), // وردي فاتح جداً
              Color(0xffFFD8E5),
              Color(0xffFFC3D6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar مخصص (بدون AppBar التقليدي)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.chocolateText),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'إدارة الطلبات الواردة',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.chocolateText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // أيقونة إضافية للتصميم (اختيارية)
                    const CircleAvatar(
                      backgroundColor: AppTheme.strawberryPink,
                      radius: 18,
                      child: Icon(Icons.receipt_long_rounded, color: Colors.white, size: 22),
                    ),
                  ],
                ),
              ),
              // محتوى الطلبات
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _ordersStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.strawberryPink,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'حدث خطأ في تحميل البيانات',
                          style: TextStyle(color: AppTheme.chocolateText),
                        ),
                      );
                    }

                    final orders = snapshot.data ?? [];
                    if (orders.isEmpty) {
                      return const Center(
                        child: Text(
                          'لا توجد طلبات حالياً 📦',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppTheme.chocolateText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final statusConfig = _getStatusConfig(order['status'] ?? 'pending');

                        return Container(
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                            // خلفية شبه شفافة مع تأثير زجاجي خفيف
                            color: Colors.white.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withOpacity(0.1),
                                blurRadius: 25,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // صف الرأس: رقم الطلب والحالة
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.receipt_long_rounded,
                                              color: AppTheme.strawberryPink,
                                              size: 22,
                                            ),
                                            const SizedBox(width: 8),
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
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusConfig['bg'],
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(
                                              color: statusConfig['color'].withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            statusConfig['label'],
                                            style: TextStyle(
                                              color: statusConfig['color'],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),

                                    // تفاصيل الطلب (النكهات)
                                    const Text(
                                      'تفاصيل الطلب:',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: AppTheme.strawberryPink.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: AppTheme.strawberryPink.withOpacity(0.15),
                                        ),
                                      ),
                                      child: Text(
                                        order['order_details'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.chocolateText,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // بيانات العميل
                                    const Text(
                                      'بيانات التوصيل:',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.person_outline,
                                          size: 18,
                                          color: AppTheme.strawberryPink,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            order['customer_name'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.chocolateText,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.phone_outlined,
                                          size: 18,
                                          color: AppTheme.strawberryPink,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            order['customer_phone'] ?? '',
                                            style: const TextStyle(
                                              color: AppTheme.chocolateText,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 18,
                                          color: AppTheme.strawberryPink,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            order['delivery_address'] ?? '',
                                            style: const TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const Divider(
                                      height: 32,
                                      color: Colors.pink,
                                      thickness: 0.5,
                                    ),

                                    // صف السعر وحالة الطلب
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'الإجمالي',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              '${order['total_price']} ل.س',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.strawberryPink,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // قائمة منسدلة لتغيير الحالة
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.7),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: AppTheme.strawberryPink.withOpacity(0.3),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: DropdownButton<String>(
                                              value: order['status'] ?? 'pending',
                                              underline: const SizedBox(),
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                                color: AppTheme.strawberryPink,
                                              ),
                                              style: const TextStyle(
                                                fontFamily: 'Cairo',
                                                color: AppTheme.chocolateText,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                              dropdownColor: Colors.white,
                                              items: const [
                                                DropdownMenuItem(
                                                  value: 'pending',
                                                  child: Text('قيد الانتظار'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'processing',
                                                  child: Text('تحضير'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'delivered',
                                                  child: Text('تم التوصيل'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'cancelled',
                                                  child: Text('إلغاء'),
                                                ),
                                              ],
                                              onChanged: (String? newValue) {
                                                if (newValue != null &&
                                                    newValue != order['status']) {
                                                  _updateOrderStatus(
                                                      order['id'], newValue);
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}