import 'package:flutter/material.dart';
import 'package:saibya_daily/Models/wellness_log_model.dart';
import 'package:saibya_daily/Modules/Module_3_Logs/1_Log_Add/UI/log_add.dart';
import 'package:saibya_daily/Modules/Module_3_Logs/2_Log_Edit/UI/log_edit.dart';
import 'package:saibya_daily/Modules/Module_3_Logs/Data/logs_data.dart';
import 'package:saibya_daily/Utils/colors.dart';
import 'package:saibya_daily/Utils/ui_sizes.dart';
import 'log_card.dart';

class Logs extends StatefulWidget {
  const Logs({super.key});

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  final LogsData _logsData = LogsData();
  List<WellnessLog> _logs = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int _selectedDays = 7;
  WellnessLog? _todayLog;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final logs =
          await _logsData.getWellnessLogs(context, days: _selectedDays);

      // Check for today's log
      final todayLog = await _logsData.getTodayLog(context);

      setState(() {
        _logs = logs;
        _todayLog = todayLog;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load logs: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteLog(WellnessLog log) async {
    try {
      final success = await _logsData.deleteWellnessLog(context, log.id);

      if (success) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Log deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Reload the logs
        await _loadLogs();
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete log'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting log: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _editLog(WellnessLog log) async {
    bool reload = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LogEdit(logToEdit: log),
      ),
    );

    if (reload == true) {
      _loadLogs();
    }
  }

  void _onDaysChanged(int days) {
    setState(() {
      _selectedDays = days;
    });
    _loadLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Wellness ',
                          style: TextStyle(
                            fontSize: mediumFontSize(context),
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "Logs",
                          style: TextStyle(
                            fontSize: mediumFontSize(context),
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Show '+' icon only if today's log doesn't exist
                  if (_todayLog == null)
                    GestureDetector(
                      onTap: () async {
                        bool reload = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LogAdd(),
                          ),
                        );

                        if (reload == true) {
                          _loadLogs();
                        }
                      },
                      child: Icon(
                        Icons.add,
                        color: AppColors.onSecondary,
                        size: mediumFontSize(context) + 4,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.onPrimary.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Filter Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('Today', 1),
                          const SizedBox(width: 8),
                          _buildFilterChip('7 Days', 7),
                          const SizedBox(width: 8),
                          _buildFilterChip('30 Days', 30),
                          const SizedBox(width: 8),
                          _buildFilterChip('90 Days', 90),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Expanded(
              child: _buildContent(),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int days) {
    final isSelected = _selectedDays == days;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.onBackground : AppColors.onSecondary,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _onDaysChanged(days);
        }
      },
      selectedColor: AppColors.secondary,
      backgroundColor: AppColors.onBackground,
      side: BorderSide(
        color: AppColors.secondary,
        width: 1,
      ),
      showCheckmark: false,
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text('Loading wellness logs...'),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadLogs,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No logs found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                bool reload = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LogAdd(),
                  ),
                );

                if (reload == true) {
                  _loadLogs();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Log'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLogs,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _logs.length,
        itemBuilder: (context, index) {
          final log = _logs[index];
          return LogCard(
            log: log,
            onEdit: () => _editLog(log),
            onDelete: () => _deleteLog(log),
          );
        },
      ),
    );
  }
}
