import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_provider.dart';
import 'package:vibration/vibration.dart';

class SecurityScreen extends StatefulWidget {
  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _isButtonLongPressed = false;
  double _buttonScale = 1.0;

  void _startLongPress(BuildContext context) async {
    setState(() {
      _isButtonLongPressed = true;
      _buttonScale = 1.2;
    });

    // Start vibration
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate();
    }

    // Wait for long press duration
    await Future.delayed(Duration(seconds: 3));

    // Delete records and show feedback
    if (_isButtonLongPressed) {
      _deleteAllRecords(context);
    }
  }

  void _endLongPress() async {
    setState(() {
      _isButtonLongPressed = false;
      _buttonScale = 1.0;
    });

    // Stop vibration
    Vibration.cancel();
  }

  void _deleteAllRecords(BuildContext context) async {
    await Provider.of<IncidentProvider>(context, listen: false).deleteAllIncidents();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Todos los registros han sido eliminados.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/block.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 50,
            child: Transform.scale(
              scale: _buttonScale,
              child: GestureDetector(
                onLongPressStart: (_) => _startLongPress(context),
                onLongPressEnd: (_) => _endLongPress(),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isButtonLongPressed
                        ? Colors.green.withOpacity(0.6)
                        : Colors.red.withOpacity(0.9), // rojo más intenso
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}