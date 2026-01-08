import 'package:bunk_mate/controllers/navigation/navigation_controller.dart';
import 'package:bunk_mate/screens/Status/status_page.dart';
import 'package:bunk_mate/screens/TimeTable/time_table_page.dart';
import 'package:bunk_mate/screens/homepage/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';

class Navigation extends StatefulWidget {
  Navigation({super.key});
  final GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final NavigationController controller = NavigationController();
  final Color bgColor = const Color(0xFF121212);
  final Color accentColor = const Color(0xFF4CAF50);
  final Color inactiveColor = Colors.white54;
  final GlobalKey<HomePageState> homePageKey = GlobalKey<HomePageState>();
  final GlobalKey<StatusViewState> statusPageKey = GlobalKey<StatusViewState>();
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    focusNodes = List<FocusNode>.generate(
      1,
          (int i) => FocusNode(debugLabel: 'Onboarding Focus Node $i'),
      growable: false,
    );
  }

  void onTabTapped(int index) {
    if (index == 0) {
      homePageKey.currentState?.refreshData();
    } else if (index == 1) {
      print("in if");
      statusPageKey.currentState?.showPageGuide();
    }
    controller.updateIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[
      HomePage(key: homePageKey),
      StatusView(
        focusNode: focusNodes[0],
        key: statusPageKey,
      ),
      const TimeTablePage(),
    ];

    return Onboarding(
      key: widget.onboardingKey,
      autoSizeTexts: true,
      steps: <OnboardingStep>[
        OnboardingStep(
          focusNode: focusNodes[0],
          titleText: "",
          bodyText: '',
          overlayBehavior: HitTestBehavior.deferToChild,
          stepBuilder: (context, renderInfo) {
            return Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                        color: const Color(0x80000020)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Guide to Status Page',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Tap to cycle between different attendance states',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        buildGuideStep(
                          '',
                          'assets/bunked.png',
                        ),
                        buildGuideStep(
                          '',
                          'assets/cancelled.png',
                        ),
                        buildGuideStep(
                          '',
                          'assets/present.png',
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: renderInfo.close,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                            ),
                            child: const Text(
                              "close",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            );
          },
        ),
      ],
      child: Scaffold(
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
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(0, Icons.home_rounded, 'Home'),
                  _buildNavItem(
                      1, Icons.check_circle_outline_rounded, 'Status'),
                  _buildNavItem(2, Icons.calendar_today_rounded, 'Timetable'),
                ],
              ),
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

  Widget buildGuideStep(String text, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Image.asset(
          imagePath,
          width: 300,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'Image not found',
              style: TextStyle(color: Colors.red),
            );
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
