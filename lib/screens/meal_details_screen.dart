import 'package:flutter/material.dart';
import '../api/meal_api_service.dart';
import '../api/meal_details.dart';
import '../app/tried_meals_store.dart';

class MealDetailsScreen extends StatefulWidget {
  final String mealId;

  const MealDetailsScreen({
    super.key,
    required this.mealId,
  });

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  final MealApiService _api = MealApiService();
  late Future<MealDetails> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchMealDetails(widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<MealDetails>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          final meal = snapshot.data!;
          final isTried = triedMealsStore.isTried(meal.id);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(meal.thumbnail),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${meal.category} • ${meal.area}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(meal.instructions),
                      const SizedBox(height: 24),

                      ElevatedButton.icon(
                      icon: Icon(isTried ? Icons.check : Icons.restaurant),
                      label: Text(
                      isTried ? 'Вы уже пробовали' : 'Я это пробовал',
                      ),
                      onPressed: isTried
                      ? null
                          : () async {
                      triedMealsStore.markTried(meal.id);
                      setState(() {});
                      },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
