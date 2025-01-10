import 'package:bunk_mate/models/on_board_model.dart';
import 'package:bunk_mate/services/on_board_service.dart';
import 'package:bunk_mate/utils/navigation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OnBoardController extends GetxController {
  final OnBoardService _service = OnBoardService();
  RxList<dynamic> presets = [].obs;
  RxString startDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;
  String timeTableName = "";
  int minAttendance = 0;
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

  void submit() {
    if (endDate.value.isNotEmpty &&
        startDate.value.isNotEmpty &&
        timeTableName.isNotEmpty &&
        minAttendance != 0) {
      OnBoardModel timetable = OnBoardModel(
        name: timeTableName,
        minAttendance: minAttendance,
        startDate: startDate.value,
        endDate: endDate.value,
        isShared: isShared.value,
      );
      _service.submitTimetable(timetable).then((_) {
        Get.snackbar("Success", "TimeTable has been created");
        Get.off(const Navigation());
      }).catchError((error) {
        Get.snackbar("Error", "Could not create timetableld");
      });
    } else {
      Get.snackbar("Error", "Please enter all details!");
    }
  }
}
