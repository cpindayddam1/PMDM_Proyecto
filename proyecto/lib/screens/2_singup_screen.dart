import 'package:flutter/material.dart';
import 'package:proyecto/widgets/custom_input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return SignUpScreenState();
  }

}

class SignUpScreenState extends State<StatefulWidget> {
  
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final Map<String, String> datosForm = {
      'nombre': '',
      'apellidos': '',
      'email': '',
      'contrasena': '',
      'edad': '',
      'peso': '',
      'nivelActividad': '',
      'patologia': '',
      'farmacos': '',
      'habitos': '',
      // 'embarazo': '',
    };
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro INIZA'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomInputField(
                  labelText: 'Nombre',
                  hintText: 'Nombre del usuario',
                  formProperty: 'nombre',
                  formValues: datosForm,
                  numCaracteresMinimo: 4,
                  obligatorio: true,
                ),
                const SizedBox(height: 30),
                CustomInputField(
                  labelText: 'Apellidos',
                  hintText: 'Apellidos del usuario',
                  formProperty: 'apellidos',
                  formValues: datosForm,
                  numCaracteresMinimo: 4,
                  obligatorio: true,
                ),
                const SizedBox(height: 30),
                CustomInputField(
                  labelText: 'Correo',
                  hintText: 'Correo del usuario',
                  keyboardType: TextInputType.emailAddress,
                  formProperty: 'apellidos',
                  formValues: datosForm,
                  numCaracteresMinimo: 4,
                  obligatorio: true,
                ),
                const SizedBox(height: 30),
                CustomInputField(
                  labelText: 'Contraseña',
                  hintText: 'Contraseña del usuario',
                  formProperty: 'apellidos',
                  formValues: datosForm,
                  obscureText: true,
                  numCaracteresMinimo: 8,
                  obligatorio: true,
                ),
                const SizedBox(height: 30),
                CustomInputField(
                  labelText: 'Edad',
                  hintText: 'Edad del usuario',
                  formProperty: 'edad',
                  formValues: datosForm,
                  keyboardType: TextInputType.number,
                  numCaracteresMinimo: 1,
                  obligatorio: true,
                ),
                const SizedBox(height: 30),
                CustomInputField(
                  labelText: 'Peso',
                  hintText: 'Peso del usuario',
                  formProperty: 'peso',
                  formValues: datosForm,
                  keyboardType: TextInputType.number,
                  numCaracteresMinimo: 2,
                  obligatorio: true,
                ),
                const SizedBox(height: 30),
                const SizedBox(
                  height: 30,
                  child: Text('Nivel de actividad'),
                ),
                //descanso / ligero / moderado / pesado / muy pesado
                DropdownButtonFormField<String>(
                  value: 'moderado',
                  items: const [
                    DropdownMenuItem(value: 'descanso', child: Text('Descanso')),
                    DropdownMenuItem(value: 'ligero', child: Text('Ligero')),
                    DropdownMenuItem(value: 'moderado', child: Text('Moderado')),
                    DropdownMenuItem(value: 'pesado', child: Text('Pesado')),
                    DropdownMenuItem(value: 'muy pesado', child: Text('Muy pesado')),
                  ],
                  onChanged: (value) {
                    datosForm['nivelActividad'] = value ?? 'moderado';
                  }
                ),
                const SizedBox(height: 30),
                CustomInputField(
                  labelText: 'Patologia',
                  hintText: 'Patologia',
                  formProperty: 'patologia',
                  formValues: datosForm,
                  numCaracteresMinimo: 0,
                  obligatorio: false,
                ),
                const SizedBox(height: 30),
                CustomInputField(
                  labelText: 'Fármacos',
                  hintText: 'Fármacos',
                  formProperty: 'farmacos',
                  formValues: datosForm,
                  numCaracteresMinimo: 0,
                  obligatorio: false,
                ),
                const SizedBox(height: 30),
                CustomInputField(
                  labelText: 'Hábitos',
                  hintText: 'Hábitos',
                  formProperty: 'habitos',
                  formValues: datosForm,
                  numCaracteresMinimo: 0,
                  obligatorio: false,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  child: const SizedBox(
                    width: double.infinity,
                    child: Center(child: Text('Guardar'),),
                  ),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error en la creacon del usuario')));
                    }
                  }
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                      onPressed: () {
                        // Navegamos a otra pantalla
                        // Poner una pantalla encima (ofrece volver a la pantalla anterior en el AppBar)
                        // Navigator.pushNamed(context, 'notificaciones');

                        // pushReplacement destruye el stack de pantallas anterior (no puedes volver)
                        Navigator.pushReplacementNamed(
                            context, 'home');
                      },
                      child: const SizedBox(
                          width: double.infinity,
                          child:
                              Center(child: Text('Pantalla API AEMET'))))


              ],
            ),
          ),
        ),
      ),
    );
  }

}