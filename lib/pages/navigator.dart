
import 'package:attendence1/pages/TimeTableEntry.dart';
import 'package:attendence1/global.dart';
import 'package:attendence1/pages/subject.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:attendence1/pages/homepage.dart';
import 'package:simple_drawer/simple_drawer.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final GlobalKey<HomePageState> _statsGlobalKey = GlobalKey();
  final GlobalKey<TimeTableState> _statusGlobalKey = GlobalKey();
  int currentIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  void onTabTapped(int index) {
    setState(
      () {
        currentIndex = index;
      },
    );
    SimpleDrawer.activate("bottom");
    if (statsUpdate) _statsGlobalKey.currentState?.getStats();
    if (statusUpdate) _statusGlobalKey.currentState?.getStatus();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = <Widget>[
      HomePage(key: _statsGlobalKey),
      TimeTable(key: _statusGlobalKey),
      TimeTableEntry(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _children,
      ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 13, 15, 21),
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
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                child: GNav(
                  // rippleColor: Colors.white,
                  // hoverColor: Colors.white,
                  // Color.fromARGB(255, 155, 226, 61)
                  gap: 8,
                  activeColor: Colors.black,
                  iconSize: 32,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Color.fromARGB(255, 211, 255, 153),
                  color: const Color.fromARGB(255, 211, 255, 153),
                  tabs: const [
                    GButton(
                      icon: LineIcons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: LineIcons.checkCircle,
                      text: 'Status',
                    ),
                    GButton(
                      icon: LineIcons.calendarTimes,
                      text: 'TimeTable',
                    ),
                  ],

                  selectedIndex: currentIndex,
                  onTabChange: onTabTapped,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
