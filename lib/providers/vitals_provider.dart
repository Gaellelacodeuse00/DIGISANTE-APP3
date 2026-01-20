import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vital_model.dart';

class VitalsProvider with ChangeNotifier {
  List<Vital> _vitals = [];
  bool _isLoading = false;

  List<Vital> get vitals => _vitals;
  bool get isLoading => _isLoading;

  Future<void> fetchVitals(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('vitals')
          .orderBy('timestamp', descending: true)
          .get();
      _vitals = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Vital(
          heartRate: data['heartRate'],
          oxygenSaturation: data['oxygenSaturation'],
          respiratoryRate: data['respiratoryRate'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addVital(String userId, Vital vital) async {
    _isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('vitals')
          .add({
            'heartRate': vital.heartRate,
            'oxygenSaturation': vital.oxygenSaturation,
            'respiratoryRate': vital.respiratoryRate,
            'timestamp': Timestamp.fromDate(vital.timestamp),
          });
      _vitals.insert(0, vital);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
