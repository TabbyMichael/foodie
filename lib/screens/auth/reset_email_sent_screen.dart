import 'package:flutter/material.dart';
import 'package:foodie/components/welcome_text.dart';
import 'package:foodie/constants.dart';

class ResetEmailSentScreen extends StatelessWidget {
  final String email;

  const ResetEmailSentScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeText(
              title: "Reset email sent",
              text:
                  "We have sent instructions to reset your password to $email.",
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Send again"),
            ),
          ],
        ),
      ),
    );
  }
}
