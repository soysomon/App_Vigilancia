import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vigi_app/providers/incident_provider.dart';
import 'package:vigi_app/providers/permission_provider.dart';
import 'package:vigi_app/screens/ContactoScreen.dart';
import 'package:vigi_app/screens/auth_provider.dart';
import 'package:vigi_app/screens/login.dart';
import 'package:vigi_app/database_provider.dart'; // Asegúrate de importar DatabaseProvider
import 'screens/add_incident_screen.dart';
import 'screens/incidents_list_screen.dart';
import 'screens/about_screen.dart';
import 'screens/security_screen.dart';
import 'screens/home_page.dart';
import 'dart:async'; // Importa la biblioteca para usar Timer

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseProvider databaseProvider = DatabaseProvider();
  await databaseProvider.initDatabase(); // Inicialización de la base de datos

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IncidentProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => PermissionProvider()), // Añade el proveedor de permisos

      ],
      child: MaterialApp(
        title: 'App de Vigilancia',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(), // Pantalla inicial configurada como SplashScreen
        routes: {
          '/addIncident': (context) => AddIncidentScreen(),
          '/incidentsList': (context) => IncidentsListScreen(),
          '/about': (context) => AboutScreen(),
          '/security': (context) => SecurityScreen(),
          '/home': (context) => HomePage(),
          '/contacto': (context) => ContactoScreen(),
          '/login': (context) => LoginScreen(), // Añadir la ruta para LoginScreen
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navegar a la pantalla de login después de 3.5 segundos
    Timer(Duration(seconds: 3, milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/intro.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
