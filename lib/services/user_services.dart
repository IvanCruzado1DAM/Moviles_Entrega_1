import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mindcare/models/users.dart';

class UserService extends ChangeNotifier {
  final String baseURL = 'mindcare.allsites.es';
  final storage = const FlutterSecureStorage();
  static String userEmail = '';
  static String userId = '';
  static String userType = '';
  bool isLoading = true;
  final List<UserData> users = [];
  String user = '';
  static String currentUserEmail = "";

  Future register(
    String name,
    String email,
    String password,
    String cpassword,
  ) async {
    final Map<String, dynamic> authData = {
      'name': name,
      'email': email,
      'password': password,
      'c_password': cpassword,
    };

    final url = Uri.http(baseURL, '/public/api/register', {});

    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Some token",
        },
        body: json.encode(authData));

    final Map<String, dynamic> decoded = json.decode(response.body);

    if (decoded['success'] == true) {
      await storage.write(key: 'token', value: decoded['data']['token']);
      await storage.write(
          key: 'name', value: decoded['data']['name'].toString());
    } else {}
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.http(baseURL, '/public/api/login', {});

    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Some token",
        },
        body: json.encode(authData));

    final Map<String, dynamic> decoded = json.decode(response.body);

    if (decoded['success'] == true) {
      UserService.userId = decoded['data']['id'].toString();
      UserService.userEmail = email;

      // Guardar el valor de "tipo" en UserService
      UserService.userType = decoded['data']['type'];

      await storage.write(key: 'token', value: decoded['data']['token']);
      await storage.write(key: 'id', value: decoded['data']['id'].toString());
      return 'success';
    } else {
      if (decoded['data'] != null &&
          decoded['data']['error'] == "Email don't confirmed") {
        return 'Email not confirmed';
      } else if (decoded['data'] != null &&
          decoded['data']['error'] == "User don't activated") {
        return 'User not activated';
      } else {
        return decoded['message'];
      }
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'id');
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<String> readId() async {
    return await storage.read(key: 'id') ?? '';
  }

  Future<List<UserData>> getUsers() async {
    final url = Uri.http(baseURL, '/public/api/users');
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
    var user = Users.fromJson(decode);
    for (var i in user.data!) {
      users.add(i);
    }
    isLoading = false;
    notifyListeners();
    return users;
  }

//Revisar método getUser para optimizar y verle uso.

  Future<UserData> getUser(String id) async {
    String? token = await readToken();

    final url = Uri.http(baseURL, '/user/$id');
    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    final Map<String, dynamic> decode = json.decode(resp.body);
    UserData user = UserData.fromJson(decode['data']);
    isLoading = false;
    notifyListeners();
    return user;
  }

  Future postActivate(String id) async {
    final url = Uri.http(baseURL, '/public/api/activate', {'id': '$id'});
    String? token = await readToken();
    isLoading = true;
    notifyListeners();
    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp['success'] == true) {
      print("Delete successful");
      return 'success'; // Aquí se retorna 'success' si la desactivación fue exitosa.
    } else {
      print("Delete failed: ${decodeResp['message']}");
      return decodeResp[
          'message']; // Se retorna el mensaje si la desactivación falla.
    }
  }

  Future postDeactivate(String id) async {
    final url = Uri.http(baseURL, '/public/api/deactivate', {'id': '$id'});
    String? token = await readToken();
    isLoading = true;
    notifyListeners();
    final resp = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp['success'] == true) {
      print("Delete successful");
      return 'success'; // Aquí se retorna 'success' si la desactivación fue exitosa.
    } else {
      print("Delete failed: ${decodeResp['message']}");
      return decodeResp[
          'message']; // Se retorna el mensaje si la desactivación falla.
    }
  }

  Future postDeleteUser(String id) async {
    final url = Uri.http(baseURL, '/public/api/deleteUser', {'id': '$id'});
    String? token = await readToken();
    isLoading = true;
    notifyListeners();
    final resp = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    if (decodeResp['success'] == true) {
      print("Delete successful");
    } else {
      print("Delete failed: ${decodeResp['message']}");
    }
  }

  Future postUpdateUser(
    String id,
    String name,
  ) async {
    final Map<String, dynamic> updateData = {
      'id': id,
      'name': name,
    };
    final url = Uri.http(baseURL, '/public/api/updateUser', {'id': '$id'});
    String? token = await readToken();
    isLoading = true;
    notifyListeners();
    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: json.encode(updateData));
    final Map<String, dynamic> decoded = json.decode(response.body);

    if (response.statusCode == 200) {
      print('success');
    } else {
      print('error');
      print(decoded.toString());
    }
  }

  static void setCurrentUserEmail(String email) {
    currentUserEmail = email;
  }
}
