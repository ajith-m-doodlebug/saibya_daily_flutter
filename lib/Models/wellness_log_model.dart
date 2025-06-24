class WellnessLog {
  final int id;
  final int userId;
  final String date;
  final double sleepHours;
  final int moodRating;
  final double hydrationLiters;
  final String? meals;
  final String? notes;
  final DateTime createdAt;

  WellnessLog({
    required this.id,
    required this.userId,
    required this.date,
    required this.sleepHours,
    required this.moodRating,
    required this.hydrationLiters,
    this.meals,
    this.notes,
    required this.createdAt,
  });

  // Factory constructor to create from JSON
  factory WellnessLog.fromJson(Map<String, dynamic> json) {
    return WellnessLog(
      id: json['id'],
      userId: json['user_id'],
      date: json['date'],
      sleepHours: json['sleep_hours'].toDouble(),
      moodRating: json['mood_rating'],
      hydrationLiters: json['hydration_liters'].toDouble(),
      meals: json['meals'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date,
      'sleep_hours': sleepHours,
      'mood_rating': moodRating,
      'hydration_liters': hydrationLiters,
      'meals': meals,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Convert to JSON for creating new log (without id, user_id, created_at)
  Map<String, dynamic> toCreateJson() {
    return {
      'date': formattedDate,
      'sleep_hours': sleepHours,
      'mood_rating': moodRating,
      'hydration_liters': hydrationLiters,
      if (meals != null) 'meals': meals,
      if (notes != null) 'notes': notes,
    };
  }

  // Convert to JSON for updating (only non-null fields)
  Map<String, dynamic> toUpdateJson({
    double? sleepHours,
    int? moodRating,
    double? hydrationLiters,
    String? meals,
    String? notes,
  }) {
    final Map<String, dynamic> json = {};
    if (sleepHours != null) json['sleep_hours'] = sleepHours;
    if (moodRating != null) json['mood_rating'] = moodRating;
    if (hydrationLiters != null) json['hydration_liters'] = hydrationLiters;
    if (meals != null) json['meals'] = meals;
    if (notes != null) json['notes'] = notes;
    return json;
  }

  // CopyWith method for creating modified copies
  WellnessLog copyWith({
    int? id,
    int? userId,
    String? date,
    double? sleepHours,
    int? moodRating,
    double? hydrationLiters,
    String? meals,
    String? notes,
    DateTime? createdAt,
  }) {
    return WellnessLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      sleepHours: sleepHours ?? this.sleepHours,
      moodRating: moodRating ?? this.moodRating,
      hydrationLiters: hydrationLiters ?? this.hydrationLiters,
      meals: meals ?? this.meals,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Getters for formatted display
  String get formattedDate {
    final DateTime dateTime = DateTime.parse(date);
    final String day = dateTime.day.toString().padLeft(2, '0');
    final String month = dateTime.month.toString().padLeft(2, '0');
    final String year = dateTime.year.toString();
    return "$year-$month-$day";
  }

  String get moodEmoji {
    switch (moodRating) {
      case 1:
        return '😔';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }

  String get sleepQuality {
    if (sleepHours >= 8) return 'Excellent';
    if (sleepHours >= 7) return 'Good';
    if (sleepHours >= 6) return 'Fair';
    return 'Poor';
  }

  String get hydrationStatus {
    if (hydrationLiters >= 3) return 'Excellent';
    if (hydrationLiters >= 2) return 'Good';
    if (hydrationLiters >= 1.5) return 'Fair';
    return 'Need more water';
  }

  @override
  String toString() {
    return 'WellnessLog(id: $id, date: $date, sleep: $sleepHours, mood: $moodRating, hydration: $hydrationLiters)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WellnessLog && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
