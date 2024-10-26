import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/pages/exercises_page.dart';
import 'package:meditation_app/pages/profile_page.dart';
import 'package:meditation_app/pages/home_page.dart';
import 'package:meditation_app/pages/signin_page.dart';
import 'package:meditation_app/pages/signup_page.dart';
import 'package:meditation_app/pages/tips_page.dart';
import 'package:meditation_app/providers/MeditationProvider.dart';
import 'package:meditation_app/providers/auth_provider.dart';
import 'package:meditation_app/providers/exercisesProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Meditationprovider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      initialLocation: '/signin', //Main page
      routes: [
        GoRoute(
          path: '/homepage',
          // builder: (context, state) => SignPage(), !!! comment for now while testing home !!!
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: '/signin',
          builder: (context, state) => SigninPage(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => SignupPage(),
        ),
        GoRoute(
          path: '/profilepage',
          builder: (context, state) => ProfilePage(),
        ),
        GoRoute(
          path: '/tips',
          builder: (context, state) => TipsPage(),
        ),
        GoRoute(
          path: '/exercises',
          builder: (context, state) => ExercisePage(),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ))),
    );
  }
}
