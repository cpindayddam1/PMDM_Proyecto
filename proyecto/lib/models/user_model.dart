import 'package:flutter/material.dart';
import 'dart:convert';

class UserModel {

  UserModel({
    this.id,
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.contrasena,
    required this.edad,
    required this.peso,
    required this.nivelActividad,
    this.patologia = '',
    this.farmacos = '',
    this.habitos = '',
    // this.embarazo,
  });

  int? id;
  String nombre;
  String apellidos;
  String email;
  String contrasena;
  
  int edad;
  double peso;
  String nivelActividad; //descanso / ligero / moderado / pesado / muy pesado

  String? patologia;
  String? farmacos;
  String? habitos;
  // bool? embarazo = false;
  

  

}