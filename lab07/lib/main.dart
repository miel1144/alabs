import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'PedoMeter f-app', home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//clase de estado, la mera meruchis
class _HomePageState extends State<HomePage> {
  int _pasos = 0;
  int? _pasosIniciales;
  //historial+pasosActuales)- histoInicial = PasosactualesDesdeAbiertos
  ///? reinicia el sensor, es el start
  String _estado = "Waiting...";
  Stream<StepCount>? _stepCountStream; //no es variable, viene del sensor
  Stream<PedestrianStatus>? _pedestrianStatusStream;

  @override
  void initState() {
    //initS
    super.initState();
    _initPermissions();
  }

  Future<void> _initPermissions() async {
    var status = await Permission.activityRecognition.request();

    if (status.isGranted) {
      _initPedometer();
    } else {
      setState(() {
        _estado = 'Permiso Denegado';
      });
    }
  }

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    //listen del stepcount para que lo actualice
    _stepCountStream!.listen(_onStepCount, onError: _onStepCountError);

    _pedestrianStatusStream!.listen(
      _onPedestrianStatusChanged,
      onError: _onPedestrianStatusError,
    );
  }

  void _onStepCount() {}
  void _onPedestrianStatusChanged() {}

  void _onStepCountError() {}

  void _onPedestrianStatusError() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
