class AemetData
{
  List<Class1>? Property1;
  
  AemetData({this.Property1});

  factory AemetData.fromJson(Map<String, dynamic> json) {
    return AemetData(
        Property1: [

        ]
      );
    }
}

class Class1
{
  Origen? origen;
  DateTime? elaborado;
  String? nombre;
  String? provincia;
  Prediccion? prediccion;
  String? id;
  String? version;

  
}

class Origen
{
  String? productor;
  String? web;
  String? enlace;
  String? language;
  String? copyright;
  String? notaLegal;
}

class Prediccion
{
  List<Dia>? dia;
}

class Dia
{
  List<Estadocielo>? estadoCielo;
  List<Precipitacion>? precipitacion;
  List<Probprecipitacion>? probPrecipitacion;
  List<Probtormenta>? probTormenta;
  List<Nieve>? nieve;
  List<Probnieve>? probNieve;
  List<Temperatura>? temperatura;
  List<Senstermica>? sensTermica;
  List<Humedadrelativa>? humedadRelativa;
  List<Vientoandrachamax>? vientoAndRachaMax;
  DateTime? fecha;
  String? orto;
  String? ocaso;

  
}


class Estadocielo
{
  String? value;
  String? periodo;
  String? descripcion;
}

class Precipitacion
{
  String? value;
  String? periodo;
}

class Probprecipitacion
{
  String? value;
  String? periodo;
}

class Probtormenta
{
  String? value;
  String? periodo;
}

class Nieve
{
  String? value;
  String? periodo;
}

class Probnieve
{
  String? value;
  String? periodo;
}

class Temperatura
{
  String? value;
  String? periodo;
}

class Senstermica
{
  String? value;
  String? periodo;
}

class Humedadrelativa
{
  String? value;
  String? periodo;
}

class Vientoandrachamax
{
  List<String>? direccion;
  List<String>? velocidad;
  String? periodo;
  String? value;
}