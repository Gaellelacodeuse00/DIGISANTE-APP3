import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/clinical_data_model.dart';

class ClinicalDataProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ClinicalData? _clinicalData;
  bool _isLoading = false;
  String? _errorMessage;

  ClinicalData? get clinicalData => _clinicalData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch clinical data for a user
  Future<void> fetchClinicalData(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      DocumentSnapshot doc = await _firestore
          .collection('clinical_data')
          .doc(userId)
          .get();

      if (doc.exists) {
        _clinicalData = ClinicalData.fromMap(
          doc.data() as Map<String, dynamic>,
        );
      } else {
        _clinicalData = null;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _clinicalData = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Save or update clinical data
  Future<bool> saveClinicalData(ClinicalData data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestore
          .collection('clinical_data')
          .doc(data.userId)
          .set(data.toMap(), SetOptions(merge: true));

      _clinicalData = data.copyWith(updatedAt: DateTime.now());
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update specific fields
  Future<bool> updateClinicalData(Map<String, dynamic> updates) async {
    if (_clinicalData == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      updates['updatedAt'] = Timestamp.fromDate(DateTime.now());

      await _firestore
          .collection('clinical_data')
          .doc(_clinicalData!.userId)
          .update(updates);

      // Update local data
      Map<String, dynamic> currentMap = _clinicalData!.toMap();
      currentMap.addAll(updates);
      _clinicalData = ClinicalData.fromMap(currentMap);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete clinical data
  Future<bool> deleteClinicalData(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestore.collection('clinical_data').doc(userId).delete();
      _clinicalData = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear data (for logout)
  void clearData() {
    _clinicalData = null;
    _errorMessage = null;
    notifyListeners();
  }
}
