import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Ruta Segura', home: LocationScreen());
  }
}

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  LatLng _currentPosition = LatLng(
    32.529676,
    -117.024267,
    //32.529676, -117.024267
  ); // punto 4, lagtityp y la otra jajaj
  ///uso del flutter map
  final MapController _mapController = MapController();

  Future<void> obtenerUbicacion() async {
    bool servicioHabilitado;
    LocationPermission permiso;
    //uso del geolocator
    servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      return;
    }

    permiso = await Geolocator.checkPermission(); //uso del geolocator
    if (permiso == LocationPermission.denied) {
      // punto 6 pide permiso
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        return;
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      //punto 1
      //uso del geolocator par la ubucacion actual
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    _mapController.move(_currentPosition, 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ubicación OpenStreetMap")),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(initialCenter: _currentPosition, initialZoom: 14),
        children: [
          TileLayer(
            urlTemplate:
                "https://tile.openstreetmap.org/{z}/{x}/{y}.png", //punto 2 uso del openstreet

            userAgentPackageName: 'com.miel.gps',
          ),
          MarkerLayer(
            //punto 3 usp del marker
            markers: [
              Marker(
                point: _currentPosition,
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_pin, //ikono del marker en posiscion de cdmx
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: obtenerUbicacion, // boton para actualizar a mi ubi jeje
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
