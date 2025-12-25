import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserDocument(User user) async {
    final doc = _db.collection('users').doc(user.uid);

    await doc.set({
      'email': user.email,
      'username': user.displayName ?? '',
      'dateCreated': FieldValue.serverTimestamp(),
      'triedFoods': [],
      'favoriteCategories': [],
      'favoriteMeals': []
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

  /* -------------------- FAVORITES -------------------- */

  Future<List<Map<String, dynamic>>> getFavoriteMeals(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return List<Map<String, dynamic>>.from(
      doc.data()?['favoriteMeals'] ?? [],
    );
  }

  Future<bool> isFavorite(String uid, String mealId) async {
    final favorites = await getFavoriteMeals(uid);
    return favorites.any((m) => m['mealId'] == mealId);
  }

  Future<void> addFavorite(String uid, Map<String, dynamic> meal) async {
    await ensureUserDocument(uid);

    await _db.collection('users').doc(uid).set({
      'favoriteMeals': FieldValue.arrayUnion([meal]),
    }, SetOptions(merge: true));
  }


  Future<void> removeFavorite(String uid, String mealId) async {
    final docRef = _db.collection('users').doc(uid);
    final doc = await docRef.get();
    final data = doc.data();

    if (data == null) return;

    final List favorites = List.from(data['favoriteMeals'] ?? []);
    favorites.removeWhere((m) => m['mealId'] == mealId);

    await docRef.update({'favoriteMeals': favorites});
  }

  /* -------------------- DAILY MEAL -------------------- */

  Future<Map<String, dynamic>?> getDailyMeal(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['dailyMeal'];
  }

  Future<void> setDailyMeal(String uid, Map<String, dynamic> meal) async {
    await ensureUserDocument(uid);

    await _db.collection('users').doc(uid).set({
      'dailyMeal': meal,
    }, SetOptions(merge: true));
  }


  /* -------------------- RECENT MEALS -------------------- */

  Future<void> addRecentMeal(String uid, Map<String, dynamic> meal) async {
    await ensureUserDocument(uid);

    final docRef = _db.collection('users').doc(uid);
    final doc = await docRef.get();

    List recent = List.from(doc.data()?['recentMeals'] ?? []);

    recent.removeWhere((m) => m['mealId'] == meal['mealId']);
    recent.insert(0, meal);

    if (recent.length > 15) {
      recent = recent.sublist(0, 15);
    }

    await docRef.set({'recentMeals': recent}, SetOptions(merge: true));
  }


  Future<List<Map<String, dynamic>>> getRecentMeals(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return List<Map<String, dynamic>>.from(
      doc.data()?['recentMeals'] ?? [],
    );
  }

  Future<void> ensureUserDocument(String uid) async {
    final docRef = _db.collection('users').doc(uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'favoriteMeals': [],
        'recentMeals': [],
        'triedFoods': [],
        'favoriteCategories': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
