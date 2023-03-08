import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? icon;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;

  final String formProperty;
  final Map<String, String> formValues;

  //1 - required // 2 - no required
  final bool obligatorio;
  final int numCaracteresMinimo;

  // Function? funcValidacion;

  const CustomInputField({
    Key? key,
    this.hintText,
    this.labelText,
    this.helperText,
    this.icon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    required this.formProperty,
    required this.formValues,
    
    required this.obligatorio,
    required this.numCaracteresMinimo
    // KCZthis.funcValidacion = () {},
    // required int tipoInput
  }) : super(key: key);



  // Function? ss = () {};

  @override
  Widget build(BuildContext context) {
    Function f = (String value) {};
    if (obligatorio) {
      f = (String value) {
        if (value == null) return 'Este campo es requerido';
          return value.length < numCaracteresMinimo ? 'Mínimo de ' + numCaracteresMinimo.toString() + ' letras' : null;
      };
    } 
    // else {
    //   f = (value) {
    //     if (value.length < numCaracteresMinimo) {
    //       return 'Minimo de ' + numCaracteresMinimo.toString() + 'caracteres';
    //     } else {
    //       return null;
    //     }
    //   };
    // }

    return TextFormField(
        autofocus: false,
        initialValue: '',
        textCapitalization: TextCapitalization.words,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: (value) => formValues[formProperty] = value,
        validator: (value) => f(value),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          helperText: helperText,
          // prefixIcon: Icon( Icons.verified_user_outlined ),
          suffixIcon: suffixIcon == null ? null : Icon(suffixIcon),
          icon: icon == null ? null : Icon(icon),
        ));
  }
}