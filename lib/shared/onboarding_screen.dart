import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {

  // Future<void> _completeOnboarding(BuildContext context) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('onboardingComplete', true);
  //   Navigator.pushReplacementNamed(context, '/login_options');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 250,
                height: 300,
              ),
              SizedBox(height: 30),
              const Text(
                'أهلا بك\nيمكنك الآن الانضمام إلينا',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2633C6),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login_options');
                  },
                  child: Text('ابدأ'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric( vertical: 10),
                    textStyle: TextStyle(fontSize: 20), // Assuming primary color as per user's preference
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(30.0),
                    // ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
