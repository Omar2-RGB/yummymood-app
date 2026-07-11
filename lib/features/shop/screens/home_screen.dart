// مسار الملف: lib/features/shop/screens/home_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/cart_manager.dart';
import '../../admin/screens/add_product_screen.dart';
import 'cart_screen.dart';
import 'custom_box_sheet.dart';
import 'order_tracking_screen.dart';
import 'order_history_screen.dart';
import 'about_us_screen.dart';
import 'developer_profile_screen.dart';
import 'product_detail_screen.dart'; // ✅ استيراد شاشة تفاصيل المنتج

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<List<Map<String, dynamic>>> _productsFuture =
      Supabase.instance.client.from('products').select().eq('is_available', true);

  Map<String, dynamic>? _activeOrder;

  @override
  void initState() {
    super.initState();
    _checkActiveOrder();
  }

  Future<void> _checkActiveOrder() async {
    final response = await Supabase.instance.client
        .from('orders')
        .select()
        .neq('status', 'delivered')
        .neq('status', 'cancelled')
        .order('created_at', ascending: false)
        .maybeSingle();

    if (mounted) {
      setState(() {
        _activeOrder = response;
      });
    }
  }

  Future<void> _launchWhatsApp() async {
    final Uri url = Uri.parse('https://wa.me/963931636751');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح الواتساب، تأكد من تثبيت التطبيق.')),
        );
      }
    }
  }

  Future<void> _launchInstagram() async {
    final Uri url = Uri.parse('https://www.instagram.com/yummymood_sy?igsh=aHR4Y3o1a3U0ZWVs');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _showAdminPasswordDialog(BuildContext context) {
    final TextEditingController passController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("قسم الإدارة"),
        content: TextField(
          controller: passController,
          obscureText: true,
          decoration: const InputDecoration(hintText: "أدخل كلمة السر"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          ElevatedButton(
            onPressed: () {
              if (passController.text == "ymyymood2026") {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProductScreen()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("كلمة سر خاطئة!")));
              }
            },
            child: const Text("دخول"),
          ),
        ],
      ),
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
                // ----- AppBar مخصص -----
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
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'YummyMood 🍩',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [Shadow(offset: Offset(0, 2), blurRadius: 6, color: Colors.black26)],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 28),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()))
                                  .then((value) => setState(() {}));
                            },
                          ),
                          if (CartManager().items.isNotEmpty)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                                child: Text(
                                  '${CartManager().items.length}',
                                  style: const TextStyle(
                                    color: AppTheme.strawberryPink,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ----- المحتوى الرئيسي -----
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      // شريط التتبع
                      if (_activeOrder != null)
                        SliverToBoxAdapter(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderTrackingScreen(orderId: _activeOrder!['id']),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              decoration: BoxDecoration(
                                color: AppTheme.chocolateText,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 15,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.delivery_dining, color: AppTheme.strawberryPink, size: 30),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'طلبك الحالي قيد التحضير 🛵',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'رقم الطلب: #${_activeOrder!['id'].toString().substring(0, 4)}',
                                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // قائمة المنتجات
                      SliverToBoxAdapter(
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: _productsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(40),
                                  child: CircularProgressIndicator(color: AppTheme.strawberryPink),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Text(
                                    'حدث خطأ أثناء تحميل المنتجات',
                                    style: TextStyle(color: AppTheme.chocolateText),
                                  ),
                                ),
                              );
                            }
                            final products = snapshot.data ?? [];
                            if (products.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(40),
                                  child: Text(
                                    'لا توجد منتجات متوفرة حالياً',
                                    style: TextStyle(fontSize: 18, color: AppTheme.chocolateText),
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(16),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                final double price = double.tryParse(product['price'].toString()) ?? 0.0;

                                return _buildProductCard(product, price);
                              },
                            );
                          },
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 30)),
                    ],
                  ),
                ),

                // ----- FloatingActionButton للسلة -----
                if (CartManager().items.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CartScreen()),
                          ).then((value) => setState(() {}));
                        },
                        backgroundColor: AppTheme.strawberryPink,
                        elevation: 8,
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 26),
                            Positioned(
                              right: -6,
                              top: -6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppTheme.chocolateText,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                                child: Text(
                                  '${CartManager().items.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        label: const Text(
                          'عرض السلة',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),

      // ===== DRAWER =====
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 50, 24, 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffFF6B8A),
                    Color(0xffFF9EB5),
                    Color(0xffFFC3D6),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'YummyMood',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(offset: Offset(0, 2), blurRadius: 6, color: Colors.black26)],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'نصنع لك السعادة 🍩',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      shadows: [Shadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.black12)],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 12),
                  _buildDrawerTile(
                    icon: Icons.home,
                    label: 'الرئيسية',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerTile(
                    icon: Icons.history,
                    label: 'سجل طلباتي',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryScreen()));
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.support_agent,
                    label: 'تواصل معنا',
                    onTap: () {
                      Navigator.pop(context);
                      _launchWhatsApp();
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.camera_alt,
                    label: 'تابعنا على انستغرام',
                    onTap: () {
                      Navigator.pop(context);
                      _launchInstagram();
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.info_outline,
                    label: 'عن YummyMood',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsScreen()));
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.developer_mode,
                    label: 'عن المبرمج',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DeveloperProfileScreen()));
                    },
                  ),
                  _buildDrawerTile(
                    icon: Icons.admin_panel_settings,
                    label: 'قسم الإدارة',
                    onTap: () {
                      Navigator.pop(context);
                      _showAdminPasswordDialog(context);
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  //  بطاقة المنتج – قابلة للنقر لفتح التفاصيل
  // ============================================================
  Widget _buildProductCard(Map<String, dynamic> product, double price) {
    return GestureDetector(
      onTap: () {
        // ✅ عند النقر على البطاقة، ننتقل لشاشة التفاصيل
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
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
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المنتج
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(
                    product['image_url'] ?? '',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported_outlined, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
                // تفاصيل المنتج
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.chocolateText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${price.toStringAsFixed(0)} ل.س',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.strawberryPink,
                            ),
                          ),
                          // زر الإضافة للسلة – يعمل بشكل مستقل عن النقر على البطاقة
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
                            icon: const Icon(Icons.add_shopping_cart, size: 18),
                            label: const Text('أضف للسلة'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.strawberryPink,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ],
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

  // ============================================================
  //  عنصر Drawer
  // ============================================================
  Widget _buildDrawerTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.strawberryPink, size: 26),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xff3D2C2A),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}