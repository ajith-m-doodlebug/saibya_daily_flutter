class HealthTipModel {
  final String tip;

  HealthTipModel({
    required this.tip,
  });

  // Factory constructor to create from JSON
  factory HealthTipModel.fromJson(Map<String, dynamic> json) {
    return HealthTipModel(
      tip: json['tip'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'tip': tip,
    };
  }
}
