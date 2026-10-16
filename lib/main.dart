import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

void main() => runApp(const ColdTrackApp());

class ColdTrackApp extends StatelessWidget {
  const ColdTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ColdTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
