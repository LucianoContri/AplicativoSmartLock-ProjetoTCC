import 'package:flutter/material.dart';
import 'package:smartlock/components/AuthForm.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      appBar: AppBar(
        title: const Text(
          'Smart Lock',
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Image.asset('assets/images/icon2.png'),
            ),
            AuthForm(),
          ],
        ),
      ),
    );
  }
}
