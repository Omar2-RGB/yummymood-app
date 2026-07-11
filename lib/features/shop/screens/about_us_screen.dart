// lib/features/shop/screens/about_us_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
            textDirection: TextDirection.rtl, // 🔥 ضبط الاتجاه العام للصفحة
            child: CustomScrollView(
              slivers: [
                // ========================================================
                //  SliverAppBar بتصميم عصري
                // ========================================================
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: const Text(
                      "عن YummyMood",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                        shadows: [
                          Shadow(offset: Offset(0, 2), blurRadius: 6, color: Colors.black26),
                        ],
                      ),
                      textDirection: TextDirection.rtl, // 🔥
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // التدرج الرئيسي
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xffFF6B8A),
                                Color(0xffFF9EB5),
                                Color(0xffFFC3D6),
                                Color(0xffFFE5EC),
                              ],
                            ),
                          ),
                        ),
                        // دوائر زجاجية زخرفية
                        Positioned(
                          top: -80,
                          left: -60,
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -100,
                          right: -70,
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 50,
                          right: 20,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        // الشعار بدون خلفية دائرية
                        const Center(
                          child: ClipOval(
                            child: SizedBox(
                              width: 130,
                              height: 130,
                              child: Image(
                                image: AssetImage('assets/images/logo.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ========================================================
                //  المحتوى الرئيسي
                // ========================================================
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      textDirection: TextDirection.rtl, // 🔥
                      children: [
                        // ----- بطاقة النص الرئيسية (Glassmorphism) -----
                        _glassCard(
                          child: Column(
                            textDirection: TextDirection.rtl, // 🔥
                            children: const [
                              Text(
                                "YummyMood",
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.chocolateText,
                                  letterSpacing: 1.2,
                                ),
                                textDirection: TextDirection.rtl, // 🔥
                              ),
                              SizedBox(height: 12),
                              Text(
                                "نحن لا نصنع الدونات فقط...\nنحن نصنع لحظات جميلة تستحق أن تُشارك.\nكل قطعة تُحضّر بعناية، باستخدام مكونات طازجة وجودة عالية لنمنحك تجربة لا تُنسى.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  height: 1.9,
                                  color: AppTheme.chocolateText,
                                  fontWeight: FontWeight.w400,
                                ),
                                textDirection: TextDirection.rtl, // 🔥
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ----- بطاقات الإحصائيات -----
                        Row(
                          textDirection: TextDirection.rtl, // 🔥
                          children: [
                            Expanded(child: _statCard(Icons.favorite, "100%", "مصنوع بحب")),
                            const SizedBox(width: 15),
                            Expanded(child: _statCard(Icons.star, "⭐", "جودة عالية")),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          textDirection: TextDirection.rtl, // 🔥
                          children: [
                            Expanded(child: _statCard(Icons.local_shipping, "سريع", "توصيل")),
                            const SizedBox(width: 15),
                            Expanded(child: _statCard(Icons.restaurant, "طازج", "يومياً")),
                          ],
                        ),

                        const SizedBox(height: 35),

                        // ----- معلومات إضافية -----
                        _infoTile(
                          Icons.location_on,
                          "📍 العنوان",
                          "صيدا - درعا",
                        ),
                        const SizedBox(height: 15),
                        _infoTile(
                          Icons.access_time_filled,
                          "🕒 ساعات العمل",
                          "من 3 عصراً حتى 10 ليلاً",
                        ),
                        const SizedBox(height: 15),
                        _infoTile(
                          Icons.phone,
                          "📞 خدمة العملاء",
                          "جاهزون لخدمتكم دائماً",
                        ),

                        const SizedBox(height: 35),

                        // ----- شريط تقدير متدرج -----
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xffFF6B8A), Color(0xffFF3D6B)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xffFF6B8A).withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Row(
                            textDirection: TextDirection.rtl, // 🔥
                            children: [
                              Icon(Icons.favorite, color: Colors.white, size: 28),
                              SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  "شكراً لأنكم جزء من عائلة YummyMood ❤️",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    shadows: [Shadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.black26)],
                                  ),
                                  textDirection: TextDirection.rtl, // 🔥
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),
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

  // ==============================================================
  //  بطاقة شفافة (Glassmorphism)
  // ==============================================================
  static Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  // ==============================================================
  //  بطاقة إحصائية بتصميم عصري (خلفية وردية شفافة)
  // ==============================================================
  static Widget _statCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppTheme.strawberryPink.withOpacity(0.2),
            child: Icon(icon, color: AppTheme.strawberryPink, size: 30),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.chocolateText,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppTheme.chocolateText,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  // ==============================================================
  //  بطاقة معلومات مع أيقونة (Glassmorphism)
  // ==============================================================
  static Widget _infoTile(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppTheme.strawberryPink.withOpacity(0.2),
            child: Icon(icon, color: AppTheme.strawberryPink, size: 26),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppTheme.chocolateText,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}