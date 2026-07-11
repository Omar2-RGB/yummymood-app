// مسار الملف: lib/features/admin/screens/manage_products_screen.dart

import 'dart:ui'; // لاستخدام ImageFilter
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  // جلب المنتجات لحظياً
  final _productsStream = Supabase.instance.client
      .from('products')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false);

  // دالة لتغيير حالة التوفر (مخفي/ظاهر)
  Future<void> _toggleAvailability(dynamic id, bool currentStatus) async {
    try {
      await Supabase.instance.client
          .from('products')
          .update({'is_available': !currentStatus})
          .eq('id', id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }

  // دالة لحذف المنتج
  Future<void> _deleteProduct(dynamic id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذا المنتج نهائياً؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await Supabase.instance.client.from('products').delete().eq('id', id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حذف المنتج بنجاح 🗑️')),
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
  }

  // دالة لتعديل السعر
  Future<void> _editPrice(dynamic id, String currentPrice, String name) async {
    final TextEditingController priceController = TextEditingController(
      text: currentPrice,
    );

    final newPrice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تعديل سرار ($name)'),
        content: TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'السعر الجديد (ل.س)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, priceController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.strawberryPink,
            ),
            child: const Text('حفظ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (newPrice != null && newPrice.isNotEmpty) {
      try {
        await Supabase.instance.client
            .from('products')
            .update({'price': double.parse(newPrice)})
            .eq('id', id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحديث السعر بنجاح 💰')),
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
              Color(0xffFFE5EC), // وردي فاتح
              Color(0xffFFD8E5),
              Color(0xffFFC3D6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar مخصص
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppTheme.chocolateText,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'إدارة المنتجات 🍩',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.chocolateText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: AppTheme.strawberryPink,
                      radius: 18,
                      child: Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
              // قائمة المنتجات
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _productsStream,
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

                    final products = snapshot.data ?? [];
                    if (products.isEmpty) {
                      return const Center(
                        child: Text(
                          'لا توجد منتجات حالياً.',
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
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final isAvailable = product['is_available'] ?? true;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    // صورة المنتج
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.network(
                                        product['image_url'] ?? '',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey.shade200,
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // تفاصيل المنتج
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              color: AppTheme.chocolateText,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '${product['price']} ل.س',
                                            style: const TextStyle(
                                              color: AppTheme.strawberryPink,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isAvailable
                                                  ? Colors.green.withOpacity(0.15)
                                                  : Colors.grey.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              isAvailable
                                                  ? 'متاح للزبائن ✅'
                                                  : 'مخفي حالياً 🙈',
                                              style: TextStyle(
                                                color: isAvailable
                                                    ? Colors.green.shade700
                                                    : Colors.grey.shade700,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // أزرار التحكم
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                isAvailable
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: isAvailable
                                                    ? AppTheme.strawberryPink
                                                    : Colors.grey,
                                                size: 22,
                                              ),
                                              onPressed: () => _toggleAvailability(
                                                product['id'],
                                                isAvailable,
                                              ),
                                              tooltip: isAvailable
                                                  ? 'إخفاء'
                                                  : 'إظهار',
                                              constraints: const BoxConstraints(),
                                              padding: EdgeInsets.zero,
                                              splashRadius: 20,
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                                size: 22,
                                              ),
                                              onPressed: () => _editPrice(
                                                product['id'],
                                                product['price'].toString(),
                                                product['name'],
                                              ),
                                              tooltip: 'تعديل السعر',
                                              constraints: const BoxConstraints(),
                                              padding: EdgeInsets.zero,
                                              splashRadius: 20,
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                            size: 22,
                                          ),
                                          onPressed: () =>
                                              _deleteProduct(product['id']),
                                          tooltip: 'حذف المنتج',
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                          splashRadius: 20,
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