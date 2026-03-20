class OnBoardModel {
  String name;
  int threshold;
  String startDate;
  String endDate;
  bool isShared;
  List<List<String>> coursesData;

  OnBoardModel({
    required this.name,
    required this.threshold,
    required this.startDate,
    required this.endDate,
    required this.isShared,
    required this.coursesData,
  });
}
