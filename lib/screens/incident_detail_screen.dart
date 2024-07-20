import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../models/incident.dart';

class IncidentDetailScreen extends StatefulWidget {
  final Incident incident;

  IncidentDetailScreen({required this.incident});

  @override
  _IncidentDetailScreenState createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  int _currentStep = 0;
  bool _isPlaying = false;
  late FlutterSoundPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = FlutterSoundPlayer();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    await _audioPlayer.openPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.closePlayer();
    super.dispose();
  }

  Future<void> _toggleAudioPlayback() async {
    if (_isPlaying) {
      await _audioPlayer.stopPlayer();
    } else {
      if (widget.incident.audioPath != null && widget.incident.audioPath!.isNotEmpty) {
        await _audioPlayer.startPlayer(
          fromURI: widget.incident.audioPath,
          codec: Codec.aacADTS,
          whenFinished: () {
            setState(() {
              _isPlaying = false;
            });
          },
        );
      }
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF030266),
        colorScheme: ColorScheme.light(primary: Color(0xFF030266)),
        fontFamily: 'Montserrat',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Detalle de Incidencia',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepTapped: (step) {
            setState(() {
              _currentStep = step;
            });
          },
          onStepContinue: null,
          onStepCancel: null,
          steps: [
            Step(
              title: Text('Detalle', style: TextStyle(fontFamily: 'Montserrat')),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.incident.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Fecha: ${widget.incident.date}',
                    style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: Text('Descripción', style: TextStyle(fontFamily: 'Montserrat')),
              content: Text(
                widget.incident.description,
                style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
              ),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: Text('Foto', style: TextStyle(fontFamily: 'Montserrat')),
              content: widget.incident.photoPath == null || widget.incident.photoPath!.isEmpty
                  ? Text('No hay foto disponible.', style: TextStyle(fontFamily: 'Montserrat'))
                  : Image.file(
                File(widget.incident.photoPath!),
                fit: BoxFit.contain,
              ),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: Text('Audio', style: TextStyle(fontFamily: 'Montserrat')),
              content: widget.incident.audioPath == null || widget.incident.audioPath!.isEmpty
                  ? Text('No hay audio disponible.', style: TextStyle(fontFamily: 'Montserrat'))
                  : ElevatedButton.icon(
                icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                label: Text(_isPlaying ? 'Detener Audio' : 'Reproducir Audio'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _toggleAudioPlayback,
              ),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
            ),
          ],
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return SizedBox.shrink(); // Retorna un widget vacío para quitar los botones
          },
        ),
      ),
    );
  }
}
