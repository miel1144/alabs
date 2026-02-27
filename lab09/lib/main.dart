import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:ambient_light/ambient_light.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Material App', home: LightScreen());
  }
}

class LightScreen extends StatefulWidget {
  const LightScreen({super.key});
  @override
  State<LightScreen> createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> {
  //variables de estado
  double _valorLuz = 0.0;
  String _mensaje = 'waiting for sensor...';
  //instancia de la clase del sensor o una instancia del sensor
  final AmbientLight _ambientLight = AmbientLight();
  StreamSubscription<double>? _subscription;
  @override
  void initState() {
    super.initState();
    _iniciarSensorLuz();
  }

  //Aqui estara la funcion del sensor de luz
  void _iniciarSensorLuz() {
    _subscription = _ambientLight.ambientLightStream.listen((double valor) {
      //funcion anonima
      setState(() {
        _valorLuz = valor;
        if (valor < 10) {
          _mensaje = 'Estado Oscuro';
        } else if (valor < 100) {
          _mensaje = 'Luz ambiente Normal';
        } else if (valor < 1000) {
          _mensaje = 'Esta Brillante';
        } else {
          _mensaje = 'Mucha Luz';
        }
      }); //setState
      print("Valor luz: $valor");
    }); //ambientLightStream.listen
  } //_inicioSensorLuz

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color colorFondo = _valorLuz < 50
        ? Colors.grey[900]!
        : _valorLuz < 500
        ? Colors.amber[50]!
        : Colors.white;
    Color colorTexto = _valorLuz < 50 ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        title: const Text('lucimetro'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: _valorLuz < 50 ? Colors.grey[800] : Colors.amber[100],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _valorLuz.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,

                      color: colorTexto,
                    ),
                  ),
                  Text(
                    "lux ...",
                    style: TextStyle(
                      fontSize: 18,
                      color: colorTexto.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                color: _valorLuz < 50 ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: Text(
                _mensaje,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: colorTexto,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text(
                    "Intensidad de luz",
                    style: TextStyle(color: colorTexto, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: (_valorLuz / 1000).clamp(0.0, 1.0),
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _valorLuz > 500 ? Colors.amber : Colors.grey,
                    ),
                    minHeight: 15,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "Tapa el sensor o acercate a la luz",
              style: TextStyle(
                color: colorTexto.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
