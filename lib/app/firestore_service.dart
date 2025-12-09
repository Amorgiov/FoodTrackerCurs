import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserDocument(User user) async {
    final doc = _db.collection('users').doc(user.uid);

    if ((await doc.get()).exists) return;

    await doc.set({
      'email': user.email,
      'username': user.displayName ?? '',
      'dateCreated': FieldValue.serverTimestamp(),
      'triedFoods': [],
      'favoriteCategories': [],
    });
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final snapshot = await _db.collection('users').doc(uid).get();
    return snapshot.data();
  }

  Future<void> updateUsername(String uid, String username) async {
    await _db.collection('users').doc(uid).update({
      'username': username,
    });
  }

  Future<void> addTriedFood(String uid, String food) async {
    await _db.collection('users').doc(uid).update({
      'triedFoods': FieldValue.arrayUnion([food]),
    });
  }

  Future<void> removeTriedFood(String uid, String food) async {
    await _db.collection('users').doc(uid).update({
      'triedFoods': FieldValue.arrayRemove([food]),
    });
  }
}
