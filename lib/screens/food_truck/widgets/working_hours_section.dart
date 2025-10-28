import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/api/models/working_hours.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/language_provider.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:provider/provider.dart';

class WorkingHoursSection extends StatefulWidget {
  final List<WorkingHours> initialHours;
  final Function(List<WorkingHours>) onHoursChanged;

  const WorkingHoursSection({super.key, required this.initialHours, required this.onHoursChanged});

  @override
  State<WorkingHoursSection> createState() => _WorkingHoursSectionState();
}

class _WorkingHoursSectionState extends State<WorkingHoursSection> {
  late List<WorkingHours> _workingHours;

  @override
  void initState() {
    super.initState();
    _workingHours = List.from(widget.initialHours); // Create a copy to avoid reference issues
  }

  @override
  void didUpdateWidget(WorkingHoursSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update working hours if the parent provides new initial hours
    if (oldWidget.initialHours != widget.initialHours) {
      _workingHours = List.from(widget.initialHours);
    }
  }

  Future<void> _selectTime(BuildContext context, bool isOpening, int index) async {
    final currentTime = isOpening ? _workingHours[index].openingTime : _workingHours[index].closingTime;

    // Use current time if available, otherwise use a reasonable default based on opening/closing
    final defaultTime =
        isOpening
            ? const TimeOfDay(hour: 9, minute: 0) // 9:00 AM for opening
            : const TimeOfDay(hour: 17, minute: 0); // 5:00 PM for closing

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime ?? defaultTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isOpening) {
          _workingHours[index].openingTime = picked;
          // Only show warning if closing time exists and is before opening time
          final closingTime = _workingHours[index].closingTime;
          if (closingTime != null && _isTimeBeforeOrEqual(closingTime, picked)) {
            _showTimeConflictDialog(context, isOpening: true, index: index, selectedTime: picked);
            return; // Don't save the time yet, let user decide
          }
        } else {
          _workingHours[index].closingTime = picked;
          // Only show warning if opening time exists and is after closing time
          final openingTime = _workingHours[index].openingTime;
          if (openingTime != null && _isTimeBeforeOrEqual(picked, openingTime)) {
            _showTimeConflictDialog(context, isOpening: false, index: index, selectedTime: picked);
            return; // Don't save the time yet, let user decide
          }
        }
        widget.onHoursChanged(_workingHours);
      });
    }
  }

  /// Helper method to check if time1 is before or equal to time2
  bool _isTimeBeforeOrEqual(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour < time2.hour) return true;
    if (time1.hour > time2.hour) return false;
    return time1.minute <= time2.minute;
  }

  /// Show dialog when there's a time conflict
  Future<void> _showTimeConflictDialog(
    BuildContext context, {
    required bool isOpening,
    required int index,
    required TimeOfDay selectedTime,
  }) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text(isOpening ? S.of(context).openAfterCloseErrorMsg : S.of(context).openAfterCloseErrorMsg),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop('cancel'), child: Text('Cancel')),
            TextButton(onPressed: () => Navigator.of(context).pop('keep'), child: Text('Keep This Time')),
            TextButton(onPressed: () => Navigator.of(context).pop('adjust'), child: Text('Auto Adjust Other Time')),
          ],
        );
      },
    );

    if (result != null && result != 'cancel') {
      setState(() {
        if (result == 'keep') {
          // Just set the selected time without adjusting the other
          if (isOpening) {
            _workingHours[index].openingTime = selectedTime;
          } else {
            _workingHours[index].closingTime = selectedTime;
          }
        } else if (result == 'adjust') {
          // Set the selected time and adjust the other time
          if (isOpening) {
            _workingHours[index].openingTime = selectedTime;
            // Set closing time to 8 hours after opening time, or 22:00 if that's too late
            final newClosingHour = (selectedTime.hour + 8) > 22 ? 22 : selectedTime.hour + 8;
            _workingHours[index].closingTime = TimeOfDay(hour: newClosingHour, minute: selectedTime.minute);
          } else {
            _workingHours[index].closingTime = selectedTime;
            // Set opening time to 8 hours before closing time, or 6:00 if that's too early
            final newOpeningHour = (selectedTime.hour - 8) < 6 ? 6 : selectedTime.hour - 8;
            _workingHours[index].openingTime = TimeOfDay(hour: newOpeningHour, minute: selectedTime.minute);
          }
        }
        widget.onHoursChanged(_workingHours);
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).workingHour(''), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.small),

        // Render all day rows
        ..._workingHours.asMap().entries.map((entry) {
          final index = entry.key;
          final day = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Consumer<LanguageProvider>(
                        builder: (context, languageProvider, child) {
                          final languageCode = languageProvider.locale.languageCode;
                          final displayDay = getLocalizedDayName(day.day, languageCode);
                          return Text(displayDay, style: TextStyle(fontWeight: FontWeight.bold));
                        },
                      ),
                    ),
                    Column(
                      children: [
                        Checkbox(
                          value: day.isClosed,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          activeColor: Theme.of(context).primaryColor,
                          checkColor: Colors.white,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          side: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
                          onChanged: (value) {
                            setState(() {
                              day.isClosed = value!;
                              if (day.isClosed) {
                                day.openingTime = null;
                                day.closingTime = null;
                              }
                              widget.onHoursChanged(_workingHours);
                            });
                          },
                        ),
                        Text(S.of(context).offDay, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ],
                    ),

                    if (!day.isClosed) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectTime(context, true, index),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: S.of(context).openingTime,
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            ),
                            child: Text(
                              day.openingTime != null ? day.openingTime!.format(context) : S.of(context).selectTime,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectTime(context, false, index),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: S.of(context).closingTime,
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            ),
                            child: Text(
                              day.closingTime != null ? day.closingTime!.format(context) : S.of(context).selectTime,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Add "Apply to all" button ONLY after the first day
                if (index == 0 &&
                    (_workingHours[index].closingTime != null && _workingHours[index].openingTime != null))
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        final firstDay = _workingHours[0];
                        setState(() {
                          for (int i = 1; i < _workingHours.length; i++) {
                            _workingHours[i].isClosed = firstDay.isClosed;
                            _workingHours[i].openingTime = firstDay.openingTime;
                            _workingHours[i].closingTime = firstDay.closingTime;
                          }
                          widget.onHoursChanged(_workingHours);
                        });
                      },
                      icon: Icon(Icons.copy),
                      label: Text(S.of(context).applyToAllDays),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

String getLocalizedDayName(String dayName, String languageCode) {
  // English day names as keys, Arabic as values
  const arabicDays = {
    'Monday': 'الاثنين',
    'Tuesday': 'الثلاثاء',
    'Wednesday': 'الأربعاء',
    'Thursday': 'الخميس',
    'Friday': 'الجمعة',
    'Saturday': 'السبت',
    'Sunday': 'الأحد',
  };

  if (languageCode == 'ar') {
    return arabicDays[dayName] ?? dayName;
  }
  return dayName;
}
