class AemetRest {
    final String? descripcion;
    final int? estado;
    final String? datos;
    final String? metadatos;

    AemetRest({this.descripcion, this.estado, this.datos, this.metadatos});

    factory AemetRest.fromJson(Map<String, dynamic> json) {
    return AemetRest(
        descripcion: json['descripcion'],
        estado: json['estado'],
        datos: json['datos'],
        metadatos: json['metadatos'],
      );
    }
}


