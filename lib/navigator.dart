import 'dart:convert';
import 'dart:io';

import 'package:attendence1/global.dart';
import 'package:attendence1/subject.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:line_icons/line_icons.dart';
import 'package:attendence1/homepage.dart';


class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _children = <Widget>[
     MyWidget(),
    TimeTable(),
   
    
  ];
  changeIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
      
    }
   );
    if (index == 1) {
      
      
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: _children,
        index: currentIndex,
      ),

        bottomNavigationBar:
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.heart,
                  text: 'Likes',
                ),
                GButton(
                  icon: LineIcons.search,
                  text: 'Search',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
              ],
              selectedIndex: currentIndex,
              onTabChange: onTabTapped,
              
            ),
          ),
        ),
      ),
      
    );
  }
}
