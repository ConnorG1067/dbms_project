import 'package:dbms_project/features/home/side_bar_nav.dart';
import 'package:dbms_project/features/loginSignUp/sign_up.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:google_fonts/google_fonts.dart';
import 'package:postgres/postgres.dart';

import '../../util/globals.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Determines if the password is visible
  bool isPassVisible = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String generalError = "";

  Future<bool> loginUser(String email, String password) async {
    PostgreSQLResult result = await Globals.database.query("SELECT * FROM accounts WHERE email='$email' AND password='$password'");
    Globals.trainers = await Globals.database.query("SELECT * FROM accounts WHERE account_type='Trainer'");

    List<PostgreSQLResultRow> postgreSQLRow = await Globals.database.query("SELECT * FROM sessions WHERE memberid='${result.first.toTableColumnMap()['accounts']!['accountid']}'");
    Globals.sessions = List.generate(postgreSQLRow.length, (index) => List.from(postgreSQLRow[index]));
    print(Globals.sessions);
    if(result.isNotEmpty){
      Globals.currentAccount = result.first.toTableColumnMap();
      return true;
    }
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
                    controller: emailController,
                    placeholder: 'Email',
                    expands: false,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: InfoLabel(
                  label: '',
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
              const SizedBox(height: 15),
              SizedBox(
                width: 200,
                child: FilledButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    if(emailController.text.isEmpty || passwordController.text.isEmpty){
                      setState(() => generalError = "All fields are required");
                    }else{
                      if(await loginUser(emailController.text, passwordController.text)){
                        Navigator.of(context).push(material.MaterialPageRoute(builder: (context) => const SideBarNav()));
                      }else{
                        setState(() => generalError = "Credentials are invalid");
                      }
                    }
                  },
                ),
              ),
              HyperlinkButton(
                child: const Text("Don't have an account? Sign up"),
                onPressed: () => Navigator.of(context).push(material.MaterialPageRoute(builder: (context) => const SignUpPage())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
