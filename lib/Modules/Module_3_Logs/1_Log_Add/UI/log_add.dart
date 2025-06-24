import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saibya_daily/Buttons/primary_button.dart';
import 'package:saibya_daily/Models/wellness_log_model.dart';
import 'package:saibya_daily/Modules/Module_3_Logs/1_Log_Add/bloc/logs_add_bloc.dart';
import 'package:saibya_daily/Utils/colors.dart';
import 'package:saibya_daily/Utils/ui_sizes.dart';

class LogAdd extends StatefulWidget {
  const LogAdd({super.key});

  @override
  State<LogAdd> createState() => _LogAddState();
}

class _LogAddState extends State<LogAdd> {
  final _formKey = GlobalKey<FormState>();
  final _sleepController = TextEditingController();
  final _waterController = TextEditingController();
  final _mealsController = TextEditingController();
  final _notesController = TextEditingController();

  int _selectedMood = 3;

  bool canSubmit = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to controllers to update canSubmit state
    _sleepController.addListener(_updateSubmitState);
    _waterController.addListener(_updateSubmitState);
    _mealsController.addListener(_updateSubmitState);
  }

  @override
  void dispose() {
    _sleepController.removeListener(_updateSubmitState);
    _waterController.removeListener(_updateSubmitState);
    _mealsController.removeListener(_updateSubmitState);
    _sleepController.dispose();
    _waterController.dispose();
    _mealsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateSubmitState() {
    setState(() {
      canSubmit = _sleepController.text.trim().isNotEmpty &&
          _waterController.text.trim().isNotEmpty &&
          _mealsController.text.trim().isNotEmpty &&
          double.tryParse(_sleepController.text) != null &&
          double.tryParse(_waterController.text) != null &&
          double.parse(_sleepController.text) > 0 &&
          double.parse(_waterController.text) > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogsAddBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Header Section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Add ',
                              style: TextStyle(
                                fontSize: mediumFontSize(context),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "Log",
                              style: TextStyle(
                                fontSize: mediumFontSize(context),
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

              // Form Section
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sleep Input
                        _buildInputSection(
                          'Sleep Hours',
                          Icons.bedtime,
                          Colors.blue,
                          _sleepController,
                          'How many hours did you sleep?',
                          'hours',
                          TextInputType.number,
                        ),

                        const SizedBox(height: 24),

                        // Water Input
                        _buildInputSection(
                          'Water Intake',
                          Icons.water_drop,
                          Colors.cyan,
                          _waterController,
                          'How many liters of water?',
                          'liters',
                          TextInputType.number,
                        ),

                        const SizedBox(height: 24),

                        // Mood Selection
                        _buildMoodSection(),

                        const SizedBox(height: 24),

                        // Meals Input
                        _buildMealsSection(),

                        const SizedBox(height: 24),

                        // Notes Input
                        _buildNotesSection(),

                        const SizedBox(height: 24),

                        // Save Button
                        BlocConsumer<LogsAddBloc, LogsAddState>(
                          listener: (context, state) {
                            if (state is AddLogSuccessState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Log added successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pop(context, true);
                            } else if (state is AddLogErrorState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.errorMessage),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is AddLogLoadingState) {
                              return PrimaryButton(
                                text: "Save",
                                isLoading: true,
                                onPressed: null,
                              );
                            }

                            return PrimaryButton(
                              text: "Save",
                              onPressed: canSubmit
                                  ? () {
                                      context.read<LogsAddBloc>().add(
                                            AddLogEvent(
                                              context: context,
                                              log: WellnessLog(
                                                id: 0,
                                                userId: 0,
                                                createdAt: DateTime.now(),
                                                date: DateTime.now()
                                                    .toIso8601String(),
                                                sleepHours: double.parse(
                                                    _sleepController.text),
                                                hydrationLiters: double.parse(
                                                    _waterController.text),
                                                moodRating: _selectedMood,
                                                meals: _mealsController.text,
                                                notes: _notesController
                                                        .text.isNotEmpty
                                                    ? _notesController.text
                                                    : null,
                                              ),
                                            ),
                                          );
                                    }
                                  : null,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(
    String title,
    IconData icon,
    Color iconColor,
    TextEditingController controller,
    String hint,
    String suffix,
    TextInputType inputType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          keyboardType: inputType,
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.secondary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.secondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.secondary, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $title';
            }
            final numValue = double.tryParse(value);
            if (numValue == null || numValue <= 0) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.sentiment_very_satisfied_rounded,
                color: Colors.greenAccent, size: 20),
            const SizedBox(width: 8),
            Text(
              'Mood Rating',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.secondary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                'How are you feeling today?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMoodOption(1, '😢'),
                  _buildMoodOption(2, '😕'),
                  _buildMoodOption(3, '😐'),
                  _buildMoodOption(4, '😊'),
                  _buildMoodOption(5, '😄'),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '$_selectedMood/5',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodOption(int value, String emoji) {
    final isSelected = _selectedMood == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMood = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.secondary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 4),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppColors.secondary : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.restaurant, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Text(
              'Meals',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _mealsController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText:
                'What did you eat today? (e.g., Breakfast: Oats, Lunch: Rice...)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.secondary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.secondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.secondary, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.note, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Text(
              'Notes (Optional)',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _notesController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Add any additional notes about your day...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.secondary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.secondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.secondary, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
