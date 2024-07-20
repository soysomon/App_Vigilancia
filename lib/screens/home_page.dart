import 'dart:ui';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: PoliceAppDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/home.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(flex: 3),
                Spacer(flex: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/addIncident');
                          },
                          child: Text('Agregar Incidente', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            textStyle: TextStyle(fontSize: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/incidentsList');
                          },
                          child: Text('Lista de Incidentes', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: BorderSide(color: Colors.white),
                            padding: EdgeInsets.symmetric(vertical: 20),
                            textStyle: TextStyle(fontSize: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PoliceAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          // Fondo translúcido con desenfoque
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Más translúcido
              ),
            ),
          ),
          // Contenido del Drawer
          ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    // Logo ajustado y colocado en el centro
                    Center(
                      child: Image.asset('assets/logo_police1.png', height: 70, width: 100),
                    ),
                    SizedBox(height: 10),
                    Text('Oficial Hilma Perez', style: TextStyle(color: Colors.black)),
                    Text('hilma.perez@policeapp.com', style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
              _buildDrawerItem(icon: Icons.home, text: 'Inicio', onTap: () => Navigator.pushNamed(context, '/home')),
              _buildDrawerItem(icon: Icons.add, text: 'Agregar Incidente', onTap: () => Navigator.pushNamed(context, '/addIncident')),
              _buildDrawerItem(icon: Icons.list, text: 'Lista de Incidentes', onTap: () => Navigator.pushNamed(context, '/incidentsList')),
              _buildDrawerItem(icon: Icons.info, text: 'Acerca de', onTap: () => Navigator.pushNamed(context, '/about')),
              _buildDrawerItem(icon: Icons.security, text: 'Seguridad', onTap: () => Navigator.pushNamed(context, '/security')),
              Divider(color: Colors.black54),
              _buildDrawerItem(icon: Icons.adb, text: 'Creador App', onTap: () => Navigator.pushNamed(context, '/contacto')),
              _buildDrawerItem(icon: Icons.exit_to_app, text: 'Cerrar Sesión', onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              }),
            ],
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(text, style: TextStyle(color: Colors.black)),
      onTap: onTap,
    );
  }
}


