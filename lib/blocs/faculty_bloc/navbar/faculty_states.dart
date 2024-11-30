abstract class AppFacultyStates {}

class AppInitialFacultyStates extends AppFacultyStates{}


class AppChanageBottomNavbarFacultyState extends AppFacultyStates{}

class FacultyAttendanceLoading extends AppFacultyStates {}

class FacultyAttendanceLoaded extends AppFacultyStates {
  final  List<Map<String, dynamic>> studentAttendance;
  FacultyAttendanceLoaded(this.studentAttendance);
}

class FacultyAttendanceError extends AppFacultyStates {
  final String message;
  FacultyAttendanceError(this.message);
}