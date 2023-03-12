import 'package:flutter/material.dart';

class NavigationService extends ChangeNotifier {
  static final NavigationService _instance = NavigationService._internal();
  NavigationService._internal();
  factory NavigationService() {
    return _instance;
  }

  String? route;

  void update(String newRoute) {
    route = newRoute;
    notifyListeners();
  }
}
