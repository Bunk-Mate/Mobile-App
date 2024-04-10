import 'package:flutter/material.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:attendence1/pages/onboarding.dart';

class MySideSheet {
  static Future<dynamic> showSideSheet(BuildContext context , VoidCallback logoutCallBack) async {
    return SideSheet.left(
      width: MediaQuery.of(context).size.width * 0.4,
      sheetColor: const Color.fromARGB(255, 7, 9, 15),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.25,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 211, 255, 153),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const OnBoard(),
                  ));
                },
                child: const Text(
                  "Timetable",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 211, 255, 153),
                  ),
                ),
                onPressed: () {
                  logoutCallBack;
                  //  Navigator.pushNamed(context, '/');
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Color.fromARGB(255, 211, 255, 153),
              ),
              onPressed: () => Navigator.pop(context, 'Data Returns Left'),
            ),
          ),
        ],
      ),
      context: context,
    );
  }
}
