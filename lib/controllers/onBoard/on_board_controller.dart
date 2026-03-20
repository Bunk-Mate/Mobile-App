import 'package:bunk_mate/models/on_board_model.dart';
import 'package:bunk_mate/services/on_board_service.dart';
import 'package:bunk_mate/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OnBoardController extends GetxController {
  final OnBoardService _service = OnBoardService();
  RxList<dynamic> presets = [].obs;
  RxString startDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;
  String timeTableName = "";
  int threshold = 0;
  RxString endDate = DateFormat("yyyy-MM-dd")
      .format(DateTime.now().add(const Duration(days: 30)))
      .obs;
  RxBool isShared = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPresets();
  }

  Future<void> _loadPresets() async {
    presets.value = await _service.getTimeTable();
  }

  bool canProceedToPaintGrid() {
    return endDate.value.isNotEmpty &&
        startDate.value.isNotEmpty &&
        timeTableName.trim().isNotEmpty &&
        threshold > 0;
  }

  Future<void> submit(List<List<String>> coursesData) async {
    if (!canProceedToPaintGrid()) {
      Get.snackbar(
        "Error",
        "Please enter all details!",
        colorText: Colors.white,
      );
      return;
    }

    final timetable = OnBoardModel(
      name: timeTableName.trim(),
      threshold: threshold,
      startDate: startDate.value,
      endDate: endDate.value,
      isShared: isShared.value,
      coursesData: coursesData,
    );

    try {
      await _service.submitTimetable(timetable);
      Get.snackbar(
        "Success",
        "TimeTable has been created",
        colorText: Colors.white,
      );
      Get.off(Navigation());
    } catch (_) {
      Get.snackbar(
        "Error",
        "Could not create timetable",
        colorText: Colors.white,
      );
    }
  }
}
