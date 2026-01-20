
enum AlertLevel {
  info,
  warning,
  critical,
}

class Alert {
  final String message;
  final AlertLevel level;
  final DateTime timestamp;

  Alert({
    required this.message,
    required this.level,
    required this.timestamp,
  });
}
