import 'package:bloc/bloc.dart';

import '../../../../../services/api_service.dart';
import 'attendance_state.dart';

// part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final ApiService apiService;

  AttendanceCubit(this.apiService) : super(AttendanceInitial());

Future<void> markAttendance(String base64Image, int attendanceRecordId) async {
  emit(AttendanceLoading());
  try {
    final response = await apiService.markAttendance(base64Image, attendanceRecordId);
    if (response.data is Map && response.data['message'] != null) {
      if (response.data['student_name'] != null && response.data['student_num'] != null) {
        emit(AttendanceSuccess(response.data['message'], response.data['student_name'], response.data['student_num']));
      } else {
        emit(AttendanceFailure(response.data['message']));
      }
    } else {
      emit(AttendanceFailure('Unexpected response format'));
    }
  } catch (e) {
    emit(AttendanceFailure(e.toString()));
  }
}

  //   Future<void> markAttendance(String base64Image,  int attendanceRecordId) async {
  //   emit(AttendanceLoading());

  //     final response = await apiService.markAttendance(base64Image,attendanceRecordId);
  //     if(response.data){
  //       emit(AttendanceSuccess(response.data['message'],response.data['student_name'],response.data['student_num']));
  //     }else{
  //       emit(AttendanceFailure(response.data['message']));
  //     }
  // }
  //  void markAttendance(String base64Image, int attendanceRecordId) async {
  //   emit(AttendanceLoading());
  //   try {
  //     final response = await apiService.markAttendance(base64Image, attendanceRecordId);
  //     emit(AttendanceSuccess(response.data['message'], response.data['student_name'], response.data['student_num']));
  //   } catch (e) {
  //     String errorMessage = 'حدث خطأ ما، الرجاء المحاولة لاحقاً';
  //     if (e is DioError) {
  //       if (e.response != null && e.response!.data != null) {
  //         errorMessage = e.response!.data['message'];
  //       } else {
  //         errorMessage = e.response!.data['message'];
  //       }
  //     }
  //     emit(AttendanceFailure(errorMessage));
  //   }
  // }
}
