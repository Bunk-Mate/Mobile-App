import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({Key? key}) : super(key: key);

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  TextEditingController customController = TextEditingController();
  List<String> Monday = ['MATHS', 'SCIENCE', 'PHYSICS'];

  Future<String?> createAlertDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter the Subject Name"),
          content: TextField(
            controller: customController,
          ),
          actions: [
            MaterialButton(
              elevation: 5.0,
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(customController.text);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 19, 21, 28),
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 31, 36, 47),title: Text("Monday",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 32),)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
             TableCalendar(
  firstDay: DateTime.utc(2010, 10, 16),
  lastDay: DateTime.utc(2030, 3, 14),
  focusedDay: DateTime.now(),
),
            SizedBox(
              width: 24,
              height: 24,
            ),  
            Expanded(
              child: ListView(
                children: Monday.map((element) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000000),
                        ),
                        child: Icon(Icons.mail,
                            size: 52, color: Colors.white24),
                      ),
                      tileColor: Color.fromARGB(255, 19, 21, 28),
                      title: Center(
                        child: Text(
                          element,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                    ),
                  );
                }).toList(),
              ),
            ),
       ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createAlertDialog(context).then((value) {
            if (value != null) {
              setState(() {
                Monday.add(value);
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
