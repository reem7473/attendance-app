import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/faculty_bloc/auth/faculty_auth_cubit.dart';
import '../../../blocs/faculty_bloc/auth/faculty_auth_states.dart';
import '../../../services/api_service.dart';


class DisplayFacultyStudyInfoScreen extends StatelessWidget {
  final int faculty_id;

  const DisplayFacultyStudyInfoScreen({super.key, required this.faculty_id});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FacultyAuthCubit(ApiService())..fetchFacultyStudyInfo(faculty_id),
      child: Scaffold(
        appBar: AppBar(
          title: Text('معلومات الدراسة'),
        ),
        body: BlocBuilder<FacultyAuthCubit, FacultyAuthState>(
          
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StudyInfoLoaded) {
              return ListView.builder(
                itemCount: state.studyInfo.length,
                itemBuilder: (context, index) {
                  final info = state.studyInfo[index];
                  return ListTile(
                    title: Text(info['university_name']),
                    subtitle: Text('${info['college']} - ${info['major']}'),
                  );
                },
              );
            } else if (state is AuthError) {
              return Center(child: Text('حدث خطأ: ${state.error}'));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}