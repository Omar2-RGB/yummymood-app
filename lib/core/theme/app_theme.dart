import 'package:flutter/material.dart';

class AppTheme {
  // ألوان البراند الأساسية
  static const Color strawberryPink = Color(0xFFFF4081); // زهري نيون مبهج
  static const Color chocolateText = Color(0xFF3E2723);
  static const Color softGray = Color(0xFFF5F5F5);
  static const Color creamyWhite = Color(0xFFFFFDD0);

  // --- الثيم الفاتح (النهاري) ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: strawberryPink,
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    fontFamily: 'Cairo', // تأكد من إضافة خط Cairo إذا أردت
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: chocolateText,
      iconTheme: IconThemeData(color: strawberryPink),
    ),
    colorScheme: const ColorScheme.light(
      primary: strawberryPink,
      secondary: strawberryPink,
      surface: Colors.white,
    ),
    cardColor: Colors.white,
  );

  // --- الثيم الداكن (الليلي الفخم) ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: strawberryPink,
    scaffoldBackgroundColor: const Color(0xFF121212), // أسود سينمائي عميق
    fontFamily: 'Cairo',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white, // النص أبيض في الوضع الداكن
      iconTheme: IconThemeData(color: strawberryPink),
    ),
    colorScheme: const ColorScheme.dark(
      primary: strawberryPink,
      secondary: strawberryPink,
      surface: Color(0xFF1E1E1E), // رمادي داكن للبطاقات (Cards) ليعطي عمقاً
      onSurface: Colors.white,
    ),
    cardColor: const Color(0xFF1E1E1E), // لون الكروت في الوضع الداكن
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF1E1E1E),
    ),
  );
}