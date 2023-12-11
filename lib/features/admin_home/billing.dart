import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import '../../util/globals.dart';

class BillingSystem extends StatefulWidget {
  const BillingSystem({Key? key}) : super(key: key);

  @override
  State<BillingSystem> createState() => _BillingSystemState();
}

class _BillingSystemState extends State<BillingSystem> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: () async {
        return await Globals.database.query("SELECT * FROM transactions");
      }(),
      builder: (BuildContext context, AsyncSnapshot<PostgreSQLResult> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Placeholder for when data is loading
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<PostgreSQLResultRow> transactions = snapshot.data!;

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            PostgreSQLResultRow transaction = transactions[index];

            return Card(
              elevation: 4.0,
              margin: EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ExpandablePanel(
                header: ListTile(
                  title: Text(
                    'Transaction ID: ${transaction.toColumnMap()['transactionid']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Account ID: ${transaction.toColumnMap()['accountid']}',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
                collapsed: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction Type: ${transaction.toColumnMap()['name']}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                expanded: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Transaction Type: ${transaction.toColumnMap()['name']}'),
                      Text('Date: ${transaction.toColumnMap()['date']}'),
                      Text('Cost: \$${transaction.toColumnMap()['cost']}'),
                      Text('Loyalty Points: ${transaction.toColumnMap()['loyaltypts']}'),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
