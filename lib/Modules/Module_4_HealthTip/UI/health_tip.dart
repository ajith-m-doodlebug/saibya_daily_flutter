import 'package:flutter/material.dart';
import 'package:saibya_daily/Utils/colors.dart';
import 'package:saibya_daily/Models/health_tip_model.dart';
import 'package:saibya_daily/Utils/names_of_fonts.dart';

import '../Data/health_tip_data.dart';

class HealthTip extends StatefulWidget {
  const HealthTip({super.key});

  @override
  State<HealthTip> createState() => _HealthTipState();
}

class _HealthTipState extends State<HealthTip> {
  final HealthTipData _healthTipData = HealthTipData();
  HealthTipModel? _healthTip;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHealthTip();
  }

  Future<void> _fetchHealthTip() async {
    setState(() {
      _isLoading = true;
    });

    final tip = await _healthTipData.getHealthTip(context);

    if (mounted) {
      setState(() {
        _healthTip = tip;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.tips_and_updates,
                          color: AppColors.secondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Daily Wisdom',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                            fontFamily: InterFont,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildContent(),
                  ],
                ),
              ),
              IconButton(
                onPressed: _isLoading ? null : _fetchHealthTip,
                icon: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.onSurface.withOpacity(0.4),
                          ),
                        ),
                      )
                    : Icon(
                        Icons.refresh_rounded,
                        color: AppColors.onPrimary.withOpacity(0.4),
                        size: 20,
                      ),
                tooltip: 'Refresh',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
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
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildShimmer();
    }

    if (_healthTip == null) {
      return Text(
        'Unable to load health tip. Please try again.',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }

    return Text(
      _healthTip!.tip,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.onSurface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 20,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: AppColors.onSurface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
