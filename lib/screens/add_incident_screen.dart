import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../providers/incident_provider.dart';
import '../models/incident.dart';

class AddIncidentScreen extends StatefulWidget {
  @override
  _AddIncidentScreenState createState() => _AddIncidentScreenState();
}

class _AddIncidentScreenState extends State<AddIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  String? _photoPath;
  String? _audioPath;
  bool _isRecording = false;
  late FlutterSoundRecorder _audioRecorder;
  late FlutterSoundPlayer _audioPlayer;
  Timer? _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _audioPlayer = FlutterSoundPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    await _audioRecorder.openRecorder();
    await _audioPlayer.openPlayer();
  }

  Future<void> _requestPermissionAndStartRecording() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      _startRecording();
    } else {
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permiso Denegado'),
        content: Text(
            'Esta aplicación necesita permiso para usar el micrófono para grabar audio.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioRecorder.closeRecorder();
    _audioPlayer.closePlayer();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImagePath = '${directory.path}/$fileName';
      await pickedFile.saveTo(savedImagePath);
      setState(() {
        _photoPath = savedImagePath;
      });
    }
  }

  Future<void> _saveIncident() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      final newIncident = Incident(
        title: _title,
        date: DateTime.now().toString(),
        description: _description,
        photoPath: _photoPath ?? '',
        audioPath: _audioPath ?? '',
        id: DateTime.now().millisecondsSinceEpoch,
      );
      await Provider.of<IncidentProvider>(context, listen: false)
          .insertIncident(newIncident);
      Navigator.of(context).pop();
    }
  }

  Future<void> _startRecording() async {
    try {
      if (_isRecording) return;

      final directory = await getApplicationDocumentsDirectory();
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      _audioPath = '${directory.path}/$fileName.aac';

      await _audioRecorder.startRecorder(
        toFile: _audioPath,
        codec: Codec.aacADTS,
      );

      _startTimer(); // Inicia el contador de tiempo

      setState(() {
        _isRecording = true;
      });
    } catch (err) {
      print('Error al iniciar la grabación: $err');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds = timer.tick; // Actualiza el tiempo transcurrido
      });
    });
  }

  Future<void> _stopRecording() async {
    try {
      if (!_isRecording) return;

      await _audioRecorder.stopRecorder();
      _timer?.cancel(); // Detiene el contador de tiempo

      setState(() {
        _isRecording = false;
      });
    } catch (err) {
      print('Error al detener la grabación: $err');
    }
  }

  Future<void> _playRecording() async {
    if (_audioPath != null) {
      try {
        await _audioPlayer.startPlayer(
          fromURI: _audioPath!,
          codec: Codec.aacADTS,
          whenFinished: () {
            print('Reproducción terminada');
          },
        );
      } catch (err) {
        print('Error al reproducir la grabación: $err');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registrar Incidencia',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Título
                Container(
                  child: Row(
                    children: [
                      Icon(Icons.title, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        'Título',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Color blanco
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF1F2833)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Ingresa el título',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16), // Agregar espacio interno
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return 'Por favor ingresa un título';
                      return null;
                    },
                    onSaved: (value) => _title = value!,
                  ),
                ),
                SizedBox(height: 20),
                // Descripción
                Container(
                  child: Row(
                    children: [
                      Icon(Icons.description, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        'Descripción',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Color blanco
                        ),
                      ),
                    ],
                  ),
                ),
                // Campo de texto para la descripción
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF1F2833)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Ingresa la descripción',
                      hintStyle: TextStyle(color: Colors.grey), // Color blanco
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16), // Agregar espacio interno
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty)
                        return 'Por favor ingresa una descripción';
                      return null;
                    },
                    onSaved: (value) => _description = value!,
                  ),
                ),
                SizedBox(height: 20),
                // Mostrar la foto si hay una
                if (_photoPath != null) Image.file(File(_photoPath!)),
                SizedBox(height: 20),
                // Botón para tomar una foto
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.camera_alt),
                  label: Text('Tomar Foto'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF1F2833), // Color azul oscuro
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Botón para grabar audio
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_isRecording) {
                      await _stopRecording();
                    } else {
                      await _requestPermissionAndStartRecording();
                    }
                  },
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  label:
                      Text(_isRecording ? 'Detener Grabación' : 'Grabar Audio'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red, // Color rojo
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                // Mostrar la duración de la grabación si está grabando
                if (_isRecording) Text('Grabando: $_elapsedSeconds segundos'),
                // Botón para reproducir audio
                ElevatedButton.icon(
                  onPressed: _playRecording,
                  icon: Icon(Icons.play_arrow),
                  label: Text('Reproducir Audio'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF1F2833), // Color azul oscuro
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Botón para guardar la incidencia
                ElevatedButton.icon(
                  onPressed: _saveIncident,
                  icon: Icon(Icons.save),
                  label: Text('Guardar Incidencia'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green, // Color verde
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
