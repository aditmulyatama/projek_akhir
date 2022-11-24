import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projek_akhir/screens/games_list.dart';
import 'package:projek_akhir/signup_page.dart';
import 'package:projek_akhir/useful_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.gamepad_outlined,
                size: 150,
              ),
              const Text(
                "Games Collection",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
              ),
              const SizedBox(
                height: 30,
              ),
              textField(
                  "Enter your email", false, Icons.person, _emailController),
              const SizedBox(
                height: 15,
              ),
              textField("Enter your password", true, Icons.password,
                  _passwordController),
              const SizedBox(
                height: 15,
              ),
              usefulButton(context, true, () {
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text)
                    .then((value) {
                  showNotification(context, "Login Sucess", false);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GamesList()));
                }).onError((error, stackTrace) {
                  showNotification(context, error.toString(), true);
                });
              }),
              signUpOption(),
            ],
          ),
        ),
      ),
    );
  }

  Widget signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Dont Have Account? ",
          style: TextStyle(color: Colors.black87),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const SignUpPage()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }
}
