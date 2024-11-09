import 'package:flutter/material.dart';
import 'package:flutter_ai_app/Screen/home_screen.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Gemini.reInitialize(
      apiKey: "AIzaSyDuF8ruxvJ-CWd7FqaySQfv-qMgcmZApOw", enableDebugging: true);
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
