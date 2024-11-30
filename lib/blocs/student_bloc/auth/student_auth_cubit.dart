import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api_service.dart';
import 'student_auth_states.dart';

class StudentAuthCubit extends Cubit<StudentAuthState> {
  final ApiService apiService;

  StudentAuthCubit(this.apiService) : super(AuthInitial());

Future<void> registerUser(Map<String, dynamic> data) async {
  try {
    emit(AuthLoading());
    
    final response = await apiService.registerStudent(data);

    if (response.statusCode == 201) {
      emit(AuthRegistered(response.data)); 
    } else {
      final errorMessage = response.data['message'];
      emit(AuthError('تسجيل الطالب فشل: $errorMessage'));
    }
  } catch (e) {
    emit(AuthError('حدث خطأ: ${e.toString()}')); 
  }
}

  Future<void> saveStudentStudyInfo(Map<String, dynamic> data) async {
    try {
      emit(AuthLoading());
      final response = await apiService.saveStudentStudyInfo(data);
      final studentStudyInfoId = response.data['id'];
      data['id'] = studentStudyInfoId;
      emit(AuthAuthenticated(data));
    } catch (e) {
      emit(AuthError('Failed to save study info'));
    }
  }


  Future<void> checkStudentStudyInfo(int studentId) async {
    try {
      emit(AuthLoading());
      final response = await apiService.getStudentStudyInfo(studentId);
      if (response.isNotEmpty) {
        emit(AuthAuthenticated(response));
      } else {
        emit(studyInfoNotSet());
      }
    } catch (e) {
      emit(AuthError('Failed to check study info'));
    }
  }

  // Future<void> saveStudentCourse(
  //     int studentStudyInfoId, Map<String, dynamic> data) async {
  //   try {
  //     emit(AuthLoading());
  //     await apiService.saveStudentCourse(studentStudyInfoId, data);
  //     emit(CourseSaved());
  //   } catch (e) {
  //     emit(AuthError('Failed to save student course'));
  //   }
  // }



  Future<void> getStudentCourses(int studentId) async {
    try {
      emit(AuthLoading());
      final courses = await apiService.getStudentCourses(studentId);
      emit(StudentCoursesLoaded(courses));
    } catch (e) {
      emit(AuthError('Failed to get student courses'));
    }
  }
  
  Future<void> saveStudentCourse(
      int studentStudyInfoId, Map<String, dynamic> data) async {
    try {
      emit(AuthLoading());

      final response = await apiService.saveStudentCourse(
        studentStudyInfoId,
        data,
      );

      if (response.statusCode != 201) {
        final message = response.data['error'] ?? 'Failed to save student course';
        emit(AuthError(message));
      } else {
        emit(CourseSaved(response.data['message']));
      }
    } catch (e) {
      emit(AuthError('Failed to save student course: $e'));
    }
  }


  Future<void> loginUser(Map<String, dynamic> data) async {
    try {
      emit(AuthLoading());
      final response = await apiService.loginStudent(data);
      final studentId = response.data['id'];
      data['id'] = studentId;
      emit(AuthLoggedIn(data));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> fetchAllFacultyStudyInfo() async {
    try {
      emit(AuthLoading());
      final response = await apiService.getAllFacultyStudyInfo();
      emit(StudyInfoLoaded(response.data));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }


}
