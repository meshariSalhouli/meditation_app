import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to the Meditation App",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.push('/signin');
              },
              child: const Text("Sign In"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.push('/signup');
              },
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
