import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _accessible = false;
  int _currentTab = 0;

  bool get isLoggedIn => _isLoggedIn;
  bool get accessible => _accessible;
  int get currentTab => _currentTab;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _currentTab = 0;
    notifyListeners();
  }

  void setTab(int index) {
    if (_currentTab == index) return;
    _currentTab = index;
    notifyListeners();
  }

  void toggleAccessible() {
    _accessible = !_accessible;
    notifyListeners();
  }

  void setAccessible(bool value) {
    if (_accessible == value) return;
    _accessible = value;
    notifyListeners();
  }

  void setLoggedIn(bool value) {
    if (_isLoggedIn == value) return;
    _isLoggedIn = value;
    if (!value) _currentTab = 0;
    notifyListeners();
  }
}
