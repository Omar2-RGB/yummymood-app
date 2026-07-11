// lib/features/shop/screens/product_detail_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/cart_manager.dart';
import 'custom_box_sheet.dart';        // ✅ استيراد مكون البوكس المخصص
import 'add_review_dialog.dart';        // ✅ استيراد نافذة إضافة التقييم

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;
  double _averageRating = 0.0;
  int _reviewCount = 0;

  Future<void> _fetchReviews() async {
    try {
      final response = await Supabase.instance.client
          .from('reviews')
          .select()
          .eq('product_id', widget.product['id'])
          .order('created_at', ascending: false);

      setState(() {
        _reviews = List<Map<String, dynamic>>.from(response);
        _reviewCount = _reviews.length;
        if (_reviewCount > 0) {
          final total = _reviews.fold(0, (sum, r) => sum + (r['rating'] as int));
          _averageRating = total / _reviewCount;
        } else {
          _averageRating = 0.0;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تحميل التقييمات: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final double price = double.tryParse(product['price'].toString()) ?? 0.0;

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
            child: CustomScrollView(
              slivers: [
                // SliverAppBar
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          product['image_url'] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.4),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      product['name'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(offset: Offset(0, 2), blurRadius: 6, color: Colors.black45)],
                      ),
                    ),
                    centerTitle: true,
                  ),
                ),
                // المحتوى
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // السعر وزر الإضافة
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'السعر',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                  Text(
                                    '${price.toStringAsFixed(0)} ل.س',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.strawberryPink,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  if (product['name'].toString().contains('3')) {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.7,
                                        child: CustomBoxSheet(product: product),
                                      ),
                                    ).then((value) => setState(() {}));
                                  } else {
                                    CartManager().addToCart(product);
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('تمت إضافة ${product['name']} إلى السلة! 🛒'),
                                        backgroundColor: AppTheme.strawberryPink,
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.add_shopping_cart, size: 20),
                                label: const Text('أضف للسلة'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.strawberryPink,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // متوسط التقييم
                        if (!_isLoading)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.4)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 28),
                                const SizedBox(width: 8),
                                Text(
                                  _reviewCount > 0
                                      ? '${_averageRating.toStringAsFixed(1)} ★ ($_reviewCount تقييم)'
                                      : 'لا توجد تقييمات بعد',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.chocolateText,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: _showAddReviewDialog,
                                  icon: const Icon(Icons.add_comment_rounded, color: AppTheme.strawberryPink),
                                  tooltip: 'أضف تقييمك',
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),
                        const Text(
                          'التقييمات والتعليقات',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.chocolateText,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(color: AppTheme.strawberryPink),
                            ),
                          )
                        else if (_reviews.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'لا توجد تعليقات حتى الآن. كن أول من يقيم!',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _reviews.length,
                            itemBuilder: (context, index) {
                              final review = _reviews[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withOpacity(0.4)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: AppTheme.strawberryPink.withOpacity(0.2),
                                          child: Text(
                                            (review['customer_name'] ?? 'ز').substring(0, 1),
                                            style: const TextStyle(
                                              color: AppTheme.strawberryPink,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          review['customer_name'] ?? 'زائر',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppTheme.chocolateText,
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: List.generate(5, (i) {
                                            final rating = review['rating'] ?? 0;
                                            return Icon(
                                              i < rating ? Icons.star : Icons.star_border,
                                              color: Colors.amber,
                                              size: 18,
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (review['comment'] != null && review['comment'].isNotEmpty)
                                      Text(
                                        review['comment'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: AppTheme.chocolateText,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 30),
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

  // دالة عرض نافذة إضافة التقييم
  void _showAddReviewDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: AddReviewDialog(
          productId: widget.product['id'],
          onReviewAdded: () => _fetchReviews(),
        ),
      ),
    );
  }
}