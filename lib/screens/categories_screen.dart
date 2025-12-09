import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const List<Map<String, dynamic>> categories = [
    {'name': 'Суши', 'icon': Icons.rice_bowl},
    {'name': 'Бургеры', 'icon': Icons.fastfood},
    {'name': 'Паста', 'icon': Icons.set_meal},
    {'name': 'Пицца', 'icon': Icons.local_pizza},
    {'name': 'Десерты', 'icon': Icons.cake},
    {'name': 'Напитки', 'icon': Icons.local_drink},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return GestureDetector(
          onTap: () {
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(cat['icon'] as IconData, size: 48, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 8),
                Text(cat['name'] as String, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }
}
