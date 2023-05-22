import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taibahu_app/doctor_screens/refer_screens/refer_app_details.dart';
import 'package:flutter/material.dart';

class ReferSelectApp extends StatefulWidget {
  const ReferSelectApp(
      {super.key,
      required this.clinicDocument,
      required this.doctorDocument,
      // required this.patientName,
      // required this.patientId,
      required this.oldApp, required this.patient});
  final QueryDocumentSnapshot clinicDocument;
  final QueryDocumentSnapshot doctorDocument;
  final QueryDocumentSnapshot oldApp;
  final Map<String, dynamic> patient;

  // final String patientName, patientId;

  @override
  State<ReferSelectApp> createState() => _ReferSelectAppState();
}

class _ReferSelectAppState extends State<ReferSelectApp> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final now = DateTime.now();
  late BookingService mockBookingService;

  @override
  void initState() {
    super.initState();
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

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReferAppDetails(
                  clinicDocument: widget.clinicDocument,
                  doctorDocument: widget.doctorDocument,
                  startDate:
                      DateTime.parse(newBooking.toJson()['bookingStart']),
                  endDate: DateTime.parse(newBooking.toJson()['bookingEnd']), patient: widget.patient,
                  // patientId: widget.patientId,
                  // patientName: widget.patientName,
                  oldApp: widget.oldApp,
                )));
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
    return converted;
  }

  List<DateTimeRange> generatePauseSlots() {
    return [
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 12, 0),
          end: DateTime(now.year, now.month, now.day, 13, 0))
    ];
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
          // disabledDates: [DateTime(2023, 5, 15)],
          // disabledDays: const [16, 19],
        ),
      ),
    );
  }
}
