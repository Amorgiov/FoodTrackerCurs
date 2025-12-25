import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:provider/provider.dart';
import '../app/firestore_service.dart';
import '../screens/home_screen.dart';
import '../app/auth_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider()
            ],
            showAuthActionSwitch: true,

            actions: [
              AuthStateChangeAction<SignedIn>((context, state) async {
                final uid = FirebaseAuth.instance.currentUser!.uid;
                await FirestoreService().ensureUserDocument(uid);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              }),

              AuthStateChangeAction<UserCreated>((context, state) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              }),
            ],
          );
        }

        return const HomeScreen();
      },
    );
  }
}
