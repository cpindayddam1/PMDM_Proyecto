import 'package:flutter/material.dart';
import 'package:proyecto/screens/1_formulario_screen.dart';

void main(List<String> args) {
  runApp(const Iniza());
}

class Iniza extends StatelessWidget{
  const Iniza({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FormularioScreen(),
    );
  }
}