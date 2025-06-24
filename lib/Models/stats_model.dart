// Wellness Statistics Model
import 'package:saibya_daily/Models/wellness_log_model.dart';

class WellnessStats {
  final double averageSleep;
  final double averageMood;
  final double averageHydration;
  final int totalLogs;
  final int streak;
  final List<WellnessLog> logs;

  WellnessStats({
    required this.averageSleep,
    required this.averageMood,
    required this.averageHydration,
    required this.totalLogs,
    required this.streak,
    required this.logs,
  });

  factory WellnessStats.empty() {
    return WellnessStats(
      averageSleep: 0.0,
      averageMood: 0.0,
      averageHydration: 0.0,
      totalLogs: 0,
      streak: 0,
      logs: [],
    );
  }

  String get sleepSummary {
    if (averageSleep >= 8) return 'Excellent sleep pattern';
    if (averageSleep >= 7) return 'Good sleep pattern';
    if (averageSleep >= 6) return 'Fair sleep pattern';
    return 'Need more sleep';
  }

  String get moodSummary {
    if (averageMood >= 4) return 'Great mood overall';
    if (averageMood >= 3) return 'Stable mood';
    return 'Room for improvement';
  }

  String get hydrationSummary {
    if (averageHydration >= 2.5) return 'Well hydrated';
    if (averageHydration >= 2) return 'Good hydration';
    return 'Drink more water';
  }
}
