import 'package:dbms_project/features/home/intro_page.dart';
import 'package:dbms_project/features/home/side_bar_nav.dart';
import 'package:dbms_project/features/loginSignUp/login.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
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
  String accountType = "member"; // Can be member, trainer or admin

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  String generalError = "";
  String emailError = "";
  String passwordError = "";




  Future<bool> signUpUser(String firstName, String lastName, String email, String password, String accountType) async {
    // Check if the email already exists within the accounts table
    PostgreSQLResult result = await Globals.database.query("SELECT * FROM accounts WHERE accounts.email='$email'");

    Globals.trainers = await Globals.database.query("SELECT * FROM accounts WHERE account_type='Trainer'");

    // If it does not then insert the data into the table accordingly
    if(result.isEmpty){
      await Globals.database.query("INSERT INTO accounts (account_type, firstName, lastName, email, password) VALUES ('$accountType', '$firstName', '$lastName', '$email', '$password')");
      Globals.currentAccount = (await Globals.database.query("SELECT * FROM accounts WHERE email='$email' AND password='$password'")).first.toTableColumnMap();
      List<PostgreSQLResultRow> postgreSQLRow = await Globals.database.query("SELECT * FROM sessions WHERE memberid='${Globals.currentAccount['accounts']!['accountid']}'");
      Globals.sessions = List.generate(postgreSQLRow.length, (index) => List.from(postgreSQLRow[index]));
      return true;
    }
    // return false indicating the email is a duplicate
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return fluent.FluentTheme(
      data: fluent.FluentThemeData(scaffoldBackgroundColor: Colors.white),
      child: fluent.ScaffoldPage(
        content: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Health App 3000", style: GoogleFonts.teko(color: Colors.blue, fontSize: 56),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 95,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: (accountType == "member") ? MaterialStateProperty.all(Colors.blue) : MaterialStateProperty.all(Colors.white),
                          foregroundColor: (accountType == "member") ? MaterialStateProperty.all(Colors.white) : MaterialStateProperty.all(Colors.black)
                      ),
                      child: const Text('Member'),
                      onPressed: () {
                        setState(() => accountType = "member");
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 95,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: (accountType == "trainer") ? MaterialStateProperty.all(Colors.blue) : MaterialStateProperty.all(Colors.white),
                          foregroundColor: (accountType == "trainer") ? MaterialStateProperty.all(Colors.white) : MaterialStateProperty.all(Colors.black)
                      ),
                      child: const Text('Trainer'),
                      onPressed: () {
                        setState(() => accountType = "trainer");
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 95,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: (accountType == "admin") ? MaterialStateProperty.all(Colors.blue) : MaterialStateProperty.all(Colors.white),
                          foregroundColor: (accountType == "admin") ? MaterialStateProperty.all(Colors.white) : MaterialStateProperty.all(Colors.black)
                      ),
                      child: Text('Admin'),
                      onPressed: () {
                        setState(() => accountType = "admin");
                      },
                    ),
                  ),
                ],
              ),

              //const SizedBox(height: 10),

              SizedBox(
                width: 200,
                child: fluent.InfoLabel(
                  labelStyle: const TextStyle(color: Colors.red),
                  label: (generalError.isNotEmpty) ? generalError : "",
                  child: fluent.TextBox(
                    controller: firstNameController,
                    placeholder: 'First Name',
                    expands: false,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: fluent.InfoLabel(
                  label: '',
                  child: fluent.TextBox(
                    controller: lastNameController,
                    placeholder: 'Last Name',
                    expands: false,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: fluent.InfoLabel(
                  labelStyle: const TextStyle(color: Colors.red),
                  label: (emailError.isNotEmpty) ? emailError : "",
                  child: fluent.TextBox(
                    controller: emailController,
                    placeholder: 'Email',
                    expands: false,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: fluent.InfoLabel(
                  labelStyle: const TextStyle(color: Colors.red),
                  label: (passwordError.isNotEmpty) ? passwordError : "",
                  child: fluent.TextBox(
                    controller: passwordController,
                    suffix: fluent.IconButton(
                      icon: Icon(!(isPassVisible) ? fluent.FluentIcons.view : fluent.FluentIcons.hide3),
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
                child: fluent.InfoLabel(
                  label: '',
                  child: fluent.TextBox(
                    controller: passwordConfirmController,
                    suffix: fluent.IconButton(
                      icon: Icon(!(isPassVisibleConfirm) ? fluent.FluentIcons.view : fluent.FluentIcons.hide3),
                      onPressed: () => setState(() => isPassVisibleConfirm = !isPassVisibleConfirm),
                    ),
                    obscureText: !(isPassVisibleConfirm),
                    placeholder: 'Confirm Password',
                    expands: false,
                  ),
                ),
              ),

              const SizedBox(height: 15),

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
                      if(!(await signUpUser(firstNameController.text, lastNameController.text, emailController.text, passwordController.text, accountType))){
                        emailError = "Email already in use";
                      }else{
                        Globals.accountType = accountType;
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => IntroPage(accountType: accountType)));
                      }
                    // Notify the user the passwords do not match
                    }else{
                      passwordError = "Passwords do not match";
                    }

                    setState(() {});
                  },
                ),
              ),
              fluent.HyperlinkButton(
                child: const Text("Already have an account? Login"),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
