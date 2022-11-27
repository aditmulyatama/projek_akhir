import 'package:flutter/material.dart';
import 'useful_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Forgot Password",
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
              child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 15,
                ),
                textField(
                    "Enter your Email", false, Icons.email, _emailController),
                const SizedBox(
                  height: 15,
                ),
                usefulButton(context, "Sent Email", () {
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(
                    email: _emailController.text,
                  )
                      .then((value) {
                    showNotification(context,
                        "Password reset link sent! Check your email", false);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  }).onError((error, stackTrace) {
                    showNotification(context, error.toString(), true);
                  });
                }),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
