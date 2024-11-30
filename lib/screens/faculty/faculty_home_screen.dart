import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/faculty_bloc/navbar/faculty_cubit.dart';
import '../../blocs/faculty_bloc/navbar/faculty_states.dart';

class FacultyHomeScreen extends StatelessWidget {
  final int facultyId;

  const FacultyHomeScreen({super.key, required this.facultyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppFacultyCubit(facultyId: facultyId),
      child: BlocConsumer<AppFacultyCubit, AppFacultyStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = AppFacultyCubit.get(context);
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: cubit.widgetOptions[cubit.selectedIndexFaculty],
                ),
              ],
            ),
            bottomNavigationBar: ConvexAppBar(
              backgroundColor: Colors.white,
              activeColor: const Color.fromARGB(255, 29, 72, 166),
              color: Color.fromARGB(255, 29, 72, 166),
              elevation: 8.0,
              items: [
                TabItem(icon: Icons.person, title: 'الشخصي'),
                TabItem(icon: Icons.list, title: 'السجلات'),
                TabItem(icon: Icons.home, title: 'الرئيسية'),
                TabItem(icon: Icons.book, title: 'المقررات'),
                TabItem(icon: Icons.fingerprint, title: 'التحضير'),
              ],
              initialActiveIndex: cubit.selectedIndexFaculty,
              onTap: (index) {
                cubit.changeIndexFaculty(index);
              },
              curve: Curves.easeInOut,
              height: 60.0, // Ensure this height is appropriate
            ),
          );
        },
      ),
    );
  }
}


