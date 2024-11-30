
abstract class StudentAuthState {}

class AuthInitial extends StudentAuthState {}

class AuthLoading extends StudentAuthState {}

class studyInfoSet extends StudentAuthState {}

class studyInfoNotSet extends StudentAuthState {}

class saveStudentStudyInfoSuccess extends StudentAuthState {}



class AuthRegistered extends StudentAuthState {
  final Map<String, dynamic> data;

  AuthRegistered(this.data);
}



class AuthLoggedIn extends StudentAuthState {
  // final String token;

  // AuthLoggedIn(this.token);

  final Map<String, dynamic> data;

  AuthLoggedIn(this.data);
}




class StudyInfoLoaded extends StudentAuthState {
  final List<dynamic> studyInfo;

  StudyInfoLoaded(this.studyInfo);
}

class StudyInfoEmpty extends StudentAuthState {
  final String message;

  StudyInfoEmpty(this.message);
}

class AuthError extends StudentAuthState {
  final String error;

  AuthError(this.error);
}

class AuthStudyInfoError extends StudentAuthState {
  final String error;

  AuthStudyInfoError(this.error);
}



class AuthAuthenticated extends StudentAuthState {
  final Map<String, dynamic> user;
  AuthAuthenticated(this.user);
}

// class StudyInfoLoaded extends StudentAuthState {
//   final List<Map<String, dynamic>> studyInfo;
//   StudyInfoLoaded(this.studyInfo);
// }

class CourseSaved extends StudentAuthState {
  final String message;

  CourseSaved(this.message);
}

class StudentCoursesLoaded extends StudentAuthState {
  final List<Map<String, dynamic>> courses;
  StudentCoursesLoaded(this.courses);
}
