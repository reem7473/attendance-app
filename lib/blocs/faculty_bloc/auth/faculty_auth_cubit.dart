

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api_service.dart';
import 'faculty_auth_states.dart';

class FacultyAuthCubit extends Cubit<FacultyAuthState> {
  final ApiService apiService;

  FacultyAuthCubit(this.apiService) : super(AuthInitial());


  // Future<void> registerFaculty(Map<String, dynamic> data) async {
  //   try {
  //     emit(AuthLoading());
  //     final response = await apiService.registerFaculty(data);
  //     emit(AuthRegisteredFaculty(response.data));
  //   } catch (e) {
  //     emit(AuthError(e.toString()));
  //   }
  // }

  Future<void> registerFaculty(Map<String, dynamic> data) async {
  try {
    emit(AuthLoading());
    
    final response = await apiService.registerFaculty(data);

    if (response.statusCode == 201) {
      emit(AuthRegisteredFaculty(response.data)); 
    } else {
      final errorMessage = response.data['message'];
      emit(AuthError('فشل التسجيل  : $errorMessage')); 
    }
  } catch (e) {
    emit(AuthError('حدث خطأ: ${e.toString()}')); 
  }
}



  Future<void> loginFaculty(Map<String, dynamic> data) async {
    try {
      emit(AuthLoading());
      final response = await apiService.loginFaculty(data);
      final facultyId = response.data['id'];
      data['id'] = facultyId;
      emit(AuthLoggedInFaculty(response.data));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> addFacultyStudyInfo(
      int facultyId, Map<String, dynamic> data) async {
    try {
      emit(AuthLoading());
      await apiService.addFacultyStudyInfo(facultyId, data);
      emit(AuthAddFacultyStudyInfo(data));
      await fetchFacultyStudyInfo(facultyId);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> fetchFacultyStudyInfo(int facultyId) async {
    try {
      emit(AuthLoading());
      final response = await apiService.getFacultyStudyInfo(facultyId);
      // emit(StudyInfoLoaded(response.data));
      if (response.data is List) {
        emit(StudyInfoLoaded(response.data));
      } else {
        emit(AuthStudyInfoError(response.data['message']));
      }
    } catch (e) {
      emit(AuthStudyInfoError(e.toString()));
    }
  }


  Future<void> deleteFacultyStudyInfo(int id) async {
    try {
      emit(AuthLoading());
      await apiService.deleteFacultyStudyInfo(id);
      emit(AuthDeleteFacultyStudyInfo());
      await fetchFacultyStudyInfo(id);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updateFacultyStudyInfo(int id, Map<String, String> info) async {
    try {
      emit(AuthLoading());
      await apiService.updateFacultyStudyInfo(id, info);
      emit(AuthUpdatedFacultyStudyInfo());
      await fetchFacultyStudyInfo(id); // Refresh the list after updating
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> addCourse(
      int facultyStudyInfoId, Map<String, dynamic> courseData) async {
    try {
      emit(AuthLoading());
      await apiService.addCourse(facultyStudyInfoId, courseData);
      emit(AuthAddCourseSuccess());
      await getCoursesByFaculty(facultyStudyInfoId);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updateCourse(
      int facultyStudyInfoId, int id, Map<String, dynamic> courseData) async {
    try {
      emit(AuthLoading());
      await apiService.updateCourse(id, courseData);
      emit(AuthUpdateCourseSuccess());
      await getCoursesByFaculty(facultyStudyInfoId);
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> deleteCourse(int facultyStudyInfoId, int id) async {
    emit(AuthLoading());
    try {
      await apiService.deleteCourse(id);
      emit(AuthDeleteCourseSuccess());
      await getCoursesByFaculty(facultyStudyInfoId);
    } catch (error) {
      emit(AuthError(' لايمكن حذف المقرر '));
    }
  }

  Future<void> getCourses() async {
    try {
      emit(AuthLoading());
      final response = await apiService.getCourses();
      emit(AuthGetCoursesSuccess(response.data));
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }


  Future<void> getCoursesByFaculty(int facultyId) async {
    try {
      emit(AuthLoading());
      final response = await apiService.getCoursesByFaculty(facultyId);
      if (response.data is List) {
        emit(AuthGetCoursesFacultySuccess(response.data));
      } else if (response.data is Map && response.data['message'] != null) {
        emit(AuthGetCoursesFacultyEmpty(response.data['message']));
      } else {
        emit(AuthError('Unexpected data format'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> fetchAllFacultyStudyInfoCourses(int facultyId) async {
    try {
      emit(AuthLoading());
      final data = await apiService.getAllFacultyStudyInfoCourses(facultyId);
      emit(AllFacultyStudyInfoCoursesLoaded(data));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> addFacultyStudyInfoCourse(
      int facultyId, Map<String, dynamic> data) async {
    emit(AuthLoading());
    try {
      await apiService.addFacultyStudyInfoCourse(facultyId, data);
      emit(AuthAddFacultyStudyInfoAndCourses());
      await fetchAllFacultyStudyInfoCourses(facultyId);
    } catch (e) {
      emit(AuthError('Failed to add faculty study info and course'));
    }
  }

  Future<void> updateFacultyStudyInfoCourse(
      int id, Map<String, dynamic> data) async {
    emit(AuthLoading());
    try {
      await apiService.updateFacultyStudyInfoCourse(id, data);
      emit(AuthUpdatedFacultyStudyInfoAndCourses());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> deleteFacultyStudyInfoCourse(int id) async {
    emit(AuthLoading());
    try {
      await apiService.deleteFacultyStudyInfoCourse(id);
      emit(AuthDeleteFacultyStudyInfoAndCourses());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

Future<void> addPreparationTime(int courseId, Map<String, dynamic> data) async {
  try {
    emit(PreparationTimeLoading());
    final response = await apiService.addPreparationTime(courseId, data);
    if (response.data != null && response.data['message'] != null) {
      emit(PreparationTimeSuccess(response.data['message']));
      checkPreparationTime(courseId);
    } else {
      emit(AuthError('Unexpected response format'));
    }
  } catch (error) {
    emit(AuthError(error.toString()));
  }
}


  Future<void> checkPreparationTime(int courseId) async {
    emit(AuthLoading());
    final isPreparationTimeSet =
        await apiService.checkPreparationTime(courseId);
    if (isPreparationTimeSet) {
      emit(PreparationTimeAlreadySet());
    } else {
      emit(PreparationTimeNotSet());
    }
  }

  Future<void> editPreparationTime(int preparationTimeId, Map<String, dynamic> data) async {
    try {
      await apiService.editPreparationTime(preparationTimeId, data);
      emit(PreparationTimeUpdated());
    } catch (e) {
      emit(AuthError('Failed to update preparation time: $e'));
    }
  }


  Future<void> fetchAttendanceRecords(int preparationTimesId) async {
  emit(AttendanceRecordsLoading());

  try {
    final response = await apiService.getAttendanceRecords(preparationTimesId);

    // Check if the Cubit is closed before emitting new states
    if (!isClosed) {
      // ignore: unnecessary_null_comparison
      if (response != null) {
        emit(AttendanceRecordsLoaded(response));
      } else {
        emit(AttendanceRecordsError('No records found or unexpected response format.'));
      }
    }
  } catch (e) {
    if (!isClosed) {
      emit(AttendanceRecordsError(e.toString()));
    }
  }
}

}
