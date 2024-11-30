import 'package:meta/meta.dart';

@immutable
abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceSuccess extends AttendanceState {
  final String message;
  final String studentName;
  final String studentNumber;


  AttendanceSuccess(this.message, this.studentName, this.studentNumber);
}

class AttendanceFailure extends AttendanceState {
  final String error;
  

  AttendanceFailure(this.error);
}
