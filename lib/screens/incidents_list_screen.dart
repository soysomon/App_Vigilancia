import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/incident.dart';
import '../providers/incident_provider.dart';
import 'incident_detail_screen.dart';

class IncidentsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      //  title: Text('Incidencias Registradas'),
        actions: [

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Incidencias Registradas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Incidencias aseguradas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Aquí están registradas las incidencias hasta el momento.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.blue),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Próxima acción recomendada"',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Text(
                        'Verificación de incidencias',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward, color: Colors.blue),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<IncidentProvider>(context, listen: false).getIncidents(),
                builder: (ctx, AsyncSnapshot<List<Incident>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Ocurrió un error al cargar las incidencias: ${snapshot.error.toString()}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No hay incidencias registradas.'));
                  }
                  final incidents = snapshot.data!;
                  return ListView.builder(
                    itemCount: incidents.length,
                    itemBuilder: (ctx, index) {
                      final incident = incidents[index];
                      return ListTile(
                        title: Text(incident.title),
                        subtitle: Text(incident.date),
                        leading: Icon(Icons.report, color: Colors.black),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => IncidentDetailScreen(incident: incident),
                          ));
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
