import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:saibya_daily/Modules/Module_5_Stats/Data/stats_data.dart';
import 'package:saibya_daily/Utils/colors.dart';
import 'package:saibya_daily/Models/wellness_log_model.dart';

class WellnessTrendsChart extends StatefulWidget {
  final int days;

  const WellnessTrendsChart({
    super.key,
    this.days = 7,
  });

  @override
  State<WellnessTrendsChart> createState() => _WellnessTrendsChartState();
}

class _WellnessTrendsChartState extends State<WellnessTrendsChart> {
  final StatsData _homeData = StatsData();
  List<WellnessLog> _logs = [];
  bool _isLoading = true;
  String? _error;

  // Chart visibility toggles
  bool _showSleep = true;
  bool _showMood = true;
  bool _showHydration = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final logs = await _homeData.getWellnessLogs(context, days: widget.days);

      setState(() {
        _logs = logs
          ..sort((a, b) =>
              DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load chart data: $e';
        _isLoading = false;
      });
    }
  }

  List<FlSpot> _getSleepSpots() {
    if (_logs.isEmpty) return [];

    return _logs.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.sleepHours);
    }).toList();
  }

  List<FlSpot> _getMoodSpots() {
    if (_logs.isEmpty) return [];

    return _logs.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.moodRating.toDouble());
    }).toList();
  }

  List<FlSpot> _getHydrationSpots() {
    if (_logs.isEmpty) return [];

    return _logs.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(),
          entry.value.hydrationLiters * 2); // Scale for better visibility
    }).toList();
  }

  Widget _buildLegendItem(
      String label, Color color, bool isVisible, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color:
              isVisible ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isVisible ? color : Colors.grey,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isVisible ? color : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isVisible ? Colors.black87 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDateLabel(int index) {
    if (index >= _logs.length) return '';
    final date = DateTime.parse(_logs[index].date);
    return '${date.day}/${date.month}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 300,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.secondary, width: 1),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null || _logs.isEmpty) {
      return Container(
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red, width: 1),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _logs.isEmpty ? Icons.bar_chart_outlined : Icons.error,
                size: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                _logs.isEmpty ? 'No data available' : 'Error loading chart',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _loadData,
                  child: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Wellness Trends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),

          // Legend
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildLegendItem(
                'Sleep (hrs)',
                Colors.blue,
                _showSleep,
                () => setState(() => _showSleep = !_showSleep),
              ),
              _buildLegendItem(
                'Mood (/5)',
                Colors.green,
                _showMood,
                () => setState(() => _showMood = !_showMood),
              ),
              _buildLegendItem(
                'Water (L×2)',
                Colors.cyan,
                _showHydration,
                () => setState(() => _showHydration = !_showHydration),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Chart
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          // axisSide: meta.axisSide,
                          meta: meta,
                          child: Text(
                            _getDateLabel(value.toInt()),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: (_logs.length - 1).toDouble(),
                minY: 0,
                maxY: 12,
                lineBarsData: [
                  // Sleep line
                  if (_showSleep)
                    LineChartBarData(
                      spots: _getSleepSpots(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3,
                            color: Colors.blue,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),

                  // Mood line
                  if (_showMood)
                    LineChartBarData(
                      spots: _getMoodSpots(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3,
                            color: Colors.green,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withOpacity(0.1),
                      ),
                    ),

                  // Hydration line
                  if (_showHydration)
                    LineChartBarData(
                      spots: _getHydrationSpots(),
                      isCurved: true,
                      color: Colors.cyan,
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3,
                            color: Colors.cyan,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.cyan.withOpacity(0.1),
                      ),
                    ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.black87,
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final flSpot = barSpot;
                        String label = '';
                        String value = '';

                        if (flSpot.barIndex == 0 && _showSleep) {
                          label = 'Sleep';
                          value = '${flSpot.y.toStringAsFixed(1)} hrs';
                        } else if ((flSpot.barIndex == 1 &&
                                _showSleep &&
                                _showMood) ||
                            (flSpot.barIndex == 0 &&
                                !_showSleep &&
                                _showMood)) {
                          label = 'Mood';
                          value = '${flSpot.y.toStringAsFixed(1)}/5';
                        } else {
                          label = 'Water';
                          value = '${(flSpot.y / 2).toStringAsFixed(1)}L';
                        }

                        return LineTooltipItem(
                          '$label: $value',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
              ),
            ),
          ),

          // Additional info
          const SizedBox(height: 12),
          Text(
            'Tap legend items to toggle lines • Water values are scaled ×2 for visibility',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
