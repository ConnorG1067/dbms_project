import 'package:postgres/postgres.dart';

class Globals{
  static late PostgreSQLConnection database;
  static late Map<String, dynamic> currentAccount;
  static late List<PostgreSQLResultRow> trainers;
  static late List<List<dynamic>> sessions;
}