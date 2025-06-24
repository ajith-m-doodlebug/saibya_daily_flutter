// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:saibya_daily/ApiManager/api_manager.dart';
import 'package:saibya_daily/Config/environment.dart';
import 'package:saibya_daily/Models/user_model.dart';
import 'package:saibya_daily/Services/local_storage_service.dart'; // Import local storage service

class AuthData {
  final LocalStorageService _storageService = LocalStorageService.instance;

  /// Helper method to format phone number with +91 prefix
  String _formatPhoneNumber(String phoneNumber) {
    // Remove any existing +91 or 91 prefix to avoid duplication
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'^\+?91'), '');

    // Remove any spaces or special characters
    cleanedNumber = cleanedNumber.replaceAll(RegExp(r'[^0-9]'), '');

    // Add +91 prefix
    return '+91$cleanedNumber';
  }

  /// Request OTP for registration
  Future<bool> requestRegistrationOtp(
    BuildContext context,
    String name,
    String phoneNumber,
  ) async {
    String webLink = '${Environment.apiBaseUrl}/register/request-otp';

    var params = {
      "name": name,
      "phone_number": _formatPhoneNumber(phoneNumber),
    };

    try {
      var data = await ApiManager().callPostApi(webLink, params, '');

      if (data != null && data['message'] != null) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Registration OTP Error: $e');
      return false;
    }
  }

  /// Verify OTP for registration and save JWT token
  Future<bool> verifyRegistrationOtp(
    BuildContext context,
    String phoneNumber,
    String otpCode,
  ) async {
    String webLink = '${Environment.apiBaseUrl}/register/verify-otp';

    var params = {
      "phone_number": _formatPhoneNumber(phoneNumber),
      "otp_code": otpCode,
    };

    try {
      var data = await ApiManager().callPostApi(webLink, params, '');

      if (data != null && data['access_token'] != null) {
        // Save access token only
        _storageService.accessToken = data['access_token'];
        _storageService.isLoggedIn = true; // Set logged in state

        await getCurrentUser(context);

        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Registration Verify Error: $e');
      return false;
    }
  }

  /// Request OTP for login
  Future<bool> requestLoginOtp(
    BuildContext context,
    String phoneNumber,
  ) async {
    String webLink = '${Environment.apiBaseUrl}/login/request-otp';

    var params = {
      "phone_number": _formatPhoneNumber(phoneNumber),
    };

    try {
      var data = await ApiManager().callPostApi(webLink, params, '');

      if (data != null && data['message'] != null) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Login OTP Error: $e');
      return false;
    }
  }

  /// Verify OTP for login and save JWT token
  Future<bool> verifyLoginOtp(
    BuildContext context,
    String phoneNumber,
    String otpCode,
  ) async {
    String webLink = '${Environment.apiBaseUrl}/login/verify-otp';

    var params = {
      "phone_number": _formatPhoneNumber(phoneNumber),
      "otp_code": otpCode,
    };

    try {
      var data = await ApiManager().callPostApi(webLink, params, '');

      if (data != null && data['access_token'] != null) {
        // Save access token only
        _storageService.accessToken = data['access_token'];
        _storageService.isLoggedIn = true; // Set logged in state

        await getCurrentUser(context);

        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Login Verify Error: $e');
      return false;
    }
  }

  /// Resend OTP for existing users
  Future<bool> resendOtp(
    BuildContext context,
    String phoneNumber,
  ) async {
    String webLink = '${Environment.apiBaseUrl}/resend-otp';

    var params = {
      "phone_number": _formatPhoneNumber(phoneNumber),
    };

    try {
      var data = await ApiManager().callPostApi(webLink, params, '');

      if (data != null && data['message'] != null) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Resend OTP Error: $e');
      return false;
    }
  }

  /// Get current user profile
  Future<UserModel?> getCurrentUser(BuildContext context) async {
    String webLink = '${Environment.apiBaseUrl}/me';

    try {
      // Get the access token from storage
      String accessToken = _storageService.accessToken;

      if (accessToken.isEmpty) {
        debugPrint('No access token found');
        return null;
      }

      // Call GET API with authorization header
      var data = await ApiManager().callGetApi(webLink, accessToken);

      if (data != null) {
        // Parse the response and return UserModel
        UserModel user = UserModel.fromJson(data);

        // Save the entire user model to local storage
        _storageService.userData = user;

        return user;
      }
      return null;
    } catch (e) {
      debugPrint('Get Current User Error: $e');
      return null;
    }
  }
}
