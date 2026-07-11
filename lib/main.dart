import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/screens/splash_screen.dart'; // استيراد شاشة التحميل السينمائية

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://ewremzsdkzhxldtjlqod.supabase.co', 
    anonKey: 'sb_publishable_6EWqd_RSZyOrhluIrJmU3A_PBQrANVN', 
  );
  
  runApp(const YummyMoodApp());
}

class YummyMoodApp extends StatelessWidget {
  const YummyMoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YummyMood',
      debugShowCheckedModeBanner: false,
      
      // إعدادات الثيم الاحترافية
      theme: AppTheme.lightTheme, // الثيم النهاري الفاتح
      darkTheme: AppTheme.darkTheme, // الثيم الليلي الداكن والفخم
      themeMode: ThemeMode.system, // التطبيق سيتبع إعدادات جهاز الزبون تلقائياً
      
      // الانطلاق من شاشة التحميل الفخمة بدلاً من الرئيسية مباشرة
      home: const SplashScreen(), 
    );
  }
}