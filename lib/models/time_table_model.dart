class Course {
  final String name;
  final String schedulesUrl;

  Course({required this.name, required this.schedulesUrl});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'] ?? '',
      schedulesUrl: json['schedules_url'] ?? '',
    );
  }
}

class Schedule {
  final String dayOfWeek;
  final List<Course> courses;

  Schedule({required this.dayOfWeek, required this.courses});

  factory Schedule.fromJson(String dayOfWeek, List<dynamic> json) {
    List<Course> coursesList = json.map((i) => Course.fromJson(i)).toList();
    return Schedule(
      dayOfWeek: dayOfWeek,
      courses: coursesList,
    );
  }
}
