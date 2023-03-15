import 'package:flutter/material.dart';
import 'package:proyecto/models/notification_provider.dart';
import 'package:proyecto/screens/2_singup_screen.dart';
import 'package:proyecto/screens/3_home_screen.dart';

void main(List<String> args) async {
  // Utilizado para las notificaciones, comprueba que esté todo inicializado
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializamos las configuraciones iniciales de las notificaciones
  await NotificationProvider.notificationProvider.setup();

  runApp(const Iniza());
}

class Iniza extends StatelessWidget{
  const Iniza({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
      // initialRoute: 'singup',
      // routes: {
      //   // 'login' : (context) => const 
      //   'singup' : (context) => const SignUpScreen(),
      //   'home' : (context) => const HomeScreen(),
      // },
    );
  }
}