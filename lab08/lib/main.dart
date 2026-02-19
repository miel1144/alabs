import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:gal/gal.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Camera Sensor', home: CameraScreen());
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image; //puede aceptar un null (file! acepta cualquiera menos null)
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _takePhoto() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (photo != null) {
      final File imageFile = File(photo.path);
      // guardar en galeria
      final result = await Gal.putImage(imageFile.path);

      //print pala el backend jeje
      //print("Resultado guardado: $result"); //corregir esto

      setState(() {
        _image = imageFile;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagen guardad en la galeria')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camara :)'), centerTitle: true),
      body: Center(
        child: _image == null
            ? const Text("No hay imagen seleccionada")
            : Image.file(_image!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
