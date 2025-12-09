import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'firestore_service.dart';

final FirestoreService firestoreService = FirestoreService();

class AuthService extends ChangeNotifier {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  AuthService() {
    authStateChanges.listen((_) {
      notifyListeners();
    });
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final res = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    notifyListeners();
    return res;
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    final res = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    await firestoreService.createUserDocument(res.user!);

    notifyListeners();
    return res;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    notifyListeners();
  }

  Future<void> resetPassword({
    required String email
  }) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({
    required String username
  }) async {
    if (currentUser != null){
      await currentUser!.updateDisplayName(username);
      await currentUser!.reload();
      
      await firestoreService.updateUsername(currentUser!.uid, username);
      
      notifyListeners();
    }
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider
        .credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider
        .credential(email: email, password: currentPassword);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }
}