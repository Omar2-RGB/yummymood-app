// مسار الملف: lib/core/utils/cart_manager.dart

class CartManager {
  // تصميم Singleton لتكون السلة متوفرة بكل الشاشات
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  // قائمة المنتجات في السلة
  final List<Map<String, dynamic>> items = [];

  // إضافة منتج
  void addToCart(Map<String, dynamic> product) {
    items.add(product);
  }

  // حساب المجموع الكلي
  double getTotalPrice() {
    double total = 0;
    for (var item in items) {
      total += double.tryParse(item['price'].toString()) ?? 0.0;
    }
    return total;
  }

  // تفريغ السلة بعد نجاح الطلب
  void clearCart() {
    items.clear();
  }
  // إضافة هذه الدالة داخل كلاس CartManager
  void removeFromCart(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
    }
  }
}