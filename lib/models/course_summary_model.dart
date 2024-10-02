class CourseSummary {
  final String name;
  final dynamic  percentage;
  final int bunksAvailable;

  CourseSummary({
    required this.name,
    required this.percentage,
    required this.bunksAvailable,
  });


  factory CourseSummary.fromJson(Map<String, dynamic> json) {
    return CourseSummary(
      name: json['name'],
      percentage: json['percentage'],
      bunksAvailable: json['bunks_available'],
    );
  }
}
