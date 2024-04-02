import 'package:flutter/material.dart';
import 'package:foodie/constants.dart';
import 'package:foodie/screens/auth/reset_email_sent_screen.dart';

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({super.key});

  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(); // Add this line

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email Field
          TextFormField(
            controller: _emailController, // Assign the controller here
            validator: emailValidator.call,
            onSaved: (value) {},
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Email Address"),
          ),
          const SizedBox(height: defaultPadding),

          // Reset password Button
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // If all data are correct then save data to out variables
                _formKey.currentState!.save();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ResetEmailSentScreen(email: _emailController.text),
                  ),
                );
              }
            },
            child: const Text("Reset password"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose(); // Dispose the controller
    super.dispose();
  }
}
