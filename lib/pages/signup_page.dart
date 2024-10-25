import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/models/user.dart';
import 'package:meditation_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();
  File? _image;
  final _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up"),
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text("Sign up"),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_add,
                      color: Colors.blueAccent), // Icon added
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a username' : null,
                controller: usernameController,
              ),
              Gap(10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.lock, color: Colors.blueAccent), // Icon added
                ),
                obscureText: true,
                controller: passwordController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a password' : null,
              ),
              Gap(10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline,
                      color: Colors.blueAccent), // Icon added
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Provider.of<AuthProvider>(context, listen: false).signup(
                        username: usernameController.text,
                        password: passwordController.text,
                        imagePath: _image?.path,
                        defaultImage: "https://i.sstatic.net/l60Hf.png");

                    context.pop();
                  }
                },
                child: const Text("Sign Up"),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        _image = File(image!.path);
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(color: Colors.white),
                      child: _image != null
                          ? Image.file(
                              _image!,
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.fitHeight,
                            )
                          : //TODO render default image
                          Container(
                              decoration: BoxDecoration(color: Colors.white),
                              width: 200,
                              height: 200,
                              child: Image.network(
                                  "https://i.sstatic.net/l60Hf.png"),
                            ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Image"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
