import 'dart:math';
import 'package:flutter/material.dart';



List<String> Hello = [
  "Hello", 
];
List<IconData> subjectIcons = [
  Icons.school,
];

IconData getRandomSubjectIcon() {
  var randomIndex = Random().nextInt(subjectIcons.length);
  return subjectIcons[randomIndex];
}
String getRandomHello() {
  var randomIndex = Random().nextInt(Hello.length);
  return Hello[randomIndex];
}