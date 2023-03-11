import 'package:flutter/material.dart';
import 'dart:convert';

UserModel scanModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String scanModelToJson(UserModel data) => json.encode(data.toJson());

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
  
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    nombre: json["nombre"],
    apellidos: json["apellidos"],
    email: json["email"],
    contrasena: json["contrasena"],
    edad: json["edad"],
    peso: json["peso"],
    nivelActividad: json["nivelActividad"],
    patologia: json["patologia"],
    farmacos: json["farmacos"],
    habitos: json["habitos"],
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "apellidos": apellidos,
        "email": email,
        "contrasena": contrasena,
        "edad": edad,
        "peso": peso,
        "nivelActividad": nivelActividad,
        "patologia": patologia,
        "farmacos": farmacos,
        "habitos": habitos
  };

  @override
  String toString() {
    String toString =
        'id: $id\nnombre: $nombre\napellidos: $apellidos\ncorreo: $email\ncontrasena: $contrasena' + 
        '\nEdad: $edad\nPeso: $peso\nNivel de actividad: $nivelActividad\nPatologia: $patologia\Farmacos: $farmacos' + 
        '\nHabitos: $habitos';
    return toString;
  }
}