import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/prediction_model.dart';

class PredictionsProvider with ChangeNotifier {
  List<Prediction> _predictions = [];
  bool _isLoading = false;

  List<Prediction> get predictions => _predictions;
  bool get isLoading => _isLoading;

  Future<void> fetchPredictions(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('predictions')
          .orderBy('predictionDate', descending: true)
          .get();
      _predictions = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Prediction(
          riskLevel: RiskLevel.values[data['riskLevel']],
          description: data['description'],
          predictionDate: (data['predictionDate'] as Timestamp).toDate(),
        );
      }).toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPrediction(String userId, Prediction prediction) async {
    _isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('predictions')
          .add({
            'riskLevel': prediction.riskLevel.index,
            'description': prediction.description,
            'predictionDate': Timestamp.fromDate(prediction.predictionDate),
          });
      _predictions.insert(0, prediction);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
