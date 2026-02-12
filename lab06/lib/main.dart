import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Accelerometer f-app', home: HomePage());
    //meti el home
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  @override
  void initState() {
    super.initState(); //herencia
    //escucha el chenchor
    // ignore: deprecated_member_use
    accelerometerEvents.listen((event) {
      /// corregir en el futuro accelerometer
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acelelomecher')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Eje X: ${x.toStringAsFixed(2)}"),
            const SizedBox(height: 10),
            Text("Eje Y: ${y.toStringAsFixed(2)}"),
            const SizedBox(height: 10),
            Text("Eje Z: ${z.toStringAsFixed(2)}"),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
