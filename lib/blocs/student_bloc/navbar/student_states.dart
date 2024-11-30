abstract class AppStudentStates {}

class AppInitialStudentStates extends AppStudentStates{}

class AppChanageBottomNavbarStudentState extends AppStudentStates{}

class StudentAttendanceLoading extends AppStudentStates {}

class StudentAttendanceLoaded extends AppStudentStates {
  final  List<Map<String, dynamic>> studentAttendance;
  StudentAttendanceLoaded(this.studentAttendance);
}

class StudentAttendanceError extends AppStudentStates {
  final String message;
  StudentAttendanceError(this.message);
}