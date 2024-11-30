import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التحضير'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddAttendanceDialog();
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 5, 
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('اسم الجامعة - التخصص - المستوى - اسم المقرر - الشعبة - الوقت'),
              trailing: PopupMenuButton<String>(
                onSelected: (String result) {
                  
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('تعديل'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('حذف'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'records',
                    child: Text('معاينة السجلات'),
                  ),
                ],
              ),
              onTap: () {
                
              },
            ),
          );
        },
      ),
    );
  }
}

class AddAttendanceDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('إضافة تحضير'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'اسم الجامعة'),
            items: ['جامعة 1', 'جامعة 2']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {},
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'التخصص'),
            items: ['تخصص 1', 'تخصص 2']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {},
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'اسم المقرر'),
            items: ['مقرر 1', 'مقرر 2']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {},
          ),
          TextField(
            decoration: InputDecoration(labelText: 'الشعبة'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'الوقت المخصص للتحضير'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            
            Navigator.of(context).pop();
          },
          child: Text('إضافة'),
        ),
      ],
    );
  }
}
