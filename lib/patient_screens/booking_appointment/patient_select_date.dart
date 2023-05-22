import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/patient_screens/booking_appointment/patient_app_details.dart';
import 'package:flutter/material.dart';

class PatientSelectDate extends StatefulWidget {
  const PatientSelectDate(
      {super.key, required this.clinicDocument, required this.doctorDocument});
  final QueryDocumentSnapshot clinicDocument;
  final QueryDocumentSnapshot doctorDocument;

  @override
  State<PatientSelectDate> createState() => _PatientSelectDateState();
}

class _PatientSelectDateState extends State<PatientSelectDate> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final now = DateTime.now();
  late BookingService mockBookingService;

  @override
  void initState() {
    super.initState();
    getCancelledDates();
    mockBookingService = BookingService(
        bookingStart: DateTime(now.year, now.month, now.day, 8, 0),
        bookingEnd: DateTime(now.year, now.month, now.day, 18, 0),
        serviceName: 'Mock Service',
        serviceDuration: 30);
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  List<DateTimeRange> converted = [];

  // DateTime? startDate;
  // DateTime? endDate;

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    // await Future.delayed(const Duration(seconds: 1));
    // converted.add(DateTimeRange(
    //     start: newBooking.bookingStart, end: newBooking.bookingEnd));
    // print(converted);
    // print('**************');
    // startDate = (newBooking.toJson()['bookingStart']).toDate();
    // startDate = (newBooking.toJson()['bookingStart']).toDate();
    // startDate = DateTime.parse(newBooking.toJson()['bookingStart']);
    // endDate = DateTime.parse(newBooking.toJson()['bookingEnd']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PatientAppDetails(
                clinicDocument: widget.clinicDocument,
                doctorDocument: widget.doctorDocument,
                startDate: DateTime.parse(newBooking.toJson()['bookingStart']),
                endDate: DateTime.parse(newBooking.toJson()['bookingEnd']))));
    // firebaseFirestore
    //     .collection('bookings')
    //     .doc(widget.doctorDocument.id)
    //     .collection('appointments')
    //     .add({'startTime': startDate, 'endTime': endDate, 'status': 'booked'});
    // print(startDate);
    // print('//////////////////////');
    // print(newBooking.toJson()['bookingStart']);
    // print('${newBooking.toJson()} has been uploaded');
  }

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    firebaseFirestore
        .collection('doctors')
        .doc(widget.doctorDocument.id)
        .collection('appointments')
        .snapshots()
        .listen((event) {
      for (var item in event.docs) {
        DateTime start = item.get('startTime').toDate();
        DateTime end = item.get('endTime').toDate();
        setState(() {
          converted.add(DateTimeRange(start: start, end: end));
        });
      }
    });

    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    ///take care this is only mock, so if you add today as disabledDays it will still be visible on the first load
    ///disabledDays will properly work with real data
    // DateTime first = now;
    // DateTime tomorrow = now.add(const Duration(days: 1));
    // DateTime second = now.add(const Duration(minutes: 55));
    // DateTime third = now.subtract(const Duration(minutes: 240));
    // DateTime fourth = now.subtract(const Duration(minutes: 500));
    // converted.add(
    //     DateTimeRange(start: first, end: now.add(const Duration(minutes: 30))));
    // converted.add(DateTimeRange(
    //     start: second, end: second.add(const Duration(minutes: 23))));
    // converted.add(DateTimeRange(
    //     start: third, end: third.add(const Duration(minutes: 15))));
    // converted.add(DateTimeRange(
    //     start: fourth, end: fourth.add(const Duration(minutes: 50))));

    // //book whole day example
    // converted.add(DateTimeRange(
    //     start: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 5, 0),
    //     end: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 0)));
    return converted;
  }

  List<DateTimeRange> generatePauseSlots() {
    return [
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 12, 0),
          end: DateTime(now.year, now.month, now.day, 13, 0))
    ];
  }

  List<DateTime> xDates = [];

  getCancelledDates() {
    firebaseFirestore
        .collection('cancelledDates')
        .where('doctorId', isEqualTo: widget.doctorDocument.id)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        DateTime xx = doc.data()['date'].toDate();
        setState(() {
          xDates.add(DateTime(xx.year, xx.month, xx.day));
        });
      }
    });
    return xDates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BookingCalendar(
          bookingService: mockBookingService,
          convertStreamResultToDateTimeRanges: convertStreamResultMock,
          getBookingStream: getBookingStreamMock,
          uploadBooking: uploadBookingMock,
          // pauseSlots: generatePauseSlots(),
          // pauseSlotText: 'LUNCH',
          hideBreakTime: false,
          loadingWidget: const Text('Fetching data...'),
          uploadingWidget: const CircularProgressIndicator(),
          locale: 'en',
          startingDayOfWeek: StartingDayOfWeek.saturday,
          wholeDayIsBookedWidget:
              const Text('Sorry, for this day everything is booked'),
          disabledDates: xDates,
          // disabledDates: [DateTime(2023, 5, 15)],
          // disabledDays: const [16, 19],
        ),
      ),
    );
  }
}
