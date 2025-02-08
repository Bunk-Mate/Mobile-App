import 'package:bunk_mate/screens/on_board_view.dart';
import 'package:bunk_mate/screens/auth/login_screen.dart';
import 'package:bunk_mate/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bunk_mate/controllers/homepage/course_summary_controller.dart';
import 'package:bunk_mate/controllers/auth/login_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final CourseSummaryController courseSummaryController =
  Get.put(CourseSummaryController());
  final LoginController loginController = Get.put(LoginController());

  final Color bgColor = const Color(0xFF121212);
  final Color cardColor = const Color(0xFF1E1E1E);
  final Color accentColor = const Color(0xFF4CAF50);
  final Color textColor = Colors.white;
  final Color secondaryTextColor = Colors.white70;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> refreshData() async {
    await courseSummaryController.fetchCourseSummary();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Bunk-Mate',
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        actions: [_buildPopupMenu()],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SafeArea(
          child: Obx(() {
            if (courseSummaryController.isLoading.value) {
              return Center(
                child: SpinKitPulse(
                  color: accentColor,
                  size: 50.0,
                ),
              );
            }
            if (courseSummaryController.courseSummary.isEmpty) {
              return _buildEmptyState();
            }
            return RefreshIndicator(
              onRefresh: refreshData,
              color: accentColor,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 30),
                  _buildOverallAttendance(),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Courses',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${courseSummaryController.courseSummary.length} Total',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSubjectList(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Text(
            "Update Timetable",
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            "Logout",
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        ),
      ],
      offset: const Offset(0, 50),
      color: cardColor,
      elevation: 2,
      icon: Icon(Icons.more_vert, color: textColor, size: 28),
      onSelected: _handleMenuSelection,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: secondaryTextColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "No courses available.\nAdd a course or update your timetable.",
            textAlign: TextAlign.center,
            style: TextStyle(color: secondaryTextColor, fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallAttendance() {
    double overallAttendance = courseSummaryController.courseSummary
        .map((subject) => subject.percentage is int
        ? subject.percentage.toDouble()
        : subject.percentage)
        .reduce((a, b) => a + b) /
        courseSummaryController.courseSummary.length;

    IconData getEmojiIconBasedOnAttendance(double attendance) {
      if (attendance >= 90) {
        return Icons.sentiment_very_satisfied_outlined;
      } else if (attendance >= 70) {
        return Icons.sentiment_satisfied_outlined;
      } else if (attendance >= 50) {
        return Icons.sentiment_neutral_outlined;
      } else {
        return Icons.sentiment_dissatisfied_outlined;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Attendance',
                style: TextStyle(color: secondaryTextColor, fontSize: 18),
              ),
              Icon(
                getEmojiIconBasedOnAttendance(overallAttendance),
                size: 30,
                color: _getAttendanceColor(overallAttendance),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${overallAttendance.toStringAsFixed(1)}%',
            style: TextStyle(
              color: _getAttendanceColor(overallAttendance),
              fontSize: 60,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

        ],
      ),
    );
  }


  Widget _buildSubjectList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courseSummaryController.courseSummary.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final subject = courseSummaryController.courseSummary[index];
        return _buildSubjectTile(subject);
      },
    );
  }

  Widget _buildSubjectTile(subject) {
    double percentage = subject.percentage is int
        ? subject.percentage.toDouble()
        : subject.percentage;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subject.name,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              _buildBunksAvailable(subject.bunksAvailable),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: _getAttendanceColor(percentage).withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation(_getAttendanceColor(percentage)),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "${percentage.toStringAsFixed(1)}%",
                style: TextStyle(
                  color: _getAttendanceColor(percentage),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBunksAvailable(int bunksAvailable) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, color: accentColor, size: 16),
          const SizedBox(width: 4),
          Text(
            "$bunksAvailable bunks",
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getAttendanceColor(double attendance) {
    if (attendance >= 75) return const Color(0xFF4CAF50);
    if (attendance >= 65) return const Color(0xFFFFA000);
    return const Color(0xFFF44336);
  }

  Future<void> _handleLogout() async {
    bool success = await loginController.logoutfunction();
    if (!success) {
      Get.off(const LoginScreen());
      Get.snackbar("Logout Successful", "You were logged out successfully");
      Get.deleteAll();
    } else {
      Get.snackbar("Error", "You weren't logged out. Try again.");
      Get.to(Navigation());
    }
  }

  void _handleMenuSelection(int value) async {
    if (value == 0) {
      Get.to(const OnBoardView());
    } else if (value == 2) {
      await _handleLogout();
    }
  }
}