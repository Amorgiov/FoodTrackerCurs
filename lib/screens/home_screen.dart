import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/auth_service.dart';
import '../auth/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final email = auth.currentUser?.email ?? 'guest';

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
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Привет, $email'),
          ),
          const Divider(),
          Expanded(child: CategoriesScreen()),
        ],
      ),
    );
  }
}
