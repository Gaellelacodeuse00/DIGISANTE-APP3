
import '../models/vital_model.dart';
import '../models/alert_model.dart';

class CalculationService {
  // Plages normales pour les signes vitaux
  static const double minHeartRate = 60.0;
  static const double maxHeartRate = 100.0;
  static const double minOxygenSaturation = 95.0;
  static const double minRespiratoryRate = 12.0;
  static const double maxRespiratoryRate = 20.0;

  // Analyse un seul relevé de signes vitaux et retourne une alerte si nécessaire.
  Alert? analyzeVitals(Vital vital) {
    if (vital.oxygenSaturation < minOxygenSaturation) {
      return Alert(
        message: 'Saturation en oxygène critiquement basse !',
        level: AlertLevel.critical,
        timestamp: DateTime.now(),
      );
    }

    if (vital.heartRate < minHeartRate || vital.heartRate > maxHeartRate) {
      return Alert(
        message: 'Fréquence cardiaque hors de la plage normale.',
        level: AlertLevel.warning,
        timestamp: DateTime.now(),
      );
    }

    if (vital.respiratoryRate < minRespiratoryRate || vital.respiratoryRate > maxRespiratoryRate) {
      return Alert(
        message: 'Fréquence respiratoire hors de la plage normale.',
        level: AlertLevel.warning,
        timestamp: DateTime.now(),
      );
    }

    // Pas d'anomalie détectée
    return null;
  }

  // Une future fonction pour la prédiction basée sur l'historique.
  // Pour l'instant, elle ne fait rien.
  void predictFutureTrends(List<Vital> vitalsHistory) {
    // La logique de prédiction sera implémentée ici.
    // Par exemple, analyser les tendances sur les dernières 24h.
  }
}
