import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key});

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final _auth = FirebaseAuth.instance.userChanges().listen((User? user) {
    if (user == null) {
      print("No User");
    } else {
      print("User signed in");
    }
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Hii"),
    );
  }
}
