import 'package:flutter/foundation.dart';

class TriedMealsStore extends ChangeNotifier {
  final Set<String> _triedMealIds = {};

  bool isTried(String mealId) => _triedMealIds.contains(mealId);

  void markTried(String mealId) {
    _triedMealIds.add(mealId);
    notifyListeners();
  }

  Set<String> get triedMealIds => _triedMealIds;
}

final TriedMealsStore triedMealsStore = TriedMealsStore();
