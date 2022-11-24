import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'useful_widgets.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
          "Sign Up",
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: SafeArea(
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
              textField("Enter your password", true, Icons.password,
                  _passwordController),
              const SizedBox(
                height: 15,
              ),
              usefulButton(context, false, () {
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text)
                    .then((value) {
                  showNotification(
                      context, "New account has been signed up", false);
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
    );
  }
}
