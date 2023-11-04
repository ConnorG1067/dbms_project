import 'package:dbms_project/features/home/home_page.dart';
import 'package:dbms_project/features/loginSignUp/login.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart' as material;
import 'package:postgres/postgres.dart';

import '../../util/globals.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isPassVisible = false;
  bool isPassVisibleConfirm = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  String generalError = "";
  String emailError = "";
  String passwordError = "";




  Future<bool> signUpUser(String firstName, String lastName, String email, String password) async {
    // Check if the email already exists within the accounts table
    PostgreSQLResult result = await Globals.database.query("SELECT * FROM accounts WHERE accounts.email='$email'");
    // If it does not then insert the data into the table accordingly
    if(result.isEmpty){
      await Globals.database.query("INSERT INTO accounts (firstName, lastName, email, password) VALUES ('$firstName', '$lastName', '$email', '$password')");
      // return true
      return true;
    }

    // return false indicating the email is a duplicate
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FluentTheme(
      data: FluentThemeData(scaffoldBackgroundColor: Colors.white),
      child: ScaffoldPage(
        content: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Health App 3000", style: GoogleFonts.teko(color: Colors.blue, fontSize: 56),
              ),
              SizedBox(
                width: 200,
                child: InfoLabel(
                  labelStyle: TextStyle(color: Colors.red),
                  label: (generalError.isNotEmpty) ? generalError : "",
                  child: TextBox(
                    controller: firstNameController,
                    placeholder: 'First Name',
                    expands: false,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: InfoLabel(
                  label: '',
                  child: TextBox(
                    controller: lastNameController,
                    placeholder: 'Last Name',
                    expands: false,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: InfoLabel(
                  labelStyle: TextStyle(color: Colors.red),
                  label: (emailError.isNotEmpty) ? emailError : "",
                  child: TextBox(
                    controller: emailController,
                    placeholder: 'Email',
                    expands: false,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: InfoLabel(
                  labelStyle: TextStyle(color: Colors.red),
                  label: (passwordError.isNotEmpty) ? passwordError : "",
                  child: TextBox(
                    controller: passwordController,
                    suffix: IconButton(
                      icon: Icon(!(isPassVisible) ? FluentIcons.view : FluentIcons.hide3),
                      onPressed: () => setState(() => isPassVisible = !isPassVisible),
                    ),
                    obscureText: !(isPassVisible),
                    placeholder: 'Password',
                    expands: false,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: InfoLabel(
                  label: '',
                  child: TextBox(
                    controller: passwordConfirmController,
                    suffix: IconButton(
                      icon: Icon(!(isPassVisibleConfirm) ? FluentIcons.view : FluentIcons.hide3),
                      onPressed: () => setState(() => isPassVisibleConfirm = !isPassVisibleConfirm),
                    ),
                    obscureText: !(isPassVisibleConfirm),
                    placeholder: 'Confirm Password',
                    expands: false,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 200,
                child: FilledButton(
                  child: const Text('Sign Up'),
                  onPressed: () async {
                    // Reset all error strings
                    generalError = passwordError = emailError = "";

                    // Ensure all fields are filled out
                    if(firstNameController.text.isEmpty || lastNameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty || passwordConfirmController.text.isEmpty) {
                      generalError = "All fields are required";
                    // Ensure the passwords are the same
                    }else if(passwordController.text == passwordConfirmController.text){
                      // If the function returns false then notify the user the email is in use
                      if(!(await signUpUser(firstNameController.text, lastNameController.text, emailController.text, passwordController.text))){
                        emailError = "Email already in use";
                      }else{
                        Navigator.of(context).push(material.MaterialPageRoute(builder: (context) => const HomePage()));
                      }
                    // Notify the user the passwords do not match
                    }else{
                      passwordError = "Passwords do not match";
                    }

                    setState(() {});
                  },
                ),
              ),
              HyperlinkButton(
                child: const Text("Already have an account? Login"),
                onPressed: () => Navigator.of(context).push(material.MaterialPageRoute(builder: (context) => const LoginPage())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
