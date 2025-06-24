import 'package:flutter/material.dart';
import 'package:saibya_daily/Models/wellness_log_model.dart';
import 'package:saibya_daily/Utils/colors.dart';
import 'package:saibya_daily/Utils/ui_sizes.dart';

class LogCard extends StatelessWidget {
  final WellnessLog log;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LogCard({
    super.key,
    required this.log,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLogDetails(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.secondary, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date and mood emoji
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(log.date),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  _getMoodData(log.moodRating)['emoji'],
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Sleep, Water, Mood stats
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    Icons.bedtime,
                    'Sleep',
                    '${log.sleepHours}h',
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    Icons.water_drop,
                    'Water',
                    '${log.hydrationLiters}L',
                    Colors.cyan,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    Icons.sentiment_very_satisfied_rounded,
                    'Mood',
                    '${log.moodRating}/5',
                    Colors.greenAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Notes if available
            if (log.notes?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.note,
                      size: smallFontSize(context),
                      color: AppColors.onSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        log.notes!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: smallFontSize(context) - 1,
                          color: AppColors.onSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showLogDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(log.date),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  _getMoodData(log.moodRating)['emoji'],
                  style: const TextStyle(fontSize: 32),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Detailed stats
            _buildDetailedStats(context),

            const SizedBox(height: 20),

            // Notes section
            if (log.notes?.isNotEmpty == true) ...[
              Text(
                'Notes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  log.notes!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Meals section if available
            if (log.meals?.isNotEmpty == true) ...[
              Text(
                'Meals',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  log.meals!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Action buttons (show for all logs)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showDeleteConfirmation(context);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onEdit.call();
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.onSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            // Add bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStats(BuildContext context) {
    return Column(
      children: [
        _buildDetailRow(
          context,
          Icons.bedtime,
          'Sleep',
          '${log.sleepHours} hours',
          log.sleepQuality,
          Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildDetailRow(
          context,
          Icons.water_drop,
          'Hydration',
          '${log.hydrationLiters} liters',
          log.hydrationStatus,
          Colors.cyan,
        ),
        const SizedBox(height: 16),
        _buildDetailRow(
          context,
          Icons.sentiment_very_satisfied_rounded,
          'Mood',
          '${log.moodRating}/5',
          _getMoodData(log.moodRating)['description'] ?? '',
          Colors.greenAccent,
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    String description,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
              if (description.isNotEmpty)
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Log'),
        content: Text(
            'Are you sure you want to delete the log for ${_formatDate(log.date)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete.call();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getMoodData(int rating) {
    switch (rating) {
      case 1:
        return {'emoji': '😢', 'description': 'Very Sad'};
      case 2:
        return {'emoji': '😕', 'description': 'Sad'};
      case 3:
        return {'emoji': '😐', 'description': 'Neutral'};
      case 4:
        return {'emoji': '😊', 'description': 'Happy'};
      case 5:
        return {'emoji': '😄', 'description': 'Very Happy'};
      default:
        return {'emoji': '❓', 'description': 'Unknown'};
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final logDate = DateTime(date.year, date.month, date.day);

      if (logDate == today) {
        return 'Today';
      } else if (logDate == today.subtract(const Duration(days: 1))) {
        return 'Yesterday';
      } else {
        final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ];
        return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
      }
    } catch (e) {
      return dateString;
    }
  }
}
