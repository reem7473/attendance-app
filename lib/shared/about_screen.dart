import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حول التطبيق'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                Text(
                  'تطبيق الحضور الذكي',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'تطبيق الحضور الذكي هو حل متكامل يهدف إلى تسهيل عملية تسجيل الحضور في المؤسسات التعليمية. باستخدام أحدث تقنيات التعرف على الوجه، يضمن التطبيق دقة تسجيل الحضور وتقليل التلاعب.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'التواصل معنا:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'لأي استفسارات أو دعم، يرجى التواصل معنا عبر البريد الإلكتروني: support@support.com.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class AboutScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('حول التطبيق'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'تطبيق الحضور الذكي',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'تطبيق الحضور الذكي هو حل متكامل يهدف إلى تسهيل عملية تسجيل الحضور في المؤسسات التعليمية. باستخدام أحدث تقنيات التعرف على الوجه، يضمن التطبيق دقة تسجيل الحضور وتقليل التلاعب.',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black87,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'التواصل معنا:',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'لأي استفسارات أو دعم، يرجى التواصل معنا عبر الواتس',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.blue,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     FaIcon(
//                       FontAwesomeIcons.whatsapp,
//                       color: Colors.green,
//                       size: 30,
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       '+967774336315',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black87,
//                         fontWeight: FontWeight.bold
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
