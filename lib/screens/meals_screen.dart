import 'package:flutter/material.dart';
import '../api/meal.dart';
import '../api/meal_api_service.dart';
import 'meal_details_screen.dart';

class MealsScreen extends StatefulWidget {
  final String category;

  const MealsScreen({
    super.key,
    required this.category,
  });

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final MealApiService _api = MealApiService();
  late Future<List<Meal>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchMealsByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: FutureBuilder<List<Meal>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Ошибка: ${snapshot.error}'),
            );
          }

          final meals = snapshot.data!;

          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];

              return ListTile(
                leading: Image.network(
                  meal.thumbnail,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
                title: Text(meal.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MealDetailsScreen(
                        mealId: meal.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
