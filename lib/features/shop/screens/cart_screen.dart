// مسار الملف: lib/features/shop/screens/cart_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/cart_manager.dart';
import 'order_tracking_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = false;

  // دالة إرسال الطلب
  Future<void> _submitOrder() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء تعبئة جميع بيانات التوصيل 🛵'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (CartManager().items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('السلة فارغة!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String details = CartManager().items.map((e) => e['name']).join(' + ');

      final response = await Supabase.instance.client.from('orders').insert({
        'customer_name': _nameController.text,
        'customer_phone': _phoneController.text,
        'delivery_address': _addressController.text,
        'total_price': CartManager().getTotalPrice(),
        'order_details': details,
        'status': 'pending',
      }).select().single();

      if (mounted) {
        CartManager().clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم استلام طلبك بنجاح! السعادة في طريقها إليك 🍩'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderTrackingScreen(orderId: response['id']),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // تصميم موحد لحقول الإدخال (شفاف مع حدود وردية)
  InputDecoration _customInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, color: AppTheme.strawberryPink, size: 22),
      filled: true,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppTheme.strawberryPink, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = CartManager().items;
    final total = CartManager().getTotalPrice();

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
            child: cartItems.isEmpty
                ? Column(
                    children: [
                      // إضافة زر الرجوع في حالة السلة الفارغة
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.chocolateText),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Expanded(
                              child: Text(
                                'سلة المشتريات',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.chocolateText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 48), // للحفاظ على التناسق
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                                ),
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 80,
                                  color: AppTheme.strawberryPink.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'سلتك تنتظر السعادة!',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.chocolateText,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'أضف بعض الدونات اللذيذة للبدء',
                                style: TextStyle(
                                  color: AppTheme.chocolateText,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      // AppBar مخصص مع زر رجوع واضح
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.chocolateText),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Expanded(
                              child: Text(
                                'سلة المشتريات',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.chocolateText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: AppTheme.strawberryPink,
                              radius: 18,
                              child: Text(
                                '${cartItems.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // قائمة المنتجات
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: cartItems.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
                              ),
                              onDismissed: (direction) {
                                setState(() {
                                  CartManager().removeFromCart(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('تم حذف ${item['name']} من السلة'),
                                    backgroundColor: Colors.red.shade300,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.pink.withOpacity(0.06),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.strawberryPink.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(Icons.donut_small, color: AppTheme.strawberryPink, size: 30),
                                  ),
                                  title: Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: AppTheme.chocolateText,
                                    ),
                                  ),
                                  trailing: Text(
                                    '${item['price']} ل.س',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: AppTheme.strawberryPink,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // الجزء السفلي (إجمالي + نموذج الطلب)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.08),
                              blurRadius: 25,
                              offset: const Offset(0, -8),
                            ),
                          ],
                        ),
                        child: SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // إجمالي السلة
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'المجموع الإجمالي:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppTheme.chocolateText,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${total.toStringAsFixed(0)} ل.س',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.strawberryPink,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // حقول الإدخال
                              TextField(
                                controller: _nameController,
                                decoration: _customInputDecoration('الاسم الكريم', Icons.person_outline),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: _customInputDecoration('رقم الهاتف للتواصل', Icons.phone_outlined),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _addressController,
                                maxLines: 2,
                                decoration: _customInputDecoration('العنوان التفصيلي', Icons.location_on_outlined),
                              ),
                              const SizedBox(height: 24),
                              // زر تأكيد الطلب
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _submitOrder,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.strawberryPink,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    elevation: 4,
                                    shadowColor: AppTheme.strawberryPink.withOpacity(0.3),
                                  ),
                                  child: _isLoading
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.check_circle_outline, color: Colors.white),
                                            SizedBox(width: 12),
                                            Text(
                                              'تأكيد الطلب الآن',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
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