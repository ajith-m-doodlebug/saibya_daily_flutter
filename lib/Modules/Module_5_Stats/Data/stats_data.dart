// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:saibya_daily/ApiManager/api_manager.dart';
import 'package:saibya_daily/Config/environment.dart';
import 'package:saibya_daily/Models/stats_model.dart';
import 'package:saibya_daily/Models/wellness_log_model.dart';
import 'package:saibya_daily/Services/local_storage_service.dart';

class StatsData {
  final LocalStorageService _storageService = LocalStorageService.instance;

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

  /// Get wellness statistics for dashboard
  Future<WellnessStats> getWellnessStats(
    BuildContext context, {
    int days = 7,
  }) async {
    List<WellnessLog> logs = await getWellnessLogs(context, days: days);

    if (logs.isEmpty) {
      return WellnessStats.empty();
    }

    // Calculate averages
    double totalSleep = 0;
    int totalMood = 0;
    double totalHydration = 0;

    for (var log in logs) {
      totalSleep += log.sleepHours;
      totalMood += log.moodRating;
      totalHydration += log.hydrationLiters;
    }

    return WellnessStats(
      averageSleep: totalSleep / logs.length,
      averageMood: (totalMood / logs.length).toDouble(),
      averageHydration: totalHydration / logs.length,
      totalLogs: logs.length,
      streak: _calculateStreak(logs),
      logs: logs,
    );
  }

  /// Calculate consecutive days streak
  int _calculateStreak(List<WellnessLog> logs) {
    if (logs.isEmpty) return 0;

    // Sort logs by date descending
    logs.sort((a, b) => b.date.compareTo(a.date));

    int streak = 1;
    DateTime previousDate = DateTime.parse(logs[0].date);

    for (int i = 1; i < logs.length; i++) {
      DateTime currentDate = DateTime.parse(logs[i].date);
      int dayDifference = previousDate.difference(currentDate).inDays;

      if (dayDifference == 1) {
        streak++;
        previousDate = currentDate;
      } else {
        break;
      }
    }

    return streak;
  }
}
