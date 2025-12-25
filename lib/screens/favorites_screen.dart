import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app/firestore_service.dart';
import 'meal_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final _firestore = FirestoreService();
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Избранные блюда')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _firestore.getFavoriteMeals(_uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final meals = snapshot.data!;
          if (meals.isEmpty) {
            return const Center(child: Text('Избранное пусто'));
          }

          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              return ListTile(
                leading: Image.network(meal['thumbnail']),
                title: Text(meal['name']),
                subtitle: Text(meal['category']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MealDetailsScreen(mealId: meal['mealId']),
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
