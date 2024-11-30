
abstract class FacultyAuthState {}

class AuthInitial extends FacultyAuthState {}

class AuthLoading extends FacultyAuthState {}

class PreparationTimeLoading extends FacultyAuthState {}

class PreparationTimeSuccess extends FacultyAuthState {
  final String message;

  PreparationTimeSuccess(this.message);
}

class PreparationTimeNotSet extends FacultyAuthState {}

class PreparationTimeAlreadySet extends FacultyAuthState {}

class PreparationTimeAdded extends FacultyAuthState {}

class PreparationTimeUpdated extends FacultyAuthState {}

class AttendanceRecordsLoading extends FacultyAuthState {}

class AttendanceRecordsLoaded extends FacultyAuthState {
  final List<Map<String, dynamic>> records;

  AttendanceRecordsLoaded(this.records);
}

class AttendanceRecordsError extends FacultyAuthState {
  final String message;

  AttendanceRecordsError(this.message);
}

class AuthRegistered extends FacultyAuthState {
  final Map<String, dynamic> data;

  AuthRegistered(this.data);
}

class AuthRegisteredFaculty extends FacultyAuthState {
  final Map<String, dynamic> data;

  AuthRegisteredFaculty(this.data);
}

class AuthAddFacultyStudyInfo extends FacultyAuthState {
  final Map<String, dynamic> studyInfo;

  AuthAddFacultyStudyInfo(this.studyInfo);
}

class AuthVerified extends FacultyAuthState {
  final Map<String, dynamic> data;

  AuthVerified(this.data);
}

class AuthLoggedIn extends FacultyAuthState {

  final Map<String, dynamic> data;

  AuthLoggedIn(this.data);
}

class AuthLoggedInFaculty extends FacultyAuthState {

  final Map<String, dynamic> data;

  AuthLoggedInFaculty(this.data);
}

class AuthUsersFetched extends FacultyAuthState {
  final List<dynamic> users;

  AuthUsersFetched(this.users);
}

class StudyInfoLoaded extends FacultyAuthState {
  final List<dynamic> studyInfo;

  StudyInfoLoaded(this.studyInfo);
}

class StudyInfoEmpty extends FacultyAuthState {
  final String message;

  StudyInfoEmpty(this.message);
}

class AuthError extends FacultyAuthState {
  final String error;

  AuthError(this.error);
}

class AuthStudyInfoError extends FacultyAuthState {
  final String error;

  AuthStudyInfoError(this.error);
}

class AuthStudyInfoMovedToRecycleBin extends FacultyAuthState {}

class AuthDeleteFacultyStudyInfo extends FacultyAuthState {}

class AuthUpdatedFacultyStudyInfo extends FacultyAuthState {}

class AuthAddCourseSuccess extends FacultyAuthState {
  //   final Map<String, dynamic> data;

  // AuthAddCourseSuccess(this.data);
}

class AuthUpdateCourseSuccess extends FacultyAuthState {
  // final dynamic data;

  // AuthUpdateCourseSuccess(this.data);
}

class AuthDeleteCourseSuccess extends FacultyAuthState {
  // final dynamic data;

  // AuthDeleteCourseSuccess(this.data);

  // @override
  // List<Object> get props => [data];
}

class AuthGetCoursesSuccess extends FacultyAuthState {
  final List<dynamic> dataCourse;

  AuthGetCoursesSuccess(this.dataCourse);
}

class AuthGetCoursesFacultySuccess extends FacultyAuthState {
  final List<dynamic> dataCourse;

  AuthGetCoursesFacultySuccess(this.dataCourse);
}

class AuthGetCoursesFacultyEmpty extends FacultyAuthState {
  final String message;

  AuthGetCoursesFacultyEmpty(this.message);
}

class AllFacultyStudyInfoCoursesLoaded extends FacultyAuthState {
  final List<dynamic> data;

  AllFacultyStudyInfoCoursesLoaded(this.data);
}

class AuthAddFacultyStudyInfoAndCourses extends FacultyAuthState {}

class AuthUpdatedFacultyStudyInfoAndCourses extends FacultyAuthState {}

class AuthDeleteFacultyStudyInfoAndCourses extends FacultyAuthState {}

class AuthAuthenticated extends FacultyAuthState {
  final Map<String, dynamic> user;
  AuthAuthenticated(this.user);
}


class CourseSaved extends FacultyAuthState {}

class StudentCoursesLoaded extends FacultyAuthState {
  final List<Map<String, dynamic>> courses;
  StudentCoursesLoaded(this.courses);
}
