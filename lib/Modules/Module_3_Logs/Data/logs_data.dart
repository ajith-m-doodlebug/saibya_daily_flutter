// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:saibya_daily/ApiManager/api_manager.dart';
import 'package:saibya_daily/Config/environment.dart';
import 'package:saibya_daily/Models/wellness_log_model.dart';
import 'package:saibya_daily/Services/local_storage_service.dart';

class LogsData {
  final LocalStorageService _storageService = LocalStorageService.instance;

  /// Create a new wellness log
  Future<WellnessLog?> createWellnessLog(
    BuildContext context,
    WellnessLog log,
  ) async {
    String webLink = '${Environment.apiBaseUrl}/logs/';
    String? token = _storageService.accessToken;

    if (token.isEmpty) {
      debugPrint('No access token found');
      return null;
    }

    try {
      var data = await ApiManager().callPostApi(
        webLink,
        log.toCreateJson(),
        token,
      );

      if (data != null) {
        return WellnessLog.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('Create Wellness Log Error: $e');
      return null;
    }
  }

  /// Get wellness logs (default: last 7 days)
  Future<List<WellnessLog>> getWellnessLogs(
    BuildContext context, {
    int days = 7,
  }) async {
    String webLink = '${Environment.apiBaseUrl}/logs';
    String? token = _storageService.accessToken;

    if (token.isEmpty) {
      debugPrint('No access token found');
      return [];
    }

    Map<String, dynamic> queryParams = {
      "days": days,
    };

    try {
      var data = await ApiManager().callGetApi(
        webLink,
        token,
        queryParameters: queryParams,
      );

      if (data != null && data is List) {
        return data.map((log) => WellnessLog.fromJson(log)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Get Wellness Logs Error: $e');
      return [];
    }
  }

  /// Get a single wellness log by ID
  Future<WellnessLog?> getWellnessLogById(
    BuildContext context,
    int logId,
  ) async {
    String webLink = '${Environment.apiBaseUrl}/logs/$logId';
    String? token = _storageService.accessToken;

    if (token.isEmpty) {
      debugPrint('No access token found');
      return null;
    }

    try {
      var data = await ApiManager().callGetApi(webLink, token);

      if (data != null) {
        return WellnessLog.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('Get Wellness Log By ID Error: $e');
      return null;
    }
  }

  /// Update a wellness log
  Future<WellnessLog?> updateWellnessLog(
    BuildContext context,
    int logId, {
    double? sleepHours,
    int? moodRating,
    double? hydrationLiters,
    String? meals,
    String? notes,
  }) async {
    String webLink = '${Environment.apiBaseUrl}/logs/$logId';
    String? token = _storageService.accessToken;

    if (token.isEmpty) {
      debugPrint('No access token found');
      return null;
    }

    // Use the model's toUpdateJson method
    var params = WellnessLog(
      id: logId,
      userId: 0, // Not used in update
      date: '', // Not used in update
      sleepHours: 0, // Not used in update
      moodRating: 0, // Not used in update
      hydrationLiters: 0, // Not used in update
      createdAt: DateTime.now(), // Not used in update
    ).toUpdateJson(
      sleepHours: sleepHours,
      moodRating: moodRating,
      hydrationLiters: hydrationLiters,
      meals: meals,
      notes: notes,
    );

    if (params.isEmpty) {
      debugPrint('No fields to update');
      return null;
    }

    try {
      var data = await ApiManager().callPutApi(webLink, params, token);

      if (data != null) {
        return WellnessLog.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('Update Wellness Log Error: $e');
      return null;
    }
  }

  /// Delete a wellness log
  Future<bool> deleteWellnessLog(
    BuildContext context,
    int logId,
  ) async {
    String webLink = '${Environment.apiBaseUrl}/logs/$logId';
    String? token = _storageService.accessToken;

    if (token.isEmpty) {
      debugPrint('No access token found');
      return false;
    }

    try {
      var data = await ApiManager().callDeleteApi(webLink, token);

      if (data != null && data['message'] != null) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Delete Wellness Log Error: $e');
      return false;
    }
  }

  /// Get today's wellness log
  Future<WellnessLog?> getTodayLog(BuildContext context) async {
    String today = DateTime.now().toIso8601String().split('T')[0];
    List<WellnessLog> logs = await getWellnessLogs(context, days: 1);

    try {
      return logs.firstWhere((log) => log.date == today);
    } catch (e) {
      return null;
    }
  }

  /// Format date for API (YYYY-MM-DD)
  String formatDateForApi(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  /// Parse date from API
  DateTime parseDateFromApi(String dateString) {
    return DateTime.parse(dateString);
  }
}
