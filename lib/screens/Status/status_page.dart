import 'package:bunk_mate/controllers/status/status_controller.dart';
import 'package:bunk_mate/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';

class StatusView extends StatefulWidget {
  final FocusNode focusNode;
  StatusView({super.key, required this.focusNode});

  @override
  State<StatusView> createState() => StatusViewState();
}

class StatusViewState extends State<StatusView> {
  final StatusController controller =
      Get.put(StatusController(apiUrl: 'https://api.bunkmate.college'));

  final Color bgColor = const Color(0xFF121212);

  final Color cardColor = const Color(0xFF1E1E1E);

  final Color accentColor = const Color(0xFF4CAF50);

  final Color textColor = Colors.white;

  final Color secondaryTextColor = Colors.white70;

  @override
  Widget build(BuildContext context) {
    controller.getStatus();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: bgColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                      controller.days[controller.selectedDate.value.weekday]
                          .toString(),
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.lexend().fontFamily,
                      ),
                    )),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _buildRewindTimeButton(context),
              _buildHelpButon(context)
            ],
          ),
        ],
      ),
      body: Obx(
        () => controller.courses.isNotEmpty
            ? _buildCourseList()
            : _buildEmptyState(context),
      ),
    );
  }

  void showPageGuide() async {
    bool isOnboardingCompleted = await StorageService().getOnboardingComplete();
    final OnboardingState? onboarding = Onboarding.of(context);
    if (onboarding != null && !isOnboardingCompleted) {
      onboarding.show();
      await StorageService().setOnboardingComplete();
    } else {
      print("Onboarding is null");
    }
  }

  Widget _buildHelpButon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onPressed: () {
          final OnboardingState? onboarding = Onboarding.of(context);
          if (onboarding != null) {
            onboarding.show();
          } else {
            print("Onboarding is null");
          }
        },
        child: const Icon(Icons.help_outline, size: 40, color: Colors.white),
      ),
    );
  }

  Widget _buildRewindTimeButton(BuildContext context) {
    return  ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onPressed: () => controller.selectDate(context),
        child: const Icon(LineIcons.calendar, size: 40, color: Colors.white),
    );
  }

  Widget _buildCourseList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: controller.courses.length,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0)
          return Focus(
            focusNode: widget.focusNode,
            child: _buildCourseItem(controller.courses[index]),
          );
        return _buildCourseItem(controller.courses[index]);
      },
    );
  }

  Widget _buildCourseItem(Map<String, dynamic> course) {
    String name = course["name"].toString();
    String status = course["status"];
    Color statusColor = _getStatusColor(status);

    return GestureDetector(
      onTap: () => _updateCourseStatus(course, "bunked"),
      onDoubleTap: () => _updateCourseStatus(course, "cancelled"),
      onLongPress: () => _updateCourseStatus(course, "present"),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          leading: Icon(
            controller.getRandomSubjectIcon(),
            size: 36,
            color: accentColor,
          ),
          title: Text(
            name,
            style: TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                  color: statusColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'bunked':
        return Colors.red;
      case 'cancelled':
        return Colors.blue;
      default:
        return accentColor;
    }
  }

  void _updateCourseStatus(Map<String, dynamic> course, String newStatus) {
    course["status"] = newStatus;
    controller.updateStatus(
      course["session_url"],
      newStatus,
      date: controller.selectedDate.value,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No Courses Scheduled Today!",
            style: TextStyle(color: textColor, fontSize: 20),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: DropdownButtonFormField<int>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                fillColor: accentColor.withOpacity(0.1),
                filled: true,
              ),
              hint: Text(
                "Copy Schedule",
                style: TextStyle(color: secondaryTextColor, fontSize: 16),
              ),
              dropdownColor: cardColor,
              items: controller.days.entries.map((days) {
                return DropdownMenuItem<int>(
                  value: days.key,
                  child: Text(
                    days.value,
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (days) {
                if (days != null) {
                  controller.addHoliday(days);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
