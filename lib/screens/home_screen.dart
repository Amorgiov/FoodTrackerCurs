import 'package:flutter/material.dart';
import 'package:food_tracker/screens/search_screen.dart';
import 'package:provider/provider.dart';
import '../app/auth_service.dart';
import '../auth/profile_screen.dart';
import 'categories_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<AuthService>(
              builder: (context, auth, child) {
                final email = auth.currentUser?.email ?? 'guest';
                return Text('Привет, $email');
              },
            ),
          ),
          const Divider(),
          const Expanded(child: CategoriesScreen()),
        ],
      ),
    );
  }
}
