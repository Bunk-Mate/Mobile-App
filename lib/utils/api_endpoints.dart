class ApiEndPoints {
  static const String baseUrl = 'https://api.bunkmate.in/';
  static final _AuthEndPoints authEndPoints = _AuthEndPoints();
  static final _HomeEndPoints homeEndPoints = _HomeEndPoints();
  static final _TimeTableEndPoints timetable = _TimeTableEndPoints();
}

class _AuthEndPoints {
  final String registerEmail = 'register';
  final String loginEmail = 'login';
  final String logoutEmail = 'logout';
}

class _HomeEndPoints {
  final String courseSummary = 'statquery' ;
}

class _TimeTableEndPoints {
  final String timetable = 'schedules' ; 
}
