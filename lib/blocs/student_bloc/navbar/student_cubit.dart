import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../screens/student/student_home/screens/student_courses_screen.dart';
import '../../../screens/student/profile/student_profile_screen.dart';
import '../../../screens/student/student_home/screens/student_records_screen.dart';
import '../../../screens/student/student_home/student_home_screen.dart';
import '../../../services/api_service.dart';
import 'student_states.dart';

class AppStudentCubit extends Cubit<AppStudentStates> {
  final int studentStudyInfoId;
  final int studentId;
  final ApiService _apiService = ApiService();

  AppStudentCubit({required this.studentId, required this.studentStudyInfoId}) : super(AppInitialStudentStates());

  static AppStudentCubit get(context) => BlocProvider.of(context);

  int selectedIndexStudent = 0;

  List<Widget> get screens => [
        MainScreen(studentStudyInfoId: studentStudyInfoId, studentId: studentId,),
        StudentCoursesScreen(studentStudyInfoId: studentStudyInfoId),
        StudentRecordsScreen(studentId: studentId,),
        StudentProfileScreen(studentId: studentId,),
      ];

  void changeIndexStudent(int index) {
    selectedIndexStudent = index;
    emit(AppChanageBottomNavbarStudentState());
  }


  Future<void>  fetchStudentAttendanceData(int studentId) async {
    emit(StudentAttendanceLoading());
    try {
      final studentAttendance = await _apiService.getStudentAttendanceData(studentId);
      emit(StudentAttendanceLoaded(studentAttendance));
    } catch (e) {
      emit(StudentAttendanceError('Failed to fetch records: $e'));
    }
  }
}
