import 'package:bunk_mate/controllers/navigation/navigation_controller.dart';
import 'package:bunk_mate/screens/Status/status_page.dart';
import 'package:bunk_mate/screens/TimeTable/time_table_page.dart';
import 'package:bunk_mate/screens/homepage/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final NavigationController controller = NavigationController();
  final Color bgColor = const Color(0xFF121212);
  final Color accentColor = const Color(0xFF4CAF50);
  final Color inactiveColor = Colors.white54;
  final GlobalKey<HomePageState> homePageKey = GlobalKey<HomePageState>();

  void onTabTapped(int index) {
    if (index == 0) {
      homePageKey.currentState?.refreshData();
    }
    controller.updateIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[
      HomePage(key: homePageKey),
      StatusView(),
      const TimeTablePage(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: children,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: bgColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Home'),
                _buildNavItem(1, Icons.check_circle_outline_rounded, 'Status'),
                _buildNavItem(2, Icons.calendar_today_rounded, 'Timetable'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return Obx(() => InkWell(
          onTap: () => onTabTapped(index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: controller.currentIndex.value == index
                  ? accentColor.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: controller.currentIndex.value == index
                      ? accentColor
                      : inactiveColor,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: controller.currentIndex.value == index
                        ? accentColor
                        : inactiveColor,
                    fontSize: 12,
                    fontWeight: controller.currentIndex.value == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
