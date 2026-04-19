import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages authentication state across the app.
///
/// This is a mocked auth provider — replace internal logic with
/// real API calls when the backend is ready.
class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Mocked user data
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';

  // ─── Getters ─────────────────────────────────────────────────────
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;

  // ─── Initialization ──────────────────────────────────────────────
  /// Check persisted login state on app start.
  Future<void> checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userName = prefs.getString('userName') ?? '';
    _userEmail = prefs.getString('userEmail') ?? '';
    _userPhone = prefs.getString('userPhone') ?? '';
    notifyListeners();
  }

  // ─── Login ───────────────────────────────────────────────────────
  /// Mocked login. Accepts any credentials for now.
  Future<bool> login({
    required String emailOrPhone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock validation
    if (emailOrPhone.isEmpty || password.isEmpty) {
      _errorMessage = 'يرجى ملء جميع الحقول';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'كلمة المرور قصيرة جداً';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Mock successful login
    _isLoggedIn = true;
    _userName = 'أحمد';
    _userEmail = emailOrPhone.contains('@') ? emailOrPhone : '';
    _userPhone = emailOrPhone.contains('@') ? '' : emailOrPhone;
    _isLoading = false;

    await _persistLoginState();
    notifyListeners();
    return true;
  }

  // ─── Signup ──────────────────────────────────────────────────────
  Future<bool> signup({
    required String fullName,
    required String emailOrPhone,
    required String password,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    if (fullName.isEmpty || emailOrPhone.isEmpty || password.isEmpty) {
      _errorMessage = 'يرجى ملء جميع الحقول';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      _errorMessage = 'كلمات المرور غير متطابقة';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Mock successful signup
    _isLoggedIn = true;
    _userName = fullName;
    _userEmail = emailOrPhone.contains('@') ? emailOrPhone : '';
    _userPhone = emailOrPhone.contains('@') ? '' : emailOrPhone;
    _isLoading = false;

    await _persistLoginState();
    notifyListeners();
    return true;
  }

  // ─── Forgot Password ────────────────────────────────────────────
  Future<bool> requestPasswordReset(String emailOrPhone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    if (emailOrPhone.isEmpty) {
      _errorMessage = 'يرجى إدخال البريد الإلكتروني أو رقم الهاتف';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> verifyCode(String code) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (code.length != 6) {
      _errorMessage = 'رمز التحقق غير صحيح';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> resetPassword(String newPassword, String confirmPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (newPassword != confirmPassword) {
      _errorMessage = 'كلمات المرور غير متطابقة';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // ─── Logout ──────────────────────────────────────────────────────
  Future<void> logout() async {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    _userPhone = '';

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  // ─── Persistence ─────────────────────────────────────────────────
  Future<void> _persistLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', _isLoggedIn);
    await prefs.setString('userName', _userName);
    await prefs.setString('userEmail', _userEmail);
    await prefs.setString('userPhone', _userPhone);
  }

  /// Clear any displayed error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
