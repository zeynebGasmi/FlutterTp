import 'package:flutter/material.dart';


class Panier extends StatelessWidget {
  final String? userId;

  Panier({this.userId});

  @override
  Widget build(BuildContext context) {
    // Use userId as needed in the Panier screen
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
      ),
      body: Container(
        child: Center(
          child: Text('User ID: $userId'),
        ),
      ),
    );
  }
}