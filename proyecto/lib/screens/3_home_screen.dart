import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto/models/aemet_rest.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // String str = "";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data Example'),
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder<String>(
              future: obtenerRecomendaciones(1, '', true),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // Por defecto, muestra un loading spinner
                return const CircularProgressIndicator();
              },
            ),
            
          ],
        ),
      ),
    );
  }



  // Future<AemetRest> fetchAemetRest(int? codMun) async {
  //   String apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjcGluZGF5ZGVsQGVkdWNhY2lvbi5uYXZhcnJhLmVzIiwianRpIjoiZDMzNzQ4YWYtMzBiMC00ZWU5LWFmOGQtMjgzNDM2YjhkMWIxIiwiaXNzIjoiQUVNRVQiLCJpYXQiOjE2Nzg0MDg0MTAsInVzZXJJZCI6ImQzMzc0OGFmLTMwYjAtNGVlOS1hZjhkLTI4MzQzNmI4ZDFiMSIsInJvbGUiOiIifQ.hZu4JaDTzSz854rZZR2D2pjZNgqJy0EpPkehi0cJQ8M';
  //   int codigoMunicipio = 27025;

  //   String urlStr = 'https://opendata.aemet.es/opendata/api/prediccion/especifica/municipio/horaria/' + codigoMunicipio.toString();
  //   urlStr += '/?api_key=' + apiKey;
  //   //https://opendata.aemet.es/opendata/api/prediccion/especifica/municipio/horaria/27025/?api_key=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjcGluZGF5ZGVsQGVkdWNhY2lvbi5uYXZhcnJhLmVzIiwianRpIjoiZDMzNzQ4YWYtMzBiMC00ZWU5LWFmOGQtMjgzNDM2YjhkMWIxIiwiaXNzIjoiQUVNRVQiLCJpYXQiOjE2Nzg0MDg0MTAsInVzZXJJZCI6ImQzMzc0OGFmLTMwYjAtNGVlOS1hZjhkLTI4MzQzNmI4ZDFiMSIsInJvbGUiOiIifQ.hZu4JaDTzSz854rZZR2D2pjZNgqJy0EpPkehi0cJQ8M
  //   final response = await http.get(Uri.parse(urlStr));

  //   if (response.statusCode == 200) {
  //     // Si la llamada al servidor fue exitosa, analiza el JSON
  //     return AemetRest.fromJson(json.decode(response.body));
  //   } else {
  //     // Si la llamada no fue exitosa, lanza un error.
  //     throw Exception('Failed to load post');
  //   }
  // }


