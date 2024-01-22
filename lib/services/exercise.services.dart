import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mindcare/models/elements.dart';
import 'package:mindcare/models/exercises.dart';
import 'package:mindcare/services/user_services.dart';

class ExerciseService extends ChangeNotifier {
  final List<ExerciseData> exercises = [];
  final List<String> exerciseImageURLs = [];
  final String baseURL = 'mindcare.allsites.es';
  final storage = const FlutterSecureStorage();
  bool isLoading = true;

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

// AQUI HABRA DUDAS
  Future<List<ExerciseData>> getExercises() async {
    final String userId = UserService.userId;
    final String token = await readToken();

    final Uri url = Uri.https(baseURL, '/public/api/exercises');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    if (decodedData['success'] == true) {
      for (var data in decodedData['data']) {
        // print('WHAT HAPPEN $data');
        String imageUrl = data['image'] ?? '';

        ExerciseData elementData = ExerciseData(
          id: data['id'],
          name: data['name'],
          improvement: data['improvement'],
          type: data['type'],
          explanation: data['explanation'],
          image: data['image'],
          audio: data['audio'],
          video: data['video'],
        );
        exercises.add(elementData);
        exerciseImageURLs.add(imageUrl);
      }
    }
    isLoading = false;
    notifyListeners();
    return exercises;
  }

  Future<List<String>> getExerciseImageURLs() async {
    return exerciseImageURLs;
  }

  Future<ExerciseData> getExerciseById(int id) async {
    final url = Uri.http(baseURL, '/public/api/exerciseById', {'id': '$id'});
    String? token = await readToken();
    final resp = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    ExerciseData exercise = ExerciseData.fromJson(decodedData['data']);
    return exercise;
  }

  Future<Map<String, dynamic>> newExerciseMade(
      int user_id, int exercise_id) async {
    final Uri url = Uri.https(baseURL, '/public/api/newExerciseMade',
        {'user_id': '$user_id', 'exercise_id': '$exercise_id'});
    String token = await readToken();

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'user_id': user_id.toString(),
        'exercise_id': exercise_id.toString(),
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData;
    } else {
      print('Error response status code: ${response.statusCode}');
      throw Exception('${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> exercisesByAlum(int id) async {
    final String token = await readToken();
    final Uri url =
        Uri.http(baseURL, '/public/api/exercisesByAlum', {'id': '$id'});

    isLoading = true;
    notifyListeners();

    final http.Response resp = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (resp.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(resp.body);

      if (jsonResponse['success'] == true) {
        final List<dynamic> data = jsonResponse['data'];
        List<Map<String, dynamic>> exercises = [];

        for (var exerciseData in data) {
          exercises.add({
            'id': exerciseData['id'],
          });
        }

        return exercises;
      } else {
        throw Exception('Failed to retrieve exercises: ${jsonResponse['message']}');
      }
    } else {
      print('Error response status code: ${resp.statusCode}');
      throw Exception('${resp.statusCode}');
    }
  }
}
