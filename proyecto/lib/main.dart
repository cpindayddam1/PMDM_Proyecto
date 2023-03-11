import 'package:flutter/material.dart';
import 'package:proyecto/screens/2_singup_screen.dart';
import 'package:proyecto/screens/3_home_screen.dart';

void main(List<String> args) {
  runApp(const Iniza());
}

class Iniza extends StatelessWidget{
  const Iniza({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: FormularioScreen(),
      initialRoute: 'singup',
      routes: {
        // 'login' : (context) => const 
        'singup' : (context) => const SignUpScreen(),
        'home' : (context) => const HomeScreen(),
      },
    );
  }
}