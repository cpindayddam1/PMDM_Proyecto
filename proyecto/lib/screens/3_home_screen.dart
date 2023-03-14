import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:proyecto/models/aemet_rest.dart';
import 'package:proyecto/models/codigos_municipios.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }

}


class HomeScreenState extends State<HomeScreen> {
  // HomeScreenState();


  Container containerResultado = Container(
    child: Text('Da clic en el boton para obtener datos'),
  );

  //map con los niveles de actividad y limites wbgt
  final Map<String, int> actividadLimites = {
    'descanso' : 33,
    'ligero' : 30,
    'moderado' : 28,
    'pesado' : 26,
    'muy pesado': 25
  };

  // Map con los niveles de riesgos y recomendaciones
  Map<String, List<String>> recomPorRiesgo = {
    'bajo': ['Puedes desarollar tu actividad laboral sin preocuparte', ''],
    'medio': ['Intenta desarrollar tu actividad sin exigirte demasiado', ''],
    'alto': ['Evitar realizar las tareas pesadas en las horas de más calor, de 12:00 a 17:00, y en solitario.', 'Adaptar el ritmo de trabajo según la tolerancia al calor.', 'Descansar en lugares frescos.'],
    'extremo': ['PARAR la actividad al sentir calambres, mareos, fatiga, nauseas.', 'Retirarse a un lugar fresco y comunicar la situación a un compañero o superior.', 'Si los síntomas persisten avisar al 112.']
  };

  String x = CodigosMunicipios.codigos['municipios'][10]['CMUN'];

