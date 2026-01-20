import 'package:flutter/material.dart';
import '../models/alert_model.dart';

class AlertsProvider with ChangeNotifier {
  final List<Alert> _alerts = [];
  bool _isLoading = false;

  List<Alert> get alerts => _alerts;
  bool get isLoading => _isLoading;

  void addAlert(Alert alert) {
    _alerts.insert(0, alert);
    notifyListeners();
  }

  void removeAlert(int index) {
    if (index >= 0 && index < _alerts.length) {
      _alerts.removeAt(index);
      notifyListeners();
    }
  }

  void clearAlerts() {
    _alerts.clear();
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
