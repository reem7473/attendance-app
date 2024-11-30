
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../screens/faculty/attendance/fingerprint_preparation_screen.dart';
import '../../../screens/faculty/courses/courses_screen.dart';
import '../../../screens/faculty/main_home/main_home_screen.dart';
import '../../../screens/faculty/profile/profile_screen.dart';
import '../../../screens/faculty/records/records_screen.dart';
import 'faculty_states.dart';

class AppFacultyCubit extends Cubit<AppFacultyStates> {
  final int facultyId;

  AppFacultyCubit({required this.facultyId}) : super(AppInitialFacultyStates());

  static AppFacultyCubit get(context) => BlocProvider.of(context);

  int selectedIndexFaculty = 2;

  List<Widget> get widgetOptions => [
    ProfileScreen(facultyId: facultyId),
    RecordsScreen(faculty_id: facultyId),
    MainHomeScreen(facultyId: facultyId),
    CoursesScreen(facultyId: facultyId),
    FingerprintPreparationScreen(faculty_id: facultyId),
  ];

  void changeIndexFaculty(int index) {
    selectedIndexFaculty = index;
    emit(AppChanageBottomNavbarFacultyState());
  }

}