import 'package:flutter/material.dart';
import 'transaction_screen.dart';
import 'drawer_menu.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WARNET'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransactionScreen()),
            );
          },
          child: Text('NEW'),
        ),
      ),
    );
  }
}
