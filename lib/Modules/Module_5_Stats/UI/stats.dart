import 'package:flutter/material.dart';
import 'package:saibya_daily/Utils/colors.dart';
import 'package:saibya_daily/Models/stats_model.dart';
import '../Data/stats_data.dart'; // Adjust path as needed

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  final StatsData _homeData = StatsData();
  WellnessStats? _stats;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final stats = await _homeData.getWellnessStats(context, days: 7);

      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load stats: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    EdgeInsets? margin,
  }) {
    return Expanded(
      child: Container(
        height: 150,
        margin: margin ?? EdgeInsets.zero,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.secondary, width: 1),
        ),
        child: Stack(
          children: [
            // Icon in top right
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                icon,
                color: AppColors.secondary,
                size: 20,
              ),
            ),
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatSleepDuration(double hours) {
    int h = hours.floor();
    int m = ((hours - h) * 60).round();
    return '${h}h ${m}m';
  }

  Widget _buildLoadingCard({EdgeInsets? margin}) {
    return Expanded(
      child: Container(
        height: 150,
        margin: margin ?? EdgeInsets.zero,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.secondary, width: 1),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorCard({EdgeInsets? margin}) {
    return Expanded(
      child: Container(
        height: 150,
        margin: margin ?? EdgeInsets.zero,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 24),
            const SizedBox(height: 8),
            Text(
              'Error loading data',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: _loadStats,
              child: Text(
                'Tap to retry',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.blue.shade600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              // Streak Card
              if (_isLoading)
                _buildLoadingCard(
                  margin: const EdgeInsets.only(right: 8, bottom: 12),
                )
              else if (_error != null)
                _buildErrorCard(
                  margin: const EdgeInsets.only(right: 8, bottom: 12),
                )
              else
                _buildStatCard(
                  title: 'Streak',
                  value: '${_stats?.streak ?? 0} days',
                  subtitle: 'Current streak',
                  icon: Icons.local_fire_department,
                  margin: const EdgeInsets.only(right: 8, bottom: 12),
                ),

              // Mood Card
              if (_isLoading)
                _buildLoadingCard(
                  margin: const EdgeInsets.only(left: 8, bottom: 12),
                )
              else if (_error != null)
                _buildErrorCard(
                  margin: const EdgeInsets.only(left: 8, bottom: 12),
                )
              else
                _buildStatCard(
                  title: 'Mood',
                  value: '${(_stats?.averageMood ?? 0).toStringAsFixed(1)}/5',
                  subtitle: 'Avg this week',
                  icon: Icons.mood,
                  margin: const EdgeInsets.only(left: 8, bottom: 12),
                ),
            ],
          ),
          Row(
            children: [
              // Water Card
              if (_isLoading)
                _buildLoadingCard(
                  margin: const EdgeInsets.only(right: 8),
                )
              else if (_error != null)
                _buildErrorCard(
                  margin: const EdgeInsets.only(right: 8),
                )
              else
                _buildStatCard(
                  title: 'Water',
                  value:
                      '${(_stats?.averageHydration ?? 0).toStringAsFixed(1)}L',
                  subtitle: 'Avg this week',
                  icon: Icons.water_drop,
                  margin: const EdgeInsets.only(right: 8),
                ),

              // Sleep Card
              if (_isLoading)
                _buildLoadingCard(
                  margin: const EdgeInsets.only(left: 8),
                )
              else if (_error != null)
                _buildErrorCard(
                  margin: const EdgeInsets.only(left: 8),
                )
              else
                _buildStatCard(
                  title: 'Sleep',
                  value: _formatSleepDuration(_stats?.averageSleep ?? 0),
                  subtitle: 'Avg this week',
                  icon: Icons.bedtime,
                  margin: const EdgeInsets.only(left: 8),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
