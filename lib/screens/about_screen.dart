import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6, // Tamaño de la imagen
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/teniente.png'),
                  fit: BoxFit.cover, // La imagen cubre toda la área
                ),
                borderRadius: BorderRadius.only( // Redondear esquinas
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Sombra negra
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // Posición de la sombra
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: 20), // Añadir margen inferior para bajar la imagen
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // Foto de perfil
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/teniente.png'),
                  ),
                  SizedBox(width: 16),
                  // Información de perfil
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hilma Perez',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Teniente',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Texto de reflexión
            Text(
              'Reflexión: La vigilancia y la seguridad son pilares fundamentales para la protección de nuestra comunidad.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFF030266),
          child: IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ),
      ),
    );
  }
}