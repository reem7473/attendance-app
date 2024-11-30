import 'package:equatable/equatable.dart';

abstract class StudentAttendanceState extends Equatable {
  @override
  List<Object> get props => [];
}

class StudentAttendanceInitial extends StudentAttendanceState {}

class StudentAttendanceLoading extends StudentAttendanceState {}

class StudentAttendanceLoaded extends StudentAttendanceState {
  final List<Map<String, dynamic>> studentAttendance;

  StudentAttendanceLoaded(this.studentAttendance);

  @override
  List<Object> get props => [studentAttendance];
}

class StudentAttendanceError extends StudentAttendanceState {
  final String message;

  StudentAttendanceError(this.message);

  @override
  List<Object> get props => [message];
}
