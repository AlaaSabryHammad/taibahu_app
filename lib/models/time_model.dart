class TimeModel {
  final int houre, min,realHr,realMin;
  final String st;

  TimeModel({required this.houre, required this.min, required this.st, required this.realHr, required this.realMin});
}

List<TimeModel> bookingTimes = [
  TimeModel(houre: 09, min: 00, st: 'AM', realHr: 09, realMin: 00),
  TimeModel(houre: 09, min: 30, st: 'AM', realHr: 09, realMin: 30),
  TimeModel(houre: 10, min: 00, st: 'AM', realHr: 10, realMin: 00),
  TimeModel(houre: 10, min: 30, st: 'AM', realHr: 10, realMin: 30),
  TimeModel(houre: 11, min: 00, st: 'AM', realHr: 11, realMin: 00),
  TimeModel(houre: 11, min: 30, st: 'AM', realHr: 11, realMin: 30),
  TimeModel(houre: 12, min: 00, st: 'PM', realHr: 12, realMin: 00),
  TimeModel(houre: 12, min: 30, st: 'PM', realHr: 12, realMin: 30),
  TimeModel(houre: 01, min: 00, st: 'PM', realHr: 13, realMin: 00),
  TimeModel(houre: 01, min: 30, st: 'PM', realHr: 13, realMin: 30),
  TimeModel(houre: 02, min: 00, st: 'PM', realHr: 14, realMin: 00),
  TimeModel(houre: 02, min: 30, st: 'PM', realHr: 14, realMin: 30),
  TimeModel(houre: 03, min: 00, st: 'PM', realHr: 15, realMin: 00),
  TimeModel(houre: 03, min: 30, st: 'PM', realHr: 15, realMin: 30),
  TimeModel(houre: 04, min: 00, st: 'PM', realHr: 16, realMin: 00),
  TimeModel(houre: 04, min: 30, st: 'PM', realHr: 16, realMin: 30),
  TimeModel(houre: 05, min: 00, st: 'PM', realHr: 17, realMin: 00),
  TimeModel(houre: 05, min: 30, st: 'PM', realHr: 17, realMin: 30),
  TimeModel(houre: 06, min: 00, st: 'PM', realHr: 18, realMin: 00),
  TimeModel(houre: 06, min: 30, st: 'PM', realHr: 18, realMin: 30),
  TimeModel(houre: 07, min: 00, st: 'PM', realHr: 19, realMin: 00),
  TimeModel(houre: 07, min: 30, st: 'PM', realHr: 19, realMin: 30),
  TimeModel(houre: 08, min: 00, st: 'PM', realHr: 20, realMin: 00),
  TimeModel(houre: 08, min: 30, st: 'PM', realHr: 20, realMin: 30),
];
