import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetailsProvider with ChangeNotifier {
  Map<String, dynamic>? _userDetails;
  List<dynamic>? _userProjects;
  String? _userEmail;

  Map<String, dynamic>? get userDetails => _userDetails;
  List<dynamic>? get userProjects => _userProjects;
  String? get userEmail => _userEmail;

  void setUserDetails(Map<String, dynamic> user) {
    _userDetails = user;
    notifyListeners();

    fetchProjectsAndEmail(user['login']);
  }

  Future<void> fetchProjectsAndEmail(String username) async {
    final projectsResult = await http
        .get(Uri.parse("https://api.github.com/users/$username/repos"));
    _userProjects = jsonDecode(projectsResult.body);

    final userDetailsResult =
        await http.get(Uri.parse("https://api.github.com/users/$username"));
    final userDetailsData = jsonDecode(userDetailsResult.body);

    if (userDetailsData.containsKey('email')) {
      _userEmail = userDetailsData['email'];
    } else {
      _userEmail = "Email not available";
    }

    if (userDetailsData.containsKey('bio')) {
      if (_userDetails == null) {
        _userDetails = {};
      }
      _userDetails!['bio'] = userDetailsData['bio'];
    } else {
      if (_userDetails == null) {
        _userDetails = {};
      }
    }

    notifyListeners();
  }
}
