import 'package:flutter/material.dart';

mixin AuthValidationMixin<T extends StatefulWidget> on State<T> {
  /// Attaches listeners to controllers to trigger a rebuild on every keystroke.
  void setupValidation(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      controller.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  /// Validates username: at least 3 characters, alphanumeric only.
  bool isUsernameValid(String username) {
    final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
    return username
        .trim()
        .length >= 3 && alphanumeric.hasMatch(username.trim());
  }

  /// Validates password: at least 6 characters.
  bool isPasswordValid(String password) {
    return password.length >= 6;
  }

  /// Validates email format
  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email.trim());
  }
}