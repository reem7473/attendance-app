import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../blocs/faculty_bloc/auth/faculty_auth_cubit.dart';
import '../../../../blocs/faculty_bloc/auth/faculty_auth_states.dart';
import '../../../../services/api_service.dart';

class EditPreparationTimeDialog extends StatefulWidget {
  final int preparationTimeId;
  // final int courseId;
  
  EditPreparationTimeDialog({
    required this.preparationTimeId,
    // required this.courseId,
  });

  @override
  _EditPreparationTimeDialogState createState() => _EditPreparationTimeDialogState();
}

class _EditPreparationTimeDialogState extends State<EditPreparationTimeDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late List<bool> _daysOfWeek;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _daysOfWeek = List.generate(7, (index) => false);
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    
    if (widget.preparationTimeId != -1) {
      _loadPreparationTime();
    }
  }

  void _loadPreparationTime() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final Map<String, dynamic> preparationTimeData = await ApiService().getPreparationTime(widget.preparationTimeId);
      
      setState(() {
        _startDateController.text = preparationTimeData['start_date'];
        _endDateController.text = preparationTimeData['end_date'];
        List<int> daysOfWeek = preparationTimeData['days_of_week'].cast<int>();
        _daysOfWeek = daysOfWeek.map((value) => value == 1).toList();
        _startTimeController.text = preparationTimeData['start_time'];
        _endTimeController.text = preparationTimeData['end_time'];
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load preparation time details')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('اضافة وقت التحضير'),
      content: _isLoading
          ? Center(child: CircularProgressIndicator())
          : BlocConsumer<FacultyAuthCubit, FacultyAuthState>(
              listener: (context, state) {
                if (state is PreparationTimeUpdated) {
                  Navigator.of(context).pop();
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _startDateController,
                          decoration: InputDecoration(labelText: 'Start Date'),
                          onTap: () async {
                             FocusScope.of(context).requestFocus(FocusNode());
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
                              return 'Please enter start date';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _endDateController,
                          decoration: InputDecoration(labelText: 'End Date'),
                          onTap: () async {
                             FocusScope.of(context).requestFocus(FocusNode());
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
                              return 'Please enter end date';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        Text('Select days of week:'),
                        Wrap(
                          spacing: 10.0,
                          children: List.generate(7, (index) {
                            return ChoiceChip(
                              //  label: Text(['السبت', 'الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'][index]),
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
                          decoration: InputDecoration(labelText: 'Start Time'),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
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
                              return 'Please enter start time';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _endTimeController,
                          decoration: InputDecoration(labelText: 'End Time'),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
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
                              return 'Please enter end time';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      actions: [
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
  
                context.read<FacultyAuthCubit>().editPreparationTime(widget.preparationTimeId, data);
              
            }
          },
          child: Text('حفظ'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('الغاء'),
        ),
      ],
    );
  }
}