//indicar mensajes indicativos
  Future<String> obtenerUrlDatosAemet(int codMun) async {
    String apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjcGluZGF5ZGVsQGVkdWNhY2lvbi5uYXZhcnJhLmVzIiwianRpIjoiZDMzNzQ4YWYtMzBiMC00ZWU5LWFmOGQtMjgzNDM2YjhkMWIxIiwiaXNzIjoiQUVNRVQiLCJpYXQiOjE2Nzg0MDg0MTAsInVzZXJJZCI6ImQzMzc0OGFmLTMwYjAtNGVlOS1hZjhkLTI4MzQzNmI4ZDFiMSIsInJvbGUiOiIifQ.hZu4JaDTzSz854rZZR2D2pjZNgqJy0EpPkehi0cJQ8M';
    codMun = 27025;

    String urlStr = 'https://opendata.aemet.es/opendata/api/prediccion/especifica/municipio/horaria/' + codMun.toString();
    urlStr += '/?api_key=' + apiKey;
    //https://opendata.aemet.es/opendata/api/prediccion/especifica/municipio/horaria/27025/?api_key=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjcGluZGF5ZGVsQGVkdWNhY2lvbi5uYXZhcnJhLmVzIiwianRpIjoiZDMzNzQ4YWYtMzBiMC00ZWU5LWFmOGQtMjgzNDM2YjhkMWIxIiwiaXNzIjoiQUVNRVQiLCJpYXQiOjE2Nzg0MDg0MTAsInVzZXJJZCI6ImQzMzc0OGFmLTMwYjAtNGVlOS1hZjhkLTI4MzQzNmI4ZDFiMSIsInJvbGUiOiIifQ.hZu4JaDTzSz854rZZR2D2pjZNgqJy0EpPkehi0cJQ8M
    final response = await http.get(Uri.parse(urlStr));

    if (response.statusCode == 200) {
      // Si la llamada al servidor fue exitosa, analiza el JSON
      // return AemetRest.fromJson(json.decode(response.body));
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      String urlAemet = jsonData['datos'];

      return urlAemet;
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }



  Future<String> obtenerRecomendaciones(int hora, String nvlAct, bool esVulnerable) async {
      String url = await obtenerUrlDatosAemet(0);
      print(url);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String body = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(body);
        String nombre = jsonData[0]['nombre'];

        //calculamos el wbgt -----------------------------------------------------------
        int horaSelec = 12;

        //obtener temperatura aire (ta) y humedad relativa (hr)
        //periodo (8 - 23) => (0 - 7) => valor de 23
        var temperaturas = jsonData[0]['prediccion']['dia'][0]['temperatura'];
        var humedades = jsonData[0]['prediccion']['dia'][0]['humedadRelativa'];
        int ta = 0;
        int hr = 0;

        if (horaSelec >= 0 && horaSelec <= 7) {
          //tomara valor de 23 // de la hora 9 => temperaturas[9 - 8]
          ta = int.parse(temperaturas[15]['value']);
          hr = int.parse(humedades[15]['value']);
        } else {
          ta = int.parse(temperaturas[horaSelec - 8]['value']);
          hr = int.parse(humedades[horaSelec - 8]['value']);
        }

        //e = HR / 100 × 6,105 × exp (17,27 × Ta/(237,7 + Ta))
        double ep = (hr / 100) * 6.105 * exp((17.27 * ta) / (237.7 + ta));
        //WBGT = 0,567 × Ta + 0,393 × e + 3,94
        double wbgt = 0.567 * ta * ep + 3.94;

        //map con los niveles de actividad y limites wbgt
        final Map<String, int> actividadLimites = {
          'descanso' : 33,
          'ligero' : 30,
          'moderado' : 28,
          'pesado' : 26,
          'muy pesado': 25
        };

        //si el wbgt es mayor que el limite
        double diferencia = actividadLimites['descanso']! - wbgt;

        //diferencia es menor -> hay mayor riesgo
        String riesgo = 'bajo';
        Color colorRiesgo = Colors.green;
        if (diferencia < 0) {
          riesgo = 'extremo';
          colorRiesgo = Colors.red;
        } else if (diferencia > 0 && diferencia <= 3) {
          riesgo = 'alto';
          colorRiesgo = Colors.orange;
        } else if (diferencia > 3 && diferencia <= 6) {
          riesgo = 'medio';
          colorRiesgo = Colors.yellow;
        } else if (diferencia > 6) {
          riesgo = 'bajo';
          colorRiesgo = Colors.green;
        }

        final Map<String, List<String>> recomendaciones = {
          'bajo': ['Puedes desarollar tu actividad laboral sin preocuparte', ''],
          'medio': ['Intenta desarrollar tu actividad sin exigirte demasiado', ''],
          'alto': ['Evitar realizar las tareas pesadas en las horas de más calor, de 12:00 a 17:00, y en solitario.', 'Adaptar el ritmo de trabajo según la tolerancia al calor.', 'Descansar en lugares frescos.'],
          'extremo': ['PARAR la actividad al sentir calambres, mareos, fatiga, nauseas.', 'Retirarse a un lugar fresco y comunicar la situación a un compañero o superior.', 'Si los síntomas persisten avisar al 112.']
        };

        //trabajar con las recomendaciones
        List<String>? recs = recomendaciones[riesgo];

        String msjVulnerable = '';
        if (esVulnerable) {
          msjVulnerable = 'Eres parte de la población vulnerable, toma precausiones.';
        }

        //devolvemos una lista con mensaje wbgt, temperatura actual, recomendaciones
        return nombre;
      }
      else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
      }
    

  }
}