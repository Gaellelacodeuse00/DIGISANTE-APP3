
class Vital {
  final double heartRate; // Battements par minute
  final double oxygenSaturation; // SpO2 en pourcentage
  final double respiratoryRate; // Respirations par minute
  final DateTime timestamp;

  Vital({
    required this.heartRate,
    required this.oxygenSaturation,
    required this.respiratoryRate,
    required this.timestamp,
  });
}
