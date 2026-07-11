// lib/features/shop/screens/developer_profile_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';

class DeveloperProfileScreen extends StatelessWidget {
  const DeveloperProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B0C0F),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 0.8,
            colors: [
              Color(0xff1A1D24),
              Color(0xff111318),
              Color(0xff0B0C0F),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: CustomScrollView(
              slivers: [
                // ============================================================
                //  SliverAppBar – ارتفاع أقل لتجنب التجاوز
                // ============================================================
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: true,
                  expandedHeight: 320, // تم التخفيض من 380 إلى 320
                  leading: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        // دوائر ضوئية خلفية
                        Positioned(
                          top: -100,
                          right: -80,
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.strawberryPink.withOpacity(0.08),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.strawberryPink.withOpacity(0.25),
                                  blurRadius: 120,
                                  spreadRadius: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -120,
                          left: -100,
                          child: Container(
                            width: 350,
                            height: 350,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withOpacity(0.05),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.15),
                                  blurRadius: 150,
                                  spreadRadius: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // الصورة الشخصية مع توهج متعدد الطبقات (مصغرة قليلاً)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  // حلقة توهج خارجية
                                  Container(
                                    width: 170,
                                    height: 170,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          AppTheme.strawberryPink.withOpacity(0.5),
                                          Colors.purple.withOpacity(0.2),
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.strawberryPink.withOpacity(0.4),
                                          blurRadius: 50,
                                          spreadRadius: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // حلقة داخلية
                                  Container(
                                    width: 155,
                                    height: 155,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.12),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  // الصورة الفعلية
                                  ClipOval(
                                    child: Container(
                                      width: 140,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Image.asset(
                                        'assets/images/omar.jpg',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stack) => Container(
                                          color: Colors.grey[800],
                                          child: const Icon(Icons.person, size: 70, color: Colors.white54),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Eng. Omar Shaalan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  shadows: [
                                    Shadow(offset: Offset(0, 2), blurRadius: 10, color: Colors.black45),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  'Software Engineer',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.strawberryPink.withOpacity(0.25),
                                      AppTheme.strawberryPink.withOpacity(0.05),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: AppTheme.strawberryPink.withOpacity(0.4),
                                    width: 1.2,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star, color: AppTheme.strawberryPink, size: 14),
                                    SizedBox(width: 6),
                                    Text(
                                      'Founder & CEO • Nexor',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ============================================================
                //  المحتوى الرئيسي – مع مسافات محسنة لتجنب التجاوز
                // ============================================================
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        // ------ نبذة عن المطور ------
                        _glassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppTheme.strawberryPink,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'نبذة',
                                    style: TextStyle(
                                      color: AppTheme.strawberryPink,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'أنا عمر شعلان عبد العزيز، مهندس برمجيات متخصص في تطوير تطبيقات Flutter وتصميم واجهات المستخدم الحديثة. أركز على بناء تطبيقات تتميز بالأداء العالي، والتصميم الأنيق، وتجربة استخدام احترافية. هدفي هو تحويل الأفكار إلى منتجات رقمية متكاملة ذات جودة عالية.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  height: 1.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ------ بطاقات الإحصائيات (4 بطاقات) ------
                        Row(
                          children: [
                            Expanded(child: _statCard(Icons.code_rounded, '20+', 'مشاريع', Colors.blue)),
                            const SizedBox(width: 12),
                            Expanded(child: _statCard(Icons.workspace_premium_rounded, '5+', 'سنوات', Colors.purple)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _statCard(Icons.phone_android_rounded, 'Flutter', 'خبير', Colors.green)),
                            const SizedBox(width: 12),
                            Expanded(child: _statCard(Icons.rocket_launch_rounded, '100%', 'شغف', Colors.orange)),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // ------ التقنيات ------
                        _glassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppTheme.strawberryPink,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'التقنيات',
                                    style: TextStyle(
                                      color: AppTheme.strawberryPink,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: const [
                                  _TechChip(label: 'Flutter'),
                                  _TechChip(label: 'Dart'),
                                  _TechChip(label: 'Firebase'),
                                  _TechChip(label: 'Supabase'),
                                  _TechChip(label: 'REST API'),
                                  _TechChip(label: 'SQL Server'),
                                  _TechChip(label: 'Next.js'),
                                  _TechChip(label: 'TypeScript'),
                                  _TechChip(label: 'Node.js'),
                                  _TechChip(label: 'Git'),
                                  _TechChip(label: 'UI/UX'),
                                  _TechChip(label: 'Clean Architecture'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ------ الخبرات ------
                        _glassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppTheme.strawberryPink,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'الخبرات',
                                    style: TextStyle(
                                      color: AppTheme.strawberryPink,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _ExperienceTile(
                                icon: Icons.check_circle,
                                title: 'تطوير Flutter',
                                subtitle: 'تطوير تطبيقات Android و iOS عالية الأداء.',
                              ),
                              const Divider(color: Colors.white10, height: 12),
                              _ExperienceTile(
                                icon: Icons.design_services,
                                title: 'تصميم واجهات',
                                subtitle: 'تصميم واجهات حديثة وفاخرة وتجربة مستخدم احترافية.',
                              ),
                              const Divider(color: Colors.white10, height: 12),
                              _ExperienceTile(
                                icon: Icons.cloud_done,
                                title: 'تكامل الخلفية',
                                subtitle: 'ربط التطبيقات مع Firebase وSupabase وREST APIs.',
                              ),
                              const Divider(color: Colors.white10, height: 12),
                              _ExperienceTile(
                                icon: Icons.speed,
                                title: 'تحسين الأداء',
                                subtitle: 'تحسين الأداء وتقليل استهلاك الموارد.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ------ نبذة عن Nexor ------
                        _glassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppTheme.strawberryPink,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'نبذة عن Nexor',
                                    style: TextStyle(
                                      color: AppTheme.strawberryPink,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Nexor هي علامة متخصصة في تطوير التطبيقات الحديثة، وتصميم الأنظمة الرقمية، وبناء حلول برمجية تجمع بين السرعة، والأمان، والتصميم الراقي، مع التركيز على تقديم تجربة مستخدم استثنائية.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  height: 1.8,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ------ تواصل معي ------
                        _glassCard(
                          child: Column(
                            children: [
                              const Text(
                                'تواصل معي',
                                style: TextStyle(
                                  color: AppTheme.strawberryPink,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                alignment: WrapAlignment.center,
                                children: [
                                  _socialButton(
                                    icon: Icons.code,
                                    label: 'GitHub',
                                    url: 'https://github.com/Omar2-RGB',
                                  ),
                                  _socialButton(
                                    icon: Icons.camera_alt,
                                    label: 'Instagram',
                                    url:
                                        'https://www.instagram.com/eng._omar_abdulaziz?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==',
                                  ),
                                  _socialButton(
                                    icon: Icons.email,
                                    label: 'Email',
                                    url: 'mailto:oaziz5951@gmail.com',
                                  ),
                                  _socialButton(
                                    icon: Icons.phone,
                                    label: 'WhatsApp',
                                    url: 'https://wa.me/963995339401',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ------ تذييل أنيق (مصغر) ------
                        const Divider(color: Colors.white12, thickness: 0.5),
                        const SizedBox(height: 16),
                        const Text(
                          'صمم وطور بواسطة',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 13,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Eng. Omar Shaalan',
                          style: TextStyle(
                            color: AppTheme.strawberryPink,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Founder & CEO • Nexor',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Powered by Nexor © 2026',
                          style: TextStyle(
                            color: Colors.white24,
                            fontSize: 11,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 30), // مسافة سفلية كافية لتجنب التجاوز
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
  //  بطاقة زجاجية فاخرة
  // ==============================================================
  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  // ==============================================================
  //  بطاقة إحصائية ملونة (مصغرة)
  // ==============================================================
  Widget _statCard(IconData icon, String value, String title, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 26),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  //  زر تواصل (مصغر)
  // ==============================================================
  Widget _socialButton({
    required IconData icon,
    required String label,
    required String url,
  }) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.strawberryPink, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==============================================================
//  مكونات مساعدة
// ==============================================================

class _TechChip extends StatelessWidget {
  final String label;
  const _TechChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.strawberryPink.withOpacity(0.15),
            AppTheme.strawberryPink.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppTheme.strawberryPink.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.85),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ExperienceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ExperienceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppTheme.strawberryPink.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.strawberryPink, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    height: 1.5,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}