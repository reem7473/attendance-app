import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../blocs/faculty_bloc/auth/faculty_auth_cubit.dart';
import '../../../../blocs/faculty_bloc/auth/faculty_auth_states.dart';
import '../attendance_records_tab.dart';

class PreparationTimeScreen extends StatefulWidget {
  final int courseId;

  PreparationTimeScreen({required this.courseId});

  @override
  _PreparationTimeScreenState createState() => _PreparationTimeScreenState();
}

class _PreparationTimeScreenState extends State<PreparationTimeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final List<bool> _daysOfWeek = List.generate(7, (index) => false);
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  
  // Create FocusNodes for each TextFormField
  final FocusNode _startDateFocusNode = FocusNode();
  final FocusNode _endDateFocusNode = FocusNode();
  final FocusNode _startTimeFocusNode = FocusNode();
  final FocusNode _endTimeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<FacultyAuthCubit>().checkPreparationTime(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تخصيص وقت التحضير'),
      ),
      body: BlocConsumer<FacultyAuthCubit, FacultyAuthState>(
        listener: (context, state) {
          if (state is PreparationTimeSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AttendanceRecordsTab(preparationTimesId:widget.courseId ,)),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is PreparationTimeAlreadySet) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AttendanceRecordsTab(preparationTimesId: widget.courseId,)),
              );
            });
            return Center(child: CircularProgressIndicator());
          }

          if (state is PreparationTimeNotSet) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _startDateController,
                      focusNode: _startDateFocusNode,
                      decoration: InputDecoration(labelText: 'تحديد تاريخ البدء'),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode()); // Remove focus
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          setState(() {
                            _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال تاريخ البدء';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _endDateController,
                      focusNode: _endDateFocusNode,
                      decoration: InputDecoration(labelText: 'تحديد تاريخ الانتهاء'),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode()); // Remove focus
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          setState(() {
                            _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال تاريخ الانتهاء';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text('تخصيص الأيام خلال فترة التاريخ:'),
                    Wrap(
                      spacing: 10.0,
                      children: List.generate(7, (index) {
                        return ChoiceChip(
                          label: Text(['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'][index]),
                          selected: _daysOfWeek[index],
                          onSelected: (selected) {
                            setState(() {
                              _daysOfWeek[index] = selected;
                            });
                          },
                        );
                      }),
                    ),
                    TextFormField(
                      controller: _startTimeController,
                      focusNode: _startTimeFocusNode,
                      decoration: InputDecoration(labelText: 'تحديد وقت البدء'),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode()); // Remove focus
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _startTimeController.text = picked.format(context);
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال وقت البدء';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _endTimeController,
                      focusNode: _endTimeFocusNode,
                      decoration: InputDecoration(labelText: 'تحديد وقت الانتهاء'),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode()); // Remove focus
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _endTimeController.text = picked.format(context);
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال وقت الانتهاء';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final data = {
                            'start_date': _startDateController.text,
                            'end_date': _endDateController.text,
                            'days_of_week': _daysOfWeek.asMap().entries
                                .where((entry) => entry.value)
                                .map((entry) => entry.key)
                                .join(','),
                            'start_time': _startTimeController.text,
                            'end_time': _endTimeController.text,
                          };
                          context.read<FacultyAuthCubit>().addPreparationTime(widget.courseId, data);
                        }
                      },
                      child: Text('إضافة'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
