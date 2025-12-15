import 'package:flutter/material.dart';
import '../api/meal.dart';
import '../api/meal_api_service.dart';
import '../app/tried_meals_store.dart';
import 'meal_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

enum MealFilter { all, tried, untried }

class _SearchScreenState extends State<SearchScreen> {
  final MealApiService _api = MealApiService();
  List<Meal> _meals = [];
  bool _loading = false;
  MealFilter _filter = MealFilter.all;

  Future<void> _search(String query) async {
    if (query.isEmpty) return;

    setState(() => _loading = true);
    final result = await _api.searchMeals(query);
    setState(() {
      _meals = result;
      _loading = false;
    });
  }

  List<Meal> _applyFilter(List<Meal> meals) {
    switch (_filter) {
      case MealFilter.tried:
        return meals
            .where((m) => triedMealsStore.isTried(m.id))
            .toList();
      case MealFilter.untried:
        return meals
            .where((m) => !triedMealsStore.isTried(m.id))
            .toList();
      case MealFilter.all:
      default:
        return meals;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: triedMealsStore,
      builder: (context, _) {
        final filteredMeals = _applyFilter(_meals);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Поиск блюд'),
            actions: [
              PopupMenuButton<MealFilter>(
                icon: const Icon(Icons.filter_alt),
                onSelected: (value) {
                  setState(() => _filter = value);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: MealFilter.all,
                    child: Text('Все блюда'),
                  ),
                  PopupMenuItem(
                    value: MealFilter.untried,
                    child: Text('Не пробованные'),
                  ),
                  PopupMenuItem(
                    value: MealFilter.tried,
                    child: Text('Пробованные'),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Введите название блюда',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: _search,
                ),
              ),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredMeals.length,
                  itemBuilder: (context, index) {
                    final meal = filteredMeals[index];
                    final tried = triedMealsStore.isTried(meal.id);

                    return ListTile(
                      leading: Image.network(
                        meal.thumbnail,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                      title: Text(meal.name),
                      subtitle:
                      tried ? const Text('Уже пробовали') : null,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                MealDetailsScreen(mealId: meal.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
