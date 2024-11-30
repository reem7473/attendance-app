import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('شروط الاستخدام'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'شروط الاستخدام',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'مرحباً بك في تطبيقنا. يرجى قراءة شروط الاستخدام التالية بعناية قبل استخدام التطبيق. باستخدامك لهذا التطبيق، فإنك توافق على الالتزام بهذه الشروط.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '1. قبول الشروط',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'بمجرد استخدامك للتطبيق، فإنك توافق على الالتزام بجميع الشروط والأحكام الواردة هنا. إذا كنت لا توافق على هذه الشروط، فلا تستخدم التطبيق.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '2. تعديلات على الشروط',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'قد نقوم بتحديث شروط الاستخدام من وقت لآخر. سيتم نشر أي تغييرات على هذه الشروط على هذه الصفحة، ويجب عليك مراجعة هذه الشروط بشكل دوري.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '3. الحقوق والملكية ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'جميع حقوق الملكية الفكرية المتعلقة بالتطبيق هي ملك لنا. لا يُسمح لك باستخدام أي محتوى أو معلومات من التطبيق دون الحصول على إذن مسبق.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '4. الخصوصية ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'نحن ملتزمون بحماية خصوصيتك. يرجى مراجعة سياسة الخصوصية الخاصة بنا لمعرفة كيفية جمعنا واستخدامنا وحمايتنا لمعلوماتك.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '5. إخلاء المسؤولية ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'نحن لسنا مسؤولين عن أي أضرار ناتجة عن استخدامك للتطبيق. يتم استخدام التطبيق على مسؤوليتك الخاصة.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '6. اتصل بنا ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'إذا كان لديك أي استفسارات بشأن هذه الشروط، يرجى الاتصال بنا عبر البريد الإلكتروني: support@support.com.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
