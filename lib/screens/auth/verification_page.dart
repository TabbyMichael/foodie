import 'package:flutter/material.dart';

class VerificationPage extends StatelessWidget {
  final String email;

  const VerificationPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Delay popping the page for 7 seconds
    Future.delayed(Duration(seconds: 7), () {
      Navigator.of(context).pop();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'A verification email has been sent to $email. Please check your email and follow the instructions to continue with the sign-up process.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
