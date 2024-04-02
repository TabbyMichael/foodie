// ignore_for_file: unnecessary_const

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodie/screens/auth/sign_in_screen.dart';
import 'package:foodie/screens/auth/verification_page.dart';
import 'package:foodie/screens/home/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../components/buttons/socal_button.dart';
import '../../components/welcome_text.dart';
import '../../constants.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  SignUpScreen({super.key});

  Future<void> signUpWithEmailAndPassword(BuildContext context) async {
    try {
      // Check if passwords match
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Passwords do not match.'),
        ));
        return;
      }

      // Show platform-specific loading indicator
      if (Platform.isIOS) {
        showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: const SizedBox(
                width: 1500,
                height: 1500,
                child: CupertinoActivityIndicator(),
              ),
            );
          },
        );
      } else if (Platform.isAndroid) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
      }

      // Sign up with email and password using Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // Hide platform-specific loading indicator
      Navigator.of(context).pop();

      // Navigate to verification page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationPage(email: emailController.text),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Hide platform-specific loading indicator
      Navigator.of(context).pop();

      // Handle FirebaseAuth exceptions
      print('FirebaseAuthException: $e');
      String errorMessage = 'Failed to sign up. Please try again.';
      if (e.code == 'email-already-in-use') {
        errorMessage =
            'The email address is already in use by another account.';
      }
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Hide platform-specific loading indicator
      Navigator.of(context).pop();

      // Handle other exceptions
      print('Failed to sign up: $e');
      // Show generic error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign up. Please try again.')),
      );
    }
  }

  Future<void> signUpWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      if (Platform.isIOS) {
        showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CupertinoActivityIndicator(),
              ),
            );
          },
        );
      } else if (Platform.isAndroid) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
      }

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          // Navigate to home screen after successful sign-up
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          throw 'Failed to sign up with Google. Please try again.';
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to sign up with Google. Please try again.')),
      );
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeText(
                title: "Create Account",
                text: "Enter your Name, Email and Password \nfor sign up.",
              ),
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  hintText: "Full Name",
                ),
              ),
              const SizedBox(height: defaultPadding),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email Address",
                ),
              ),
              const SizedBox(height: defaultPadding),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
              ),
              const SizedBox(height: defaultPadding),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Confirm Password",
                ),
              ),
              const SizedBox(height: defaultPadding),
              ElevatedButton(
                onPressed: () => signUpWithEmailAndPassword(context),
                child: const Text("Sign Up"),
              ),
              const SizedBox(height: defaultPadding),
              // Already have an account
              Center(
                child: Text.rich(
                  TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w500),
                    text: "Already have an account? ",
                    children: <TextSpan>[
                      TextSpan(
                        text: "Sign In",
                        style: const TextStyle(color: primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Center(
                child: Text(
                  "By Signing up you agree to our Terms \nConditions & Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: defaultPadding),
              kOrText,
              const SizedBox(height: defaultPadding),
              // Facebook
              SocalButton(
                press: () {},
                text: "Sign Up with Apple",
                color: Color.fromARGB(255, 8, 8, 8),
                icon: Transform.scale(
                  scale: 1.5, // Adjust the scale factor as needed
                  child: SvgPicture.asset(
                    'assets/icons/apple-black-logo-svgrepo-com.svg',
                    colorFilter: const ColorFilter.mode(
                      Color.fromARGB(255, 10, 10, 10),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: defaultPadding),
              // Google
              SocalButton(
                press: () => signUpWithGoogle(
                    context), // Change signInWithGoogle to signUpWithGoogle
                text: "Sign In with Google",
                color: const Color(0xFF4285F4),
                icon: Transform.scale(
                  scale: 1.5, // Adjust the scale factor as needed
                  child: SvgPicture.asset(
                    'assets/icons/google.svg',
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),

              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
