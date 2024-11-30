import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/student_bloc/navbar/student_cubit.dart';
import '../../../blocs/student_bloc/navbar/student_states.dart';
import 'screens/screens_sub/student_courses_screen.dart';
import 'screens/screens_sub/student_profile_screen.dart';
import 'screens/screens_sub/student_records_screen.dart';

class StudentHomeScreen extends StatelessWidget {
  final int studentStudyInfoId;
  final int studentId;

  const StudentHomeScreen(
      {super.key, required this.studentStudyInfoId, required this.studentId});

  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('تأكيد تسجيل الخروج'),
            content: Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text('تأكيد'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppStudentCubit(
          studentStudyInfoId: studentStudyInfoId, studentId: studentId),
      child: BlocConsumer<AppStudentCubit, AppStudentStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = AppStudentCubit.get(context);
          return WillPopScope(
            onWillPop: () => _onWillPop(context),
            child: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: cubit.screens[cubit.selectedIndexStudent],
                  ),
                ],
              ),
              bottomNavigationBar: ConvexAppBar(
                backgroundColor: Colors.white,
                activeColor: const Color.fromARGB(255, 29, 72, 166),
                color: Color.fromARGB(255, 29, 72, 166),
                elevation: 8.0,
                items: const [
                  TabItem(icon: Icons.home, title: 'الرئيسية'),
                  TabItem(icon: Icons.book, title: 'المقررات'),
                  TabItem(icon: Icons.list, title: 'السجلات'),
                  TabItem(icon: Icons.person, title: 'الملف الشخصي'),
                ],
                initialActiveIndex: cubit.selectedIndexStudent,
                onTap: (index) {
                  cubit.changeIndexStudent(index);
                },
                curve: Curves.easeInOut,
                height: 60.0, // Ensure this height is appropriate
              ),
            ),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  final int studentStudyInfoId;
  final int studentId;

  MainScreen(
      {super.key, required this.studentStudyInfoId, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Text(
                'الرئيسية',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          physics: BouncingScrollPhysics(),
          crossAxisCount: 1,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 2.20,
          children: [
            ShortcutCard(
              icon: Icons.book,
              label: 'المقررات',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentCoursesScreenSub(
                        studentStudyInfoId: studentStudyInfoId),
                  ),
                );
              },
            ),
            ShortcutCard(
              icon: Icons.list,
              label: 'السجلات',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StudentRecordsScreenSub(studentId: studentId),
                  ),
                );
              },
            ),
            ShortcutCard(
              icon: Icons.person,
              label: 'الملف الشخصي',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StudentProfileScreenSub(studentId: studentId),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ShortcutCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onTap;

  const ShortcutCard(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 8,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            gradient: LinearGradient(
              //     colors: [
              //   Color.fromARGB(255, 29, 72, 166),
              //   Color.fromARGB(255, 96, 190, 236),

              // ],
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 232, 232, 232),
              ],

              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 50, color: const Color.fromARGB(255, 29, 72, 166)),
              SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 29, 72, 166),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
