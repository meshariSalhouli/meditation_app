import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/providers/MeditationProvider.dart';
import 'package:meditation_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

File? _image;

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final meditationProvider =
        Provider.of<Meditationprovider>(context, listen: false);
    _usernameController.text = meditationProvider.username ?? '';
    _emailController.text = meditationProvider.email ?? '';
    _passwordController.text = meditationProvider.password ?? '';
    "assets/images/default.png"; // Load saved profile image
  }

  void _saveProfile(BuildContext context) {
    final meditationProvider =
        Provider.of<Meditationprovider>(context, listen: false);

    // Save the updated profile information
    meditationProvider.updateProfile(_usernameController.text,
        _emailController.text, _passwordController.text
        // Save the selected profile image
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meditationProvider = Provider.of<Meditationprovider>(context);
    final authprovider = context.read<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context
              .go('/homepage'), // Use GoRouter's go to navigate to HomePage
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
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
                    : Container(
                        decoration: BoxDecoration(color: Colors.white),
                        width: 200,
                        height: 200,
                        child: Image.network(authprovider.user!.image),
                      ),
              ),

              // Username Input
              Text(
                authprovider.user!.username,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
