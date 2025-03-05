import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:gps_attendance_system/core/themes/app_colors.dart';

class CustomCalendarTimeline extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const CustomCalendarTimeline({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  State<CustomCalendarTimeline> createState() => _CustomCalendarTimelineState();
}

class _CustomCalendarTimelineState extends State<CustomCalendarTimeline> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return CalendarTimeline(
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2030, 12, 31),
      onDateSelected: (date) {
        setState(() => selectedDate = date);
        widget.onDateSelected(date);
      },
      leftMargin: 20,
      monthColor: Colors.blueGrey,
      dayColor: AppColors.primary,
      activeDayColor: Colors.white,
      activeBackgroundDayColor: AppColors.primary,
      dotColor: Colors.white,
      locale: 'en',
      selectableDayPredicate: (date) => true,
    );
  }
}
