class TimetableModel {
  String name;
  int minAttendance;
  String startDate;
  String endDate;
  bool isShared;

  TimetableModel({
    required this.name,
    required this.minAttendance,
    required this.startDate,
    required this.endDate,
    required this.isShared,
  });
}
