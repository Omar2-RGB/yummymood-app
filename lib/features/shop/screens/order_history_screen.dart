// مسار الملف: lib/features/shop/screens/order_history_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final TextEditingController _phoneController = TextEditingController();
  List<Map<String, dynamic>> _myOrders = [];
  bool _isLoading = false;
  bool _hasLoaded = false; // لمنع إعادة التحميل المتكرر

  @override
  void initState() {
    super.initState();
    _loadSavedPhone();
  }

  // تحميل الرقم من ذاكرة الجهاز
  Future<void> _loadSavedPhone() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhone = prefs.getString('user_phone');
    if (savedPhone != null && savedPhone.isNotEmpty) {
      _phoneController.text = savedPhone;
      // جلب الطلبات بعد تحميل الرقم (مع تأخير بسيط لتجنب مشاكل التحديث)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchOrders();
      });
    }
  }

  // حفظ الرقم في ذاكرة الجهاز
  Future<void> _savePhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_phone', phone);
  }

  // جلب الطلبات
  Future<void> _fetchOrders() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال رقم الهاتف')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _hasLoaded = false;
    });

    try {
      final data = await Supabase.instance.client
          .from('orders')
          .select()
          .eq('customer_phone', phone)
          .order('created_at', ascending: false);

      setState(() {
        _myOrders = data;
        _isLoading = false;
        _hasLoaded = true;
      });

      // حفظ الرقم بعد نجاح الجلب
      _savePhone(phone);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasLoaded = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
        );
      }
    }
  }

  // تنسيق الحالة
  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status) {
      case 'processing':
        return {'label': 'جاري التحضير', 'color': Colors.blue.shade700};
      case 'delivered':
        return {'label': 'تم التوصيل', 'color': Colors.green.shade700};
      case 'cancelled':
        return {'label': 'ملغي', 'color': Colors.red.shade700};
      case 'pending':
      default:
        return {'label': 'قيد الانتظار', 'color': Colors.orange.shade800};
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
                          'سجل طلباتي',
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
                          Icons.history,
                          color: AppTheme.strawberryPink,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                // المحتوى
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // حالة البحث الأولي (لم يتم البحث بعد)
    if (!_hasLoaded && !_isLoading && _phoneController.text.isEmpty) {
      return _buildSearchView();
    }

    // حالة التحميل
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.strawberryPink),
      );
    }

    // حالة عدم وجود طلبات
    if (_myOrders.isEmpty && _hasLoaded) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 70,
                color: AppTheme.strawberryPink,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'لا توجد طلبات سابقة',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.chocolateText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'يمكنك البحث برقم هاتف آخر',
              style: TextStyle(
                color: AppTheme.chocolateText.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _hasLoaded = false;
                  _phoneController.clear();
                });
              },
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text('بحث جديد'),
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

    // عرض قائمة الطلبات
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _myOrders.length,
      itemBuilder: (context, index) {
        final order = _myOrders[index];
        final statusConfig = _getStatusConfig(order['status'] ?? 'pending');
        final orderId = order['id'].toString();
        final shortId = orderId.length > 4 ? orderId.substring(0, 4) : orderId;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // صف الرأس: رقم الطلب + الحالة
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
                              '#$shortId',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppTheme.chocolateText,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusConfig['color'].withOpacity(0.15),
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
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // تفاصيل الطلب
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.strawberryPink.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppTheme.strawberryPink.withOpacity(0.15),
                        ),
                      ),
                      child: Text(
                        order['order_details'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.chocolateText,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // بيانات العميل (مختصرة)
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 16,
                          color: AppTheme.strawberryPink,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            order['customer_name'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.chocolateText,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.phone_outlined,
                          size: 16,
                          color: AppTheme.strawberryPink,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          order['customer_phone'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.chocolateText,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    // السعر والتاريخ
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
                        if (order['created_at'] != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  _formatDate(order['created_at']),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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
  }

  // واجهة البحث الأولية
  Widget _buildSearchView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
              ),
              child: const Icon(
                Icons.search,
                size: 70,
                color: AppTheme.strawberryPink,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'ابحث عن طلباتك',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.chocolateText,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'أدخل رقم هاتفك لعرض جميع طلباتك السابقة',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.chocolateText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // حقل الإدخال
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'رقم الهاتف',
                prefixIcon: const Icon(Icons.phone, color: AppTheme.strawberryPink),
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
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _fetchOrders,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.strawberryPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 4,
                  shadowColor: AppTheme.strawberryPink.withOpacity(0.3),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'عرض طلباتي',
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
    );
  }

  // دالة تنسيق التاريخ
  String _formatDate(dynamic dateTime) {
    if (dateTime == null) return '';
    try {
      final DateTime dt = DateTime.parse(dateTime.toString());
      final String day = dt.day.toString().padLeft(2, '0');
      final String month = dt.month.toString().padLeft(2, '0');
      final String year = dt.year.toString();
      return '$day/$month/$year';
    } catch (e) {
      return '';
    }
  }
}