import 'package:bloc/bloc.dart';
import '../services/api_service.dart';
import 'student_attendance_state.dart';

class StudentAttendanceCubit extends Cubit<StudentAttendanceState> {
  final ApiService apiService;

  StudentAttendanceCubit(this.apiService) : super(StudentAttendanceInitial());

  Future<void> createStudentAttendance(int attendanceRecordId) async {
    try {
      emit(StudentAttendanceLoading());
      await apiService.createStudentAttendance(attendanceRecordId);
      fetchStudentAttendance(attendanceRecordId);
    } catch (e) {
      emit(StudentAttendanceError(e.toString()));
    }
  }

  // Future<void> fetchStudentAttendance(int attendanceRecordId) async {
  //   try {
  //     emit(StudentAttendanceLoading());
  //     final studentAttendance = await apiService.getStudentAttendance(attendanceRecordId);
  //     emit(StudentAttendanceLoaded(studentAttendance));
  //   } catch (e) {
  //     emit(StudentAttendanceError(e.toString()));
  //   }
  // }

Future<void> createAndFetchStudentAttendance(int attendanceRecordId) async {
    try {
      emit(StudentAttendanceLoading());
      await apiService.createStudentAttendance(attendanceRecordId);
      fetchStudentAttendance(attendanceRecordId); // Fetch the attendance records
    } catch (e) {
      emit(StudentAttendanceError(e.toString()));
    }
  }

  Future<void> fetchStudentAttendance(int attendanceRecordId) async {
    try {
      emit(StudentAttendanceLoading());
      final studentAttendance = await apiService.getStudentAttendance(attendanceRecordId);
      emit(StudentAttendanceLoaded(studentAttendance));
    } catch (e) {
      emit(StudentAttendanceError(e.toString()));
      
    }
  }
}
