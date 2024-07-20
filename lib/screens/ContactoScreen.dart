import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Contacto', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset('assets/iamsomon.jpg', fit: BoxFit.cover, width: 300, height: 300),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Samuel Somón',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'UI/UX Designer, Graphic Designer, and Software Developer',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  launch('https://wa.me/18095041974');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,  // Cambio de color a verde
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: Text(
                  "Let's Talk",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              // Texto para el correo y número de teléfono
              Container(
                alignment: Alignment.center,
                child: Text(
                  "somonitla@gmail.com // 809-504-1974",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.facebook, color: Colors.white),
                  SizedBox(width: 20),
                  Icon(FontAwesomeIcons.twitter, color: Colors.white),
                  SizedBox(width: 20),
                  Icon(FontAwesomeIcons.linkedin, color: Colors.white),
                  SizedBox(width: 20),
                  Icon(FontAwesomeIcons.behance, color: Colors.white),
                ],
              ),
              SizedBox(height: 40),
              Text(
                'My Services',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  ServiceCard(
                    title: 'UI/UX Designer',
                    description:
                    'Formado en Google, poseo habilidades avanzadas en diseño de interfaces de usuario y experiencia de usuario, creando soluciones intuitivas y atractivas.',
                    icon: FontAwesomeIcons.paintBrush,
                  ),
                  ServiceCard(
                    title: 'Graphic Designer',
                    description:
                    'Formado en Google, tengo una sólida base en diseño gráfico, aplicando principios de diseño visual para comunicar ideas de manera efectiva.',
                    icon: FontAwesomeIcons.palette,
                  ),
                  ServiceCard(
                    title: 'Web Designer',
                    description:
                    'Cursando el centro de estudios en ITLA y certificado por Cisco, estoy capacitado en diseño web, integrando tecnologías modernas para desarrollar sitios web funcionales.',
                    icon: FontAwesomeIcons.code,
                  ),
                  ServiceCard(
                    title: 'Software Developer',
                    description:
                    'Cursando el centro de estudios en ITLA y experiencia en el desarrollo de software, creo aplicaciones robustas y escalables utilizando las últimas tecnologías.',
                    icon: FontAwesomeIcons.laptopCode,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  ServiceCard({required this.title, required this.description, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      width: MediaQuery.of(context).size.width / 2.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 40),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Flexible(
            child: Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
