import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApiService {
  final String projectId;

  UserApiService({
    required this.projectId,
  });

  Future<void> addTriedMeal({
    required String uid,
    required String mealId,
    required String mealName,
    required String category,
  }) async {
    final url = Uri.parse(
      'https://console.firebase.google.com/u/0/project/'
          '$projectId/firestore/databases/-default-/data/'
    );

    final body = {
      "fields": {
        "lastAction": {
          "stringValue": "add_tried_meal"
        },
        "meal": {
          "mapValue": {
            "fields": {
              "id": {"stringValue": mealId},
              "name": {"stringValue": mealName},
              "category": {"stringValue": category}
            }
          }
        },
        "timestamp": {
          "timestampValue": DateTime.now().toUtc().toIso8601String()
        }
      }
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw Exception('Failed to POST tried meal');
    }
  }
}
