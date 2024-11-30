import 'package:attendance_app/screens/faculty/attendance/fingerprint_authentication/bloc/attendance_cubit.dart';
import 'package:attendance_app/services/student_attendance_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/faculty_bloc/auth/faculty_auth_cubit.dart';
import 'blocs/faculty_bloc/navbar/faculty_cubit.dart';
import 'blocs/student_bloc/auth/student_auth_cubit.dart';
import 'blocs/student_bloc/navbar/student_cubit.dart'; 
import 'screens/student/face_registration/bloc/registration_cubit.dart';
import 'screens/student/profile/bloc/profile_cubit.dart';
import 'services/api_service.dart';
import 'screens/faculty/profile/bloc/profile_cubit.dart';
import 'services/records.dart';

class BlocProviders {
  static List<BlocProvider> getProviders() {
      final int studentStudyInfoId=0;
      final int facultyId=0;

    return [
      BlocProvider<FacultyAuthCubit>(
        create: (context) => FacultyAuthCubit(ApiService()),
      ),
      BlocProvider<StudentAuthCubit>(
        create: (context) => StudentAuthCubit(ApiService()),
      ),
      BlocProvider<AppStudentCubit>(
        create: (context) => AppStudentCubit(studentStudyInfoId:studentStudyInfoId, studentId: studentStudyInfoId),
      ),
      BlocProvider<AppFacultyCubit>(
        create: (context) => AppFacultyCubit(facultyId: facultyId),
      ),
      BlocProvider<FacultyAuthCubit>(
        create: (context) => FacultyAuthCubit(ApiService())..fetchFacultyStudyInfo(facultyId),
      ),

      BlocProvider<RecordsCubit>(
        create: (context) => RecordsCubit(),
      ),
      BlocProvider<ProfileCubit>(
        create: (context) => ProfileCubit(ApiService()),
      ),
      BlocProvider<ProfileStudentCubit>(
        create: (context) => ProfileStudentCubit(ApiService()),
      ),
      BlocProvider<RegistrationCubit>(
          create: (context) => RegistrationCubit(ApiService()),
        ),
      BlocProvider<AttendanceCubit>(
          create: (context) => AttendanceCubit(ApiService()),
        ),
       BlocProvider<StudentAttendanceCubit>(
          create: (context) => StudentAttendanceCubit(ApiService()),
        ),
    ];

    
  }
}
