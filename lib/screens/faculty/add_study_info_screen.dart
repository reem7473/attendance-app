import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/api_service.dart';
import '../../blocs/faculty_bloc/auth/faculty_auth_cubit.dart';
import '../../blocs/faculty_bloc/auth/faculty_auth_states.dart';
import 'faculty_study_info/display_faculty_study_info_screen.dart';


class AddFacultyStudyInfoScreen extends StatelessWidget {


  final TextEditingController universityNameController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final int faculty_id;

  AddFacultyStudyInfoScreen({super.key, required this.faculty_id});

  

  @override
  Widget build(BuildContext context) {
    // final token = ModalRoute.of(context)!.settings.arguments as String;

    return BlocProvider(
      create: (context) => FacultyAuthCubit(ApiService()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('الرجاء إدخال البيانات'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'الرجاء إدخال البيانات',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: universityNameController,
                  decoration: InputDecoration(
                    labelText: 'اسم الجامعة',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'الرجاء إدخال اسم الجامعة';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: collegeController,
                  decoration: InputDecoration(
                    labelText: 'الكلية',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'الرجاء إدخال اسم الكلية';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: majorController,
                  decoration: InputDecoration(
                    labelText: 'التخصص',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'الرجاء إدخال التخصص';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                BlocConsumer<FacultyAuthCubit, FacultyAuthState>(
                  listener: (context, state) {
                    if (state is AuthAddFacultyStudyInfo) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم إدخال البيانات بنجاح')),
                      );
                      // Navigator.pushNamed(context, '/display_faculty_study_info');
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => DisplayFacultyStudyInfoScreen(faculty_id: state.studyInfo['faculty_id'],))
                      );
                    } else if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('حدث خطأ: ${state.error}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final universityName = universityNameController.text;
                          final college = collegeController.text;
                          final major = majorController.text;

                          context.read<FacultyAuthCubit>().addFacultyStudyInfo(
                            faculty_id,
                            {
                            'university_name': universityName,
                            'college': college,
                            'major': major,
                          }
                          );
                        }
                      },
                      child: Text('إدخال البيانات'),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'يمكنك إضافة المزيد لاحقاً',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
