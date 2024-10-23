import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/pages/signin_page.dart';
import 'package:meditation_app/pages/signup_page.dart';
import 'package:meditation_app/pages/sign_page.dart'; // Import SignPage
import 'package:meditation_app/providers/MeditationProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MeditationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      initialLocation: '/sign', //Main page
      routes: [
        GoRoute(
          path: '/sign',
          builder: (context, state) => SignPage(),
        ),
        GoRoute(
          path: '/signin',
          builder: (context, state) => SigninPage(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => SignupPage(),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
