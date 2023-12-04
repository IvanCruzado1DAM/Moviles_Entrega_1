import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mindcare/models/elements.dart';

class ElementService extends ChangeNotifier {
  final String baseURL = 'mindcare.allsites.es';
  final storage = const FlutterSecureStorage();
  final List<ElementData> elements = [];

  bool isLoading = true;

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<List<ElementData>> getElements() async {
    final url = Uri.http(baseURL, '/public/api/elements');
    String? token = await readToken();
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
    final Map<String, dynamic> decode = json.decode(resp.body);
    var element = ElementData.fromJson(decode);
    for (var i in element.data!) {
      elements.add(i);
    }
    isLoading = false;
    notifyListeners();
    return elements;
  }
}
