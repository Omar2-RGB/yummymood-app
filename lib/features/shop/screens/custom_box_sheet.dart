import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/cart_manager.dart';

class CustomBoxSheet extends StatefulWidget {
  final Map<String, dynamic> product;

  const CustomBoxSheet({super.key, required this.product});

  @override
  State<CustomBoxSheet> createState() => _CustomBoxSheetState();
}

class _CustomBoxSheetState extends State<CustomBoxSheet> {
  // قائمة النكهات
  final List<String> flavors = [
    'بستاشيو',
    'لوتس',
    'شوكولا',
    'شوكولا بيضا',
    'تويكس',
    'أوريو',
    'كراميل',
    'فراولة',
    'كلاسيك'
  ];

  // قاموس لتتبع عدد الحبات المختارة من كل نكهة
  final Map<String, int> selectedFlavors = {};
  int totalSelected = 0;
  final int maxPieces = 3;

  @override
  void initState() {
    super.initState();
    for (var flavor in flavors) {
      selectedFlavors[flavor] = 0;
    }
  }

  void _incrementFlavor(String flavor) {
    if (totalSelected < maxPieces) {
      setState(() {
        selectedFlavors[flavor] = selectedFlavors[flavor]! + 1;
        totalSelected++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لقد اخترت 3 قطع بالفعل! 🍩'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _decrementFlavor(String flavor) {
    if (selectedFlavors[flavor]! > 0) {
      setState(() {
        selectedFlavors[flavor] = selectedFlavors[flavor]! - 1;
        totalSelected--;
      });
    }
  }

  void _addToCart() {
    // تجميع النكهات المختارة في نص واحد
    List<String> chosenDetails = [];
    selectedFlavors.forEach((flavor, count) {
      if (count > 0) {
        chosenDetails.add('$count $flavor');
      }
    });

    final customizedProduct = Map<String, dynamic>.from(widget.product);
    customizedProduct['name'] = '${widget.product['name']} (${chosenDetails.join('، ')})';

    CartManager().addToCart(customizedProduct);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة بوكس السعادة للسلة! 🛒'),
        backgroundColor: AppTheme.strawberryPink,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان وشريط التقدم
            Row(
              children: [
                Expanded(
                  child: Text(
                    'اختر نكهاتك المفضلة (3 قطع)',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.chocolateText,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                  ),
                  child: Text(
                    '$totalSelected / $maxPieces',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: totalSelected == maxPieces
                          ? AppTheme.strawberryPink
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // شريط تقدم بصري
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                widthFactor: totalSelected / maxPieces,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xffFF6B8A), Color(0xffFF3D6B)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // قائمة النكهات
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
                    ),
                    child: ListView.builder(
                      itemCount: flavors.length,
                      itemBuilder: (context, index) {
                        final flavor = flavors[index];
                        final count = selectedFlavors[flavor]!;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  AppTheme.strawberryPink.withOpacity(0.15),
                              child: Icon(
                                Icons.circle,
                                color: AppTheme.strawberryPink,
                                size: 12,
                              ),
                            ),
                            title: Text(
                              flavor,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.chocolateText,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    color: count > 0
                                        ? AppTheme.strawberryPink
                                        : Colors.grey.shade400,
                                  ),
                                  onPressed: () => _decrementFlavor(flavor),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  splashRadius: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$count',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.chocolateText,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    color: totalSelected < maxPieces
                                        ? AppTheme.strawberryPink
                                        : Colors.grey.shade400,
                                  ),
                                  onPressed: totalSelected < maxPieces
                                      ? () => _incrementFlavor(flavor)
                                      : null,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  splashRadius: 20,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // زر الاعتماد
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: totalSelected == maxPieces ? _addToCart : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: totalSelected == maxPieces
                      ? AppTheme.strawberryPink
                      : Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: totalSelected == maxPieces ? 4 : 0,
                  shadowColor: AppTheme.strawberryPink.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      totalSelected == maxPieces
                          ? Icons.check_circle_outline
                          : Icons.lock_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      totalSelected == maxPieces
                          ? 'اعتماد البوكس وإضافته للسلة'
                          : 'اختر 3 نكهات أولاً',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}