// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:saibya_daily/ApiManager/api_manager.dart';
import 'package:saibya_daily/Config/environment.dart';
import 'package:saibya_daily/Models/health_tip_model.dart';
import 'package:saibya_daily/Services/local_storage_service.dart';

class HealthTipData {
  final LocalStorageService _storageService = LocalStorageService.instance;

  late String token = _storageService.accessToken;

  /// Get a health tip
  Future<HealthTipModel?> getHealthTip(BuildContext context) async {
    String webLink = '${Environment.apiBaseUrl}/tip';

    if (token.isEmpty) {
      debugPrint('No access token found');
      return null;
    }

    try {
      var data = await ApiManager().callGetApi(webLink, token);

      if (data != null) {
        return HealthTipModel.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('Get Health Tip Error: $e');
      return null;
    }
  }
}
