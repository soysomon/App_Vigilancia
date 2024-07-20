import 'package:flutter/foundation.dart';

class Incident {
  final int id;
  final String title;
  final String date;
  final String description;
  final String photoPath;
  final String audioPath;

  Incident({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.photoPath,
    required this.audioPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'description': description,
      'photoPath': photoPath,
      'audioPath': audioPath,
    };
  }
}
