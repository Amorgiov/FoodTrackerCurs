import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: user == null
            ? const Center(child: Text('Пользователь не найден'))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${user.email}'),
            const SizedBox(height: 8),
            Text('Имя: ${user.displayName ?? '-'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await auth.signOut();
              },
              child: const Text('Выйти'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final ctrl = TextEditingController();
                final res = await showDialog<String?>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Обновить имя'),
                    content: TextField(controller: ctrl),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(c, null),
                          child: const Text('Отмена')),
                      TextButton(
                          onPressed: () =>
                              Navigator.pop(c, ctrl.text.trim()),
                          child: const Text('ОК')),
                    ],
                  ),
                );
                if (res != null && res.isNotEmpty) {
                  await auth.updateUsername(username: res);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Имя обновлено')));
                }
              },
              child: const Text('Обновить имя'),
            ),
          ],
        ),
      ),
    );
  }
}