  @override
  Widget build(BuildContext context) {
    // String str = "";
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100, 
        title: const Text('AEMET Datos'),
        backgroundColor: Color.fromARGB(255, 94, 24, 110),
      ),
      body: SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 100,
                color: Colors.blueGrey,
                child: Text('AEMET', style: TextStyle(fontSize: 20, color: Colors.amber)),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  obtenerWidgetResultado();
                },
                child: const SizedBox(
                  height: 50,
                  width: 350,
                  child: Center(
                    child: Text('Obtener nivel de riesgo y recomendaciones actuales', textAlign: TextAlign.center)),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'singup');
                },
                child: const SizedBox(
                  height: 50,
                  width: 200,
                  child: Center(
                    child: Text('Volver al formulario', textAlign: TextAlign.center)),
                ),
              ),
              const SizedBox(height: 30),
              containerResultado,
              Image(image: AssetImage('assets/ispln.png')),
              Text(x)
              ],
          ),
        ),
      )
    );
  }

  //pinta en pantalla el widget con el resultado o un mensaje de error
  Future<void> obtenerWidgetResultado() async {
    int hora = 12;
    String nvlAct = 'pesado';
    bool esVulnerable = true;

    String msjGPS = await obtenerUbicacionGPS();
    
    // if (msjGPS == 'El GPS está desactivado' || msjGPS == 'No se ha dado permiso para utilizar el GPS' ) {
    //   return 'error gps';
    // }
    double lat = double.parse(msjGPS.split('*')[0]);
    double lon = double.parse(msjGPS.split('*')[1]);

    int codMun = obtenerCodigoMunicipio(lat, lon);
    // 27025
    final res = await obtenerDatosAemet(hora, nvlAct, esVulnerable, codMun);

    if (res.runtimeType.toString() == 'IdentityMap<String, dynamic>') {
      String riesgo = res['nvlRiesgo'];
          Color color = res['colorRiesgo'];
          String temperatura = res['temperatura'];
          List<String> recs = res['recomendaciones'];/////
          String msjVul = res['mensajeVulnerable'];

          String str = '';
          recs.forEach((r) => str += r + '\n\n\n');

          Container container = 
          Container(
            padding: EdgeInsets.all(30),
            child: Container(
              color: Color.fromARGB(255, 188, 219, 245),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    // height: 60,
                    alignment: Alignment.centerLeft,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(child: Text('Datos generales', style: TextStyle(fontSize: 18, color: Colors.purple, fontWeight: FontWeight.bold))),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(flex: 1, child: const Text('Nivel de riesgo', style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold), textAlign: TextAlign.start, )),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                color: color,
                                child: Text(riesgo, style: TextStyle(fontSize: 20, color: Colors.white)),
                              ),
                            )]
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(flex: 1, child: const Text('Temperatura', style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold), textAlign: TextAlign.start,)),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                child: Text(temperatura, style: TextStyle(fontSize: 15, color: Colors.blue)),
                              ),
                            )]
                        ),
                      ]
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    // height: 60,
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(child: Text('Recomendaciones', style: TextStyle(fontSize: 18, color: Colors.purple, fontWeight: FontWeight.bold))),
                        const SizedBox(height: 30),
                        Container(alignment: Alignment.centerLeft, child: Text(str, style: TextStyle(fontSize: 15, color: Colors.blue))),
                      ]
                    ),
                  ),
                ]
              ),
            ),
          );

          containerResultado = container;
          setState(() {});
    }
    else {
      
          Container container = 
          Container(
            padding: EdgeInsets.all(30),
            child: Container(
              color: Colors.red,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    // height: 60,
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(child: Text('Error', style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold))),
                        const SizedBox(height: 30),
                        Container(child: Text(res, style: TextStyle(fontSize: 15, color: Colors.amber))),
                      ]
                    ),
                  )
                ]
              ),
            ),
          );

      containerResultado = container;
      setState(() {});
    }
  }
  
  int obtenerCodigoMunicipio(double lat, double lon) {
    final lista = CodigosMunicipios.codigos['municipios'];

    // iterar para obtener distancia mas cercana
    double distanciaMenor = double.maxFinite;
    int codMenor = 0;
    // String nombre = '';
    for(var obj in lista) {
      double lat2 = double.parse(obj['LATITUD']);
      double lon2 = double.parse(obj['LONGITUD']);
      int cod = int.parse(obj['CPRO'] + obj['CMUN']);

      double distancia = sqrt(pow((lat2 - lat), 2)  + pow((lon2 - lon), 2));

      if (distancia < distanciaMenor) {
        distanciaMenor = distancia;
        codMenor = cod;
        // nombre = obj['NOMBRE'];
      }
      // print(lat2.toString() + ' * ' + lon2.toString());
    }
    // print(nombre);
    // print(lat.toString() + ' *** ' + lon.toString());
    return codMenor;
  }

  Future<String> obtenerUbicacionGPS() async {
    String texto = '';
    Location _location = Location();
    // 1: Comprobamos si el servicio de GPS está activado:
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      // Si está desactivado, le pedimos que lo inicie
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        texto = 'El GPS está desactivado';
        // setState(() {});
        return texto;
      }
    }

    // 2: Comprobamos si el usuario nos ha dado permiso para utilizar el GPS
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      // Si no lo ha otorgado, se lo pedimos
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        texto = 'No se ha dado permiso para utilizar el GPS';
        // setState(() {});
        return texto;
      }
    }

    // 3: Si todo es correcto, obtenemos la ubicación
    LocationData locationData = await _location.getLocation();
    texto =
        '${locationData.latitude}*${locationData.longitude}';

    return texto;
  }

  Future<String> obtenerUrlDatos(int codMun) async {
    String apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjcGluZGF5ZGVsQGVkdWNhY2lvbi5uYXZhcnJhLmVzIiwianRpIjoiZDMzNzQ4YWYtMzBiMC00ZWU5LWFmOGQtMjgzNDM2YjhkMWIxIiwiaXNzIjoiQUVNRVQiLCJpYXQiOjE2Nzg0MDg0MTAsInVzZXJJZCI6ImQzMzc0OGFmLTMwYjAtNGVlOS1hZjhkLTI4MzQzNmI4ZDFiMSIsInJvbGUiOiIifQ.hZu4JaDTzSz854rZZR2D2pjZNgqJy0EpPkehi0cJQ8M';
    String urlStr = 'https://opendata.aemet.es/opendata/api/prediccion/especifica/municipio/horaria/' + codMun.toString();
    urlStr += '/?api_key=' + apiKey;
    //https://opendata.aemet.es/opendata/api/prediccion/especifica/municipio/horaria/27025/?api_key=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjcGluZGF5ZGVsQGVkdWNhY2lvbi5uYXZhcnJhLmVzIiwianRpIjoiZDMzNzQ4YWYtMzBiMC00ZWU5LWFmOGQtMjgzNDM2YjhkMWIxIiwiaXNzIjoiQUVNRVQiLCJpYXQiOjE2Nzg0MDg0MTAsInVzZXJJZCI6ImQzMzc0OGFmLTMwYjAtNGVlOS1hZjhkLTI4MzQzNmI4ZDFiMSIsInJvbGUiOiIifQ.hZu4JaDTzSz854rZZR2D2pjZNgqJy0EpPkehi0cJQ8M
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
  Future<dynamic> obtenerDatosAemet(int hora, String nvlAct, bool esVulnerable, int codMun) async {
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

        if (hora >= 0 && hora <= 7) {
          //tomara valor de 23 // de la hora 9 => temperaturas[9 - 8]
          ta = int.parse(temperaturas[15]['value']);
          hr = int.parse(humedades[15]['value']);
        } else {
          ta = int.parse(temperaturas[hora - 8]['value']);
          hr = int.parse(humedades[hora - 8]['value']);
        }

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

        String msjVulnerable = '';
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
      return 'Algo salió mal. Inténtalo más tarde';
    }     
      
  }
}