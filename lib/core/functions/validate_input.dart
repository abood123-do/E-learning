import 'package:flutter/material.dart';

class Validate {
  final BuildContext context;
  Validate({required this.context});

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter yor password';
    }

    if (value.length < 4) {
      return 'Too short password ';
    }
    return null;
  }
  String? validateConfirmPassword(String? value, String originalPassword) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password';
  } else if (value != originalPassword) {
    return 'Passwords do not match';
  }
  return null; // Return null if validation passes
}

//   String? confirmPassword(String? password, String? confirmPassword) {
//   if (confirmPassword == null || confirmPassword.isEmpty) {
//     return 'Please confirm your password';
//   }

//   if (password != confirmPassword) {
//     return 'Passwords do not match';
//   }

//   return null;
// }


  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'invalid phone number';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the user name';
    }
    if (value.length < 4) {
      return 'The user name must be 4 characters at least';
    }
    return null;
  }
   String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }
    final numberRegex = RegExp(r'^\d+$'); 
    if (!numberRegex.hasMatch(value)) {
      return 'Only numbers are allowed';
    }
    return null;
  }
}
