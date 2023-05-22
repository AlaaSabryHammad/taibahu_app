import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:taibahu_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class BookWidget extends StatefulWidget {
  const BookWidget({super.key, required this.onChoose});
  final Function onChoose;

  @override
  State<BookWidget> createState() => _BookWidgetState();
}

class _BookWidgetState extends State<BookWidget> {
  @override
  void initState() {
    super.initState();
    // _resetSelectedDate();
  }

  DateTime now = DateTime.now();
  DateTime d = Jiffy().add(months: 3).dateTime;
  // late DateTime _selectedDate;
  // void _resetSelectedDate() {
  //   _selectedDate = DateTime.now().add(const Duration(days: 2));
  // }

  @override
  Widget build(BuildContext context) {
    return CalendarTimeline(
      showYears: true,
      initialDate: DateTime(now.year, now.month, now.day),
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(d.year, d.month, d.day),
      // lastDate: DateTime(now.year, 12, 30),
      onDateSelected: (date) => widget.onChoose(date),
      leftMargin: 20,
      monthColor: Colors.blueGrey,
      dayColor: Colors.teal[200],
      activeDayColor: Colors.white,
      activeBackgroundDayColor: mainColor,
      dotsColor: const Color(0xFF333A47),
      selectableDayPredicate: (date) => date.day != 23,
      locale: 'en_ISO',
    );
  }
}
