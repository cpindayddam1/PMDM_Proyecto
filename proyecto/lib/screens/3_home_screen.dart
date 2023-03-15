import 'package:flutter/material.dart';
import 'dart:async';
import 'package:proyecto/providers/aemet_provider.dart';
import 'package:proyecto/models/user_model.dart';
import 'package:proyecto/providers/gps_provider.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userModel;
  final int hora;
  
  const HomeScreen({Key? key, required this.userModel, required this.hora}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState(userModel: userModel, hora: hora);
  }
}

class HomeScreenState extends State<HomeScreen> {
  UserModel userModel;
  final int hora;

  HomeScreenState({required this.userModel, required this.hora});

  Container containerResultado = Container(
    child: Text('Da clic en el boton para obtener datos'),
  );

  @override
  Widget build(BuildContext context) {
    // String str = "";
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/ispln.png',
          height: 45,
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 166, 136, 173),
        toolbarHeight: 70,
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
                child: Text('INIZA Home', style: TextStyle(fontSize: 20, color: Colors.amber)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  obtenerWidgetResultado();
                },
                child: const SizedBox(
                  height: 50,
                  width: 335,
                  child: Center(
                    child: Text('Obtener nivel de riesgo y recomendaciones actuales', textAlign: TextAlign.center)),
                ),
              ),
              const SizedBox(height: 20),
              containerResultado
              ],
          ),
        ),
      )
    );
  }

  //pinta en pantalla el widget con el resultado o un mensaje de error
  Future<void> obtenerWidgetResultado() async {
    DateTime now = DateTime.now();
    
    int hora = now.hour;
    String nvlAct = userModel.nivelActividad;
    bool esVulnerable = userModel.esVulnerable();
    
    String msjGPS = await GpsProvider.obtenerUbicacionGPS();

    if (msjGPS == 'El GPS está desactivado' ||  msjGPS == 'No se ha dado permiso para utilizar el GPS' || msjGPS == 'Error al obtener ubicacion') {
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
                        Container(child: Text(msjGPS, style: TextStyle(fontSize: 15, color: Colors.amber))),
                      ]
                    ),
                  )
                ]
              ),
            ),
          );

      containerResultado = container;
      setState(() {});
      return;
    }
    
    double lat = double.parse(msjGPS.split('*')[0]);
    double lon = double.parse(msjGPS.split('*')[1]);
    int codMun = GpsProvider.obtenerCodigoMunicipio(lat, lon);

    final res = await AemetDatos.obtenerDatosAemet(hora, nvlAct, esVulnerable, codMun);
    if (res.runtimeType.toString() == 'String') {
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
                        Container(child: Text(res.toString(), style: TextStyle(fontSize: 15, color: Colors.amber))),
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
    else {
      String riesgo = res['nvlRiesgo'];
          Color color = res['colorRiesgo'];
          String temperatura = res['temperatura'];
          List<String> recs = res['recomendaciones'];/////
          String msjVul = res['mensajeVulnerable'];

          String str = '';
          recs.forEach((r) => str += r + '\n\n\n');
          str += msjVul;
          Container container = 
          Container(
            padding: EdgeInsets.all(10),
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
  }
  
}