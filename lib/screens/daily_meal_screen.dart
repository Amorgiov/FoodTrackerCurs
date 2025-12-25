import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/meal_api_service.dart';
import '../app/firestore_service.dart';
import 'meal_details_screen.dart';

class DailyMealScreen extends StatefulWidget {
  const DailyMealScreen({super.key});

  @override
  State<DailyMealScreen> createState() => _DailyMealScreenState();
}

class _DailyMealScreenState extends State<DailyMealScreen> {
  final _firestore = FirestoreService();
  final _api = MealApiService();
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  Map<String, dynamic>? _meal;

  @override
  void initState() {
    super.initState();
    _loadDailyMeal();
  }

  Future<void> _loadDailyMeal() async {
    final stored = await _firestore.getDailyMeal(_uid);
    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (stored != null && stored['date'] == today) {
      setState(() => _meal = stored);
      return;
    }

    final meals = await _api.fetchMealsByCategory('Chicken');
    final randomMeal = meals[Random().nextInt(meals.length)];

    final daily = {
      'date': today,
      'mealId': randomMeal.id,
      'name': randomMeal.name,
      'thumbnail': randomMeal.thumbnail,
    };

    await _firestore.setDailyMeal(_uid, daily);
    setState(() => _meal = daily);
  }

  @override
  Widget build(BuildContext context) {
    if (_meal == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Блюдо дня')),
      body: Column(
        children: [
          Image.network(_meal!['thumbnail']),
          const SizedBox(height: 16),
          Text(
            _meal!['name'],
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          ElevatedButton(
            child: const Text('Открыть рецепт'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MealDetailsScreen(mealId: _meal!['mealId']),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
