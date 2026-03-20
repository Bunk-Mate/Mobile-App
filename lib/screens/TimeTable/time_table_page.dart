import 'package:bunk_mate/controllers/onBoard/on_board_controller.dart';
import 'package:bunk_mate/controllers/status/status_controller.dart';
import 'package:bunk_mate/controllers/timetable/time_table_controller.dart';
import 'package:bunk_mate/models/forge_subject_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeTablePage extends StatefulWidget {
  final OnBoardController? onBoardController;

  const TimeTablePage({
    super.key,
    this.onBoardController,
  });

  bool get isOnboardingFlow => onBoardController != null;

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  static const int slotCount = 6;
  static const int dayCount = 5;

  static const List<String> dayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<Color> colorPalette = [
    Color(0xFF42A5F5),
    Color(0xFFAB47BC),
    Color(0xFFEC407A),
    Color(0xFFFFA726),
    Color(0xFF26A69A),
    Color(0xFFEF5350),
    Color(0xFF8D6E63),
    Color(0xFF7E57C2),
  ];

  static const Color bgColor = Color(0xFF121212);
  static const Color cardColor = Color(0xFF1F1F1F);
  static const Color accentColor = Color(0xFF4CAF50);
  static const Color textColor = Colors.white;
  static const Color mutedColor = Color(0xFF757575);
  static const Color borderColor = Color(0xFF2C2C2C);

  final TimeTableController _controller = Get.put(TimeTableController());

  late List<List<String>> _coursesData;
  late List<String> _timeSlotLabels;

  final RxList<ForgeSubject> _subjects = <ForgeSubject>[].obs;
  final Rxn<ForgeSubject> _activeSubject = Rxn<ForgeSubject>();

  bool _isLoading = true;
  bool _isEditMode = false;
  bool _isSubmitting = false;
  bool _isSavingEdit = false;

  int _colorInt(Color color) => color.toARGB32();

  @override
  void initState() {
    super.initState();
    if (widget.isOnboardingFlow) {
      _timeSlotLabels = _buildTimeSlotLabels(slotCount);
      _coursesData = List<List<String>>.generate(
        slotCount,
        (_) => List<String>.filled(dayCount, '', growable: true),
      );
      _isEditMode = true;
      _isLoading = false;
      return;
    }

    _loadCollectionIntoGrid();
  }

  Future<void> _loadCollectionIntoGrid() async {
    await _controller.getCollection();

    final collection = _controller.timetableCollection.value;
    final coursesData =
        _normalizeCoursesData(collection?.coursesData ?? const []);

    _coursesData = coursesData;
    _timeSlotLabels = _buildTimeSlotLabels(
      coursesData.isNotEmpty ? coursesData.length : slotCount,
    );

    final Map<String, Color> subjectColorMap = <String, Color>{};
    int colorIndex = 0;

    for (final day in _coursesData) {
      for (final rawName in day) {
        final name = rawName.trim();
        if (name.isNotEmpty && !subjectColorMap.containsKey(name)) {
          subjectColorMap[name] =
              colorPalette[colorIndex % colorPalette.length];
          colorIndex++;
        }
      }
    }

    _subjects.assignAll(
      subjectColorMap.entries
          .map(
            (entry) => ForgeSubject(
              name: entry.key,
              colorValue: _colorInt(entry.value),
            ),
          )
          .toList(growable: false),
    );

    if (_subjects.isNotEmpty) {
      _activeSubject.value = _subjects.first;
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<List<String>> _normalizeCoursesData(List<List<String>> coursesData) {
    int inferredDayCount = 0;
    for (final slotRow in coursesData) {
      if (slotRow.length > inferredDayCount) {
        inferredDayCount = slotRow.length;
      }
    }

    final normalizedDayCount =
        inferredDayCount > 0 ? inferredDayCount : dayCount;
    final normalizedSlotCount =
        coursesData.isNotEmpty ? coursesData.length : slotCount;

    return List<List<String>>.generate(
      normalizedSlotCount,
      (slotIndex) {
        final currentSlot = slotIndex < coursesData.length
            ? coursesData[slotIndex]
            : const <String>[];

        return List<String>.generate(
          normalizedDayCount,
          (dayIndex) {
            if (dayIndex >= currentSlot.length) {
              return '';
            }

            return currentSlot[dayIndex].trim();
          },
          growable: true,
        );
      },
      growable: true,
    );
  }

  List<String> _buildTimeSlotLabels(int count) {
    return List<String>.generate(count, (index) {
      return 'Slot ${index + 1}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: (!widget.isOnboardingFlow)
            ? null
            : const BackButton(color: Colors.white),
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          'TimeTable',
          style: GoogleFonts.lexend(
            fontSize: 24,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (widget.isOnboardingFlow)
            TextButton(
              onPressed: _isSubmitting ? null : _submitOnboardingTimetable,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: accentColor,
                      ),
                    )
                  : Text(
                      'Done',
                      style: GoogleFonts.lexend(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            )
          else if (_isEditMode)
            TextButton(
              onPressed: _isSavingEdit ? null : _saveEditedTimetable,
              child: _isSavingEdit
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: accentColor,
                      ),
                    )
                  : Text(
                      'Done',
                      style: GoogleFonts.lexend(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            )
          else
            IconButton(
              onPressed: _showEditDisclaimer,
              icon: const Icon(Icons.edit, color: accentColor),
              tooltip: 'Edit timetable',
            ),
        ],
      ),
      floatingActionButton: _isEditMode
          ? FloatingActionButton.extended(
              heroTag: 'add_subject',
              onPressed: _openSubjectForge,
              backgroundColor: accentColor,
              icon: const Icon(Icons.add, color: Colors.black),
              label: Text(
                'Add Subject',
                style: GoogleFonts.lexend(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: accentColor),
            )
          : Column(
              children: [
                if (!widget.isOnboardingFlow && !_isEditMode)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Text(
                      'Read-only mode. Tap Edit to modify timetable.',
                      style: GoogleFonts.lexend(
                        color: mutedColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                if (_isEditMode) _buildPaletteRow(),
                const SizedBox(height: 12),
                Expanded(child: _buildGrid()),
                const SizedBox(height: 12),
              ],
            ),
    );
  }

  Widget _buildPaletteRow() {
    return Obx(
      () => SizedBox(
        height: 58,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          children: [
            for (final subject in _subjects)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _buildSubjectChip(subject),
              ),
            if (_subjects.isEmpty)
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  'No subjects found in current timetable.',
                  style: GoogleFonts.lexend(
                    color: mutedColor,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectChip(ForgeSubject subject) {
    return Obx(() {
      final isActive = _activeSubject.value == subject;
      final chipColor = Color(subject.colorValue);

      return GestureDetector(
        onTap: _isEditMode ? () => _activeSubject.value = subject : null,
        onLongPress: () async {
          final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: cardColor,
              title: Text(
                'Delete Subject',
                style: GoogleFonts.lexend(color: textColor),
              ),
              content: Text(
                'Remove "${subject.name}" from the palette? This will also clear it from all slots.',
                style: GoogleFonts.lexend(color: mutedColor),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.lexend(color: mutedColor),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    'Delete',
                    style: GoogleFonts.lexend(color: Colors.red),
                  ),
                ),
              ],
            ),
          );

          if (shouldDelete == true) {
            // Clear subject from all grid slots
            setState(() {
              for (int day = 0; day < _coursesData.length; day++) {
                for (int slot = 0; slot < _coursesData[day].length; slot++) {
                  if (_coursesData[day][slot] == subject.name) {
                    _coursesData[day][slot] = '';
                  }
                }
              }
            });

            // Update active subject if the deleted one was selected
            if (_activeSubject.value == subject) {
              _activeSubject.value =
                  _subjects.firstWhereOrNull((s) => s != subject);
            }

            _subjects.remove(subject);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? chipColor : cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: chipColor),
          ),
          child: Center(
            child: Text(
              subject.name,
              style: GoogleFonts.lexend(
                color: isActive ? Colors.white : chipColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildGrid() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              _buildHeaderRow(),
              for (int dayIndex = 0; dayIndex < _dayRowCount; dayIndex++)
                _buildDayRow(dayIndex),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell(''),
          for (final timeLabel in _timeSlotLabels) _buildHeaderCell(timeLabel),
          if (_isEditMode) _buildAddTimeSlotHeaderCell(),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return SizedBox(
      width: 88,
      height: 44,
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.lexend(
            color: mutedColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDayRow(int dayIndex) {
    final dayLabel = dayIndex < dayLabels.length
        ? dayLabels[dayIndex]
        : 'Day ${dayIndex + 1}';

    return Row(
      children: [
        SizedBox(
          width: 88,
          height: 68,
          child: Center(
            child: Text(
              dayLabel,
              style: GoogleFonts.lexend(
                color: mutedColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ),
        for (int sessionIndex = 0;
            sessionIndex < _timeSlotLabels.length;
            sessionIndex++)
          _buildGridCell(sessionIndex, dayIndex),
        if (_isEditMode) _buildTrailingRowCell(),
      ],
    );
  }

  Widget _buildAddTimeSlotHeaderCell() {
    return SizedBox(
      width: 80,
      height: 44,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: OutlinedButton(
          onPressed: _addTimeSlot,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: accentColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.zero,
          ),
          child: const Icon(Icons.add, color: accentColor, size: 18),
        ),
      ),
    );
  }

  Widget _buildTrailingRowCell() {
    return Container(
      margin: const EdgeInsets.all(4),
      width: 80,
      height: 60,
    );
  }

  Widget _buildGridCell(int sessionIndex, int dayIndex) {
    final slotValue = _coursesData[sessionIndex][dayIndex];
    ForgeSubject? subject;
    for (final item in _subjects) {
      if (item.name == slotValue) {
        subject = item;
        break;
      }
    }

    final isFilled = slotValue.isNotEmpty;
    final fillColor = subject != null ? Color(subject.colorValue) : accentColor;

    return GestureDetector(
      onTap: () {
        if (!_isEditMode) {
          return;
        }

        if (_coursesData[sessionIndex][dayIndex].isNotEmpty) {
          setState(() {
            _coursesData[sessionIndex][dayIndex] = '';
          });
          return;
        }

        final selected = _activeSubject.value;
        if (selected == null) {
          Get.snackbar(
            'Select Subject',
            'Pick or add a subject first.',
            colorText: Colors.white,
          );
          return;
        }

        setState(() {
          _coursesData[sessionIndex][dayIndex] = selected.name;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.all(4),
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: isFilled ? fillColor : bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              slotValue,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.lexend(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showEditDisclaimer() async {
    final shouldProceed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Attendance Reset Warning'),
          content: const Text(
            'Entering edit mode will reset or remove your current attendance data for this timetable. Continue only if you are sure.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    if (shouldProceed == true && mounted) {
      setState(() {
        _isEditMode = true;
      });
    }
  }

  void _addTimeSlot() {
    setState(() {
      _timeSlotLabels = List<String>.from(_timeSlotLabels)
        ..add('Slot ${_timeSlotLabels.length + 1}');

      _coursesData.add(
        List<String>.filled(_dayRowCount, '', growable: true),
      );
    });
  }

  bool get _hasAnyPaintedSlot {
    for (final slotRow in _coursesData) {
      for (final value in slotRow) {
        if (value.isNotEmpty) {
          return true;
        }
      }
    }
    return false;
  }

  List<List<String>> _buildCoursesDataPayload() {
    return _coursesData
        .map(
          (slotRow) => List<String>.from(
            slotRow.map((entry) => entry.trim()),
            growable: false,
          ),
        )
        .toList(growable: false);
  }

  int get _dayRowCount {
    int maxDayCount = 0;
    for (final slotRow in _coursesData) {
      if (slotRow.length > maxDayCount) {
        maxDayCount = slotRow.length;
      }
    }
    return maxDayCount > 0 ? maxDayCount : dayCount;
  }

  Future<void> _submitOnboardingTimetable() async {
    if (widget.onBoardController == null) {
      return;
    }

    if (!_hasAnyPaintedSlot) {
      Get.snackbar(
        'Empty Timetable',
        'Paint at least one slot before saving.',
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await widget.onBoardController!.submit(_buildCoursesDataPayload());

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _saveEditedTimetable() async {
    if (!_hasAnyPaintedSlot) {
      Get.snackbar(
        'Empty Timetable',
        'Paint at least one slot before saving.',
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isSavingEdit = true;
    });

    final didUpdate = await _controller.updateCollectionCoursesData(
      _buildCoursesDataPayload(),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSavingEdit = false;
      if (didUpdate) {
        _isEditMode = false;
      }
    });

    if (didUpdate) {
      await _refreshStatusPage();
      Get.snackbar('Success', 'Timetable updated successfully.',
          colorText: Colors.white);
    }
  }

  Future<void> _refreshStatusPage() async {
    if (!Get.isRegistered<StatusController>()) {
      return;
    }

    final statusController = Get.find<StatusController>();
    await statusController.getStatus(date: statusController.selectedDate.value);
  }

  Future<void> _openSubjectForge() async {
    final subjectNameController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        int selectedColor = _colorInt(colorPalette.first);
        bool showError = false;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Add Subject',
                      style: GoogleFonts.lexend(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    controller: subjectNameController,
                    hintText: 'Subject Name',
                  ),
                  if (showError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Subject name is required',
                        style: GoogleFonts.lexend(
                          color: Colors.red.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 18),
                  Text(
                    'Accent Color',
                    style: GoogleFonts.lexend(
                      color: mutedColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    children: [
                      for (final color in colorPalette)
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedColor = _colorInt(color);
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            width: selectedColor == _colorInt(color) ? 30 : 24,
                            height: selectedColor == _colorInt(color) ? 30 : 24,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: selectedColor == _colorInt(color)
                                  ? Border.all(color: Colors.white, width: 2)
                                  : null,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: accentColor,
                        side: const BorderSide(color: accentColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        final subjectName = subjectNameController.text.trim();
                        if (subjectName.isEmpty) {
                          setModalState(() {
                            showError = true;
                          });
                          return;
                        }

                        final exists = _subjects.any(
                          (subject) =>
                              subject.name.toLowerCase() ==
                              subjectName.toLowerCase(),
                        );

                        if (!exists) {
                          final subject = ForgeSubject(
                            name: subjectName,
                            colorValue: selectedColor,
                          );
                          _subjects.add(subject);
                          _activeSubject.value = subject;
                        } else {
                          _activeSubject.value = _subjects.firstWhere(
                            (subject) =>
                                subject.name.toLowerCase() ==
                                subjectName.toLowerCase(),
                          );
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Add to Palette',
                        style: GoogleFonts.lexend(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.lexend(color: textColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.lexend(color: mutedColor),
        filled: true,
        fillColor: bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
