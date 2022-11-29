import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Widget textField(String text, bool isPasswordType, IconData icon,
    TextEditingController controller) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: TextFormField(
      validator: (value) => value!.isEmpty ? 'Field cannot be blank' : null,
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.black87,
        ),
        labelText: text,
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    ),
  );
}

Widget usefulButton(BuildContext context, String text, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width / 2,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.red;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

void showNotification(BuildContext context, String message, bool isError) {
  switch (message) {
    case "email-already-in-use":
      message = "Email already used. Go to login page.";
      break;

    case "wrong-password":
      message = "Wrong email/password combination.";
      break;

    case "user-not-found":
      message = "No user found with this email.";
      break;

    case "user-disabled":
      message = "User disabled.";
      break;

    case "operation-not-allowed":
      message = "Too many requests to log into this account.";
      break;

    case "operation-not-allowed":
      message = "Server error, please try again later.";
      break;

    case "invalid-email":
      message = "Email address is invalid.";
      break;
    default:
      message = message;
      break;
  }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: isError ? Colors.redAccent : Colors.green,
    content: Text(message.toString()),
    behavior: SnackBarBehavior.fixed,
    duration: Duration(milliseconds: 600),
  ));
}
