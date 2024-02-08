import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({super.key});

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  Map<String, dynamic> map1 = {'Maths': "Present", 'Science': "Present", 'Social Science': 2,'Physics':1,"Chemistry":1,"Electronics":1,"OOPS":1,"ADM":1,"MAOM":2};
  @override
  Widget build(BuildContext context) {
    final currentDay = DateFormat('EEEE').format(DateTime.now());
    print(currentDay);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 9, 15),
      appBar: AppBar(
        title: Text(
          currentDay,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
        ),
        backgroundColor: Color.fromARGB(255, 7, 9, 15),
      ),
      body: ListView.builder(
          itemCount: map1.length,
          itemBuilder: (BuildContext context, int index) {
            String key = map1.keys.elementAt(index);
            return new Column(
              children: [
                GestureDetector(onTap: () {
                        setState(() {
                          map1[key] = "Absent";
                        });
                      },
                      onDoubleTap: () {
                        setState(() {
                          map1[key] = "Cancelled";
                        });
                      },
                      onLongPress: () {
                        setState(() {
                          map1[key] = "Present";
                        });
                      }, child:ListTile(
                    title: Text(
                      "$key",
                      style: TextStyle(color: Colors.white,fontSize: 32),
                    ),
                    trailing: Text(
                      "${map1[key]}",
                      style: TextStyle(color: Colors.white,fontSize: 15),
                    ),
                    
                     
                    )),
                new Divider(
                  height: 2.0,
                )
              ],
            );
          }),
    );
  }
}
