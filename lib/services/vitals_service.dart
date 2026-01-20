import 'dart:async';
import 'package:flutter/foundation.dart';
import './bluetooth_service.dart';
import './calculation_service.dart';
import './firebase_service.dart';

class VitalsService {
  final BluetoothService _bluetoothService;
  final CalculationService _calculationService;
  final FirebaseService _firebaseService;
  final String _userId;

  StreamSubscription? _vitalsSubscription;

  VitalsService({
    required BluetoothService bluetoothService,
    required CalculationService calculationService,
    required FirebaseService firebaseService,
    required String userId,
  }) : _bluetoothService = bluetoothService,
       _calculationService = calculationService,
       _firebaseService = firebaseService,
       _userId = userId;

  // Démarre la surveillance des signes vitaux.
  void startMonitoring() {
    // Annule toute souscription précédente pour éviter les fuites de mémoire.
    _vitalsSubscription?.cancel();

    // Démarre le scan Bluetooth (qui, dans notre simulation, commencera à émettre des données).
    _bluetoothService.startScan();

    // Écoute le flux de données de signes vitaux.
    _vitalsSubscription = _bluetoothService.vitalsStream.listen((vital) {
      debugPrint(
        'Nouveau relevé de signes vitaux reçu: FC: ${vital.heartRate}, SpO2: ${vital.oxygenSaturation}',
      );

      // 1. Sauvegarde le relevé de signes vitaux brut dans Firebase.
      _firebaseService.saveVital(_userId, vital);

      // 2. Analyse le relevé pour détecter des anomalies.
      final alert = _calculationService.analyzeVitals(vital);

      // 3. Si une alerte est générée, la sauvegarde également.
      if (alert != null) {
        debugPrint('ALERTE GÉNÉRÉE: ${alert.message}');
        _firebaseService.saveAlert(_userId, alert);
      }
    });
  }

  // Arrête la surveillance.
  void stopMonitoring() {
    _vitalsSubscription?.cancel();
    // Ici, vous pourriez aussi appeler une méthode pour déconnecter l'appareil Bluetooth.
    // _bluetoothService.disconnect();
    debugPrint('Arrêt de la surveillance des signes vitaux.');
  }

  // Libère les ressources lorsque le service n'est plus utilisé.
  void dispose() {
    stopMonitoring();
  }
}
