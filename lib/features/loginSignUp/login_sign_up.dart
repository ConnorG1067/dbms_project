import 'package:dbms_project/features/loginSignUp/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login.dart';

class LoginSignUpPage extends StatefulWidget {
  const LoginSignUpPage({Key? key}) : super(key: key);

  @override
  State<LoginSignUpPage> createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Health App 3000", style: GoogleFonts.teko(color: Colors.blue, fontSize: 56),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 200,
              height: 25,
              child: FilledButton(
                child: const Text('Login'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage())),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 200,
              height: 25,
              child: FilledButton(
                child: const Text('Sign Up'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpPage())),
              ),
            )
          ],
        ),
      ),
    );
  }
}
