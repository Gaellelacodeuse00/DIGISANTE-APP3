import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/vital_model.dart';

// Ce service nécessitera une bibliothèque comme flutter_blue_plus.
// Assurez-vous d'ajouter la dépendance dans votre pubspec.yaml
// et de configurer les autorisations natives (par exemple, AndroidManifest.xml).

class BluetoothService {
  // Simule un flux de données de signes vitaux provenant d'un appareil connecté.
  final _vitalsController = StreamController<Vital>.broadcast();
  Stream<Vital> get vitalsStream => _vitalsController.stream;

  // Simule la découverte d'appareils Bluetooth.
  Future<void> startScan() async {
    debugPrint('Recherche d\'appareils Bluetooth démarrée...');
    // La logique de recherche réelle (avec flutter_blue_plus) irait ici.
    // Par exemple : FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    // Après un délai, simule la connexion et la réception de données.
    Timer(Duration(seconds: 5), () {
      debugPrint('Appareil de santé trouvé et connecté !');
      _startEmittingVitals();
    });
  }

  // Simule la réception de données de signes vitaux.
  void _startEmittingVitals() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      // Génère des données de signes vitaux aléatoires à des fins de démonstration.
      final mockVital = Vital(
        heartRate:
            70 + (5 * (DateTime.now().second % 4 - 2)), // Varie entre 60 et 80
        oxygenSaturation:
            98 - (DateTime.now().second % 3), // Varie entre 96 et 98
        respiratoryRate:
            16 + (2 * (DateTime.now().second % 3 - 1)), // Varie entre 14 et 18
        timestamp: DateTime.now(),
      );
      _vitalsController.add(mockVital);
    });
  }

  void dispose() {
    _vitalsController.close();
  }
}
