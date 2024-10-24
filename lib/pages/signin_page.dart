import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/models/user.dart';
import 'package:meditation_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatelessWidget {
  SigninPage({Key? key}) : super(key: key);
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Sign in"),
            TextField(
              decoration: const InputDecoration(hintText: 'Username'),
              controller: usernameController,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Password'),
              controller: passwordController,
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                var result =
                    await Provider.of<AuthProvider>(context, listen: false)
                        .signin(
                            username: usernameController.text,
                            password: passwordController.text);
                if (result) {
                  context.push("/homepage");
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("please sign up "),
                  ));
                }
              },
              child: const Text("Sign in"),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/signup');
              },
              child: const Text("Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
