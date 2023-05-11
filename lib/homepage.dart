import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newfb/utils/routes.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final name = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 300,
            ),
            Text(name.phoneNumber!),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.pushNamed(context, MyRoutes.loginpage));
                },
                child: Text('Logout')),
          ],
        ),
      ),
    );
  }
}
