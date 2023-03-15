import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// Clase con metodos estaticos
class AemetDatos {

  //map con los niveles de actividad y limites wbgt
  static final Map<String, int> actividadLimites = {
    'descanso' : 33,
    'ligero' : 30,
    'moderado' : 28,
    'pesado' : 26,
    'muy pesado': 25
  };

  // Map con los niveles de riesgos y recomendaciones
  static Map<String, List<String>> recomPorRiesgo = {
    'bajo': ['Puedes desarollar tu actividad laboral sin preocuparte'],
    'medio': ['Intenta desarrollar tu actividad sin exigirte demasiado'],
    'alto': ['Evitar realizar las tareas pesadas en las horas de más calor, de 12:00 a 17:00, y en solitario.', 'Adaptar el ritmo de trabajo según la tolerancia al calor.', 'Descansar en lugares frescos.'],
    'extremo': ['PARAR la actividad al sentir calambres, mareos, fatiga, nauseas.', 'Retirarse a un lugar fresco y comunicar la situación a un compañero o superior.', 'Si los síntomas persisten avisar al 112.']
  };

  //Obtener url con los datos del municipio
  static Future<String> obtenerUrlDatos(int codMun) async {
    String apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjcGluZGF5ZGVsQGVkdWNhY2lvbi5uYXZhcnJhLmVzIiwianRpIjoiZDMzNzQ4YWYtMzBiMC00ZWU5LWFmOGQtMjgzNDM2YjhkMWIxIiwiaXNzIjoiQUVNRVQiLCJpYXQiOjE2Nzg0MDg0MTAsInVzZXJJZCI6ImQzMzc0OGFmLTMwYjAtNGVlOS1hZjhkLTI4MzQzNmI4ZDFiMSIsInJvbGUiOiIifQ.hZu4JaDTzSz854rZZR2D2pjZNgqJy0EpPkehi0cJQ8M';
    String urlStr = 'https://opendata.aemet.es/opendata/api/prediccion/especifica/municipio/horaria/' + codMun.toString();
    urlStr += '/?api_key=' + apiKey;

    final response = await http.get(Uri.parse(urlStr));
    if (response.statusCode == 200) {
      // Si la llamada al servidor fue exitosa, analiza el JSON
      final jsonData = json.decode(response.body);
      String urlAemet = jsonData['datos'];
      return urlAemet;
    } else {
      // Si la llamada no fue exitosa, lanza un error.
      throw Exception('Failed to load post');
    }
  }

  //deuelve los resultados aemet de la hora indicada
  static Future<dynamic> obtenerDatosAemet(int hora, String nvlAct, bool esVulnerable, int codMun) async {
    try {
      String url = await obtenerUrlDatos(codMun);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        //calculamos el wbgt -----------------------------------------------------------

        //obtener temperatura aire (ta) y humedad relativa (hr)
        //periodo (8 - 23) => (0 - 7) => valor de 23
        var temperaturas = jsonData[0]['prediccion']['dia'][0]['temperatura'];
        var humedades = jsonData[0]['prediccion']['dia'][0]['humedadRelativa'];
        int ta = 0;
        int hr = 0;

        // if (hora >= 0 && hora <= 7) {
        //   // tomara valor de 23 // de la hora 9 => temperaturas[9 - 8]
        //   ta = int.parse(temperaturas[15]['value']);
        //   hr = int.parse(humedades[15]['value']);
        // } else {
        //   ta = int.parse(temperaturas[hora - 8]['value']);
        //   hr = int.parse(humedades[hora - 8]['value']);
        // }

        ta = int.parse(temperaturas[0]['value']);
        hr = int.parse(humedades[0]['value']);

        //e = HR / 100 × 6,105 × exp (17,27 × Ta/(237,7 + Ta))
        double ep = (hr / 100) * 6.105 * exp((17.27 * ta) / (237.7 + ta));
        //WBGT = 0,567 × Ta + 0,393 × e + 3,94
        double wbgt = 0.567 * ta + 0.393 * ep + 3.94;

        //si el wbgt es mayor que el limite
        double diferencia = actividadLimites[nvlAct]! - wbgt;

        //diferencia es menor -> hay mayor riesgo
        String riesgo = 'bajo';
        Color color = Colors.green;
        if (diferencia < 0) {
          riesgo = 'extremo';
          color = Colors.red;
        } else if (diferencia > 0 && diferencia <= 3) {
          riesgo = 'alto';
          color = Colors.orange;
        } else if (diferencia > 3 && diferencia <= 6) {
          riesgo = 'medio';
          color = Colors.yellow;
        } else if (diferencia > 6) {
          riesgo = 'bajo';
          color = Colors.green;
        }

        //trabajar con las recomendaciones
        List<String>? recs = recomPorRiesgo[riesgo];

        String msjVulnerable = 'No eres parte de la población vulnerable.';
        if (esVulnerable) {
          msjVulnerable = 'Eres parte de la población vulnerable, toma precausiones.';
        }

        //retornar map
        Map<String, dynamic> resultados = {
          'nvlRiesgo': riesgo.toUpperCase(),
          'colorRiesgo': color,
          'temperatura': ta.toString() + 'ºC',
          'recomendaciones': recs,
          'mensajeVulnerable': msjVulnerable
        };

        return resultados;
      }
      else {
      // Si la llamada no fue exitosa, lanza un error.
      // throw Exception('Failed to load post');
        return 'Error en la obtencion de datos';  
      }
    }
    catch (e) {
      print(e);
      return e.toString();
    }
  }
}