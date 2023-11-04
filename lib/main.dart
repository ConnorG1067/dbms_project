import 'package:dbms_project/features/loginSignUp/login_sign_up.dart';
import 'package:dbms_project/util/globals.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:postgres/postgres.dart';

Future<void> main() async {
  Globals.database = PostgreSQLConnection("localhost", 5432, "postgres", username: "postgres", password: "COMP3005");
  await Globals.database.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Health App',
      home: const LoginSignUpPage(),
    );
  }
}