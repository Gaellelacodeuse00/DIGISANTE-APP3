
enum RiskLevel {
  low,
  medium,
  high,
}

class Prediction {
  final RiskLevel riskLevel;
  final String description;
  final DateTime predictionDate;

  Prediction({
    required this.riskLevel,
    required this.description,
    required this.predictionDate,
  });
}
