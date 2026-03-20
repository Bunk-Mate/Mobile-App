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

class TimetableCollection {
  final String name;
  final bool shared;
  final String startDate;
  final String endDate;
  final int threshold;
  final List<List<String>> coursesData;

  TimetableCollection({
    required this.name,
    required this.shared,
    required this.startDate,
    required this.endDate,
    required this.threshold,
    required this.coursesData,
  });

  factory TimetableCollection.fromJson(Map<String, dynamic> json) {
    final rawCoursesData = (json['courses_data'] as List<dynamic>? ?? []);
    final parsedCoursesData = rawCoursesData
        .map(
          (row) => List<String>.from(
            (row as List<dynamic>).map((cell) => (cell ?? '').toString()),
          ),
        )
        .toList(growable: false);

    return TimetableCollection(
      name: (json['name'] ?? '').toString(),
      shared: json['shared'] == true,
      startDate: (json['start_date'] ?? '').toString(),
      endDate: (json['end_date'] ?? '').toString(),
      threshold: int.tryParse((json['threshold'] ?? 0).toString()) ?? 0,
      coursesData: parsedCoursesData,
    );
  }
}
