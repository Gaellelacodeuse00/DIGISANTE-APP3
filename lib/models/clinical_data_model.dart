import 'package:cloud_firestore/cloud_firestore.dart';

class ClinicalData {
  final String userId;
  final int age;
  final String sexe; // 'Homme', 'Femme', 'Autre'
  final bool isSmoker;
  final int smokingYears; // >= 0
  final double bodyTemperature; // 37.0 - 42.0
  final int coughIntensity; // 0 - 10
  final bool shortnessOfBreath;
  final bool chronicFatigue;
  final bool chestPain;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClinicalData({
    required this.userId,
    required this.age,
    required this.sexe,
    required this.isSmoker,
    required this.smokingYears,
    required this.bodyTemperature,
    required this.coughIntensity,
    required this.shortnessOfBreath,
    required this.chronicFatigue,
    required this.chestPain,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now() {
    // Validation
    if (age < 0 || age > 150) {
      throw ArgumentError('Age must be between 0 and 150');
    }
    if (!['Homme', 'Femme', 'Autre'].contains(sexe)) {
      throw ArgumentError('Sexe must be Homme, Femme, or Autre');
    }
    if (smokingYears < 0) {
      throw ArgumentError('Smoking years must be >= 0');
    }
    if (bodyTemperature < 37.0 || bodyTemperature > 42.0) {
      throw ArgumentError('Body temperature must be between 37.0 and 42.0');
    }
    if (coughIntensity < 0 || coughIntensity > 10) {
      throw ArgumentError('Cough intensity must be between 0 and 10');
    }
  }

  // Factory constructor from Firestore
  factory ClinicalData.fromMap(Map<String, dynamic> map) {
    return ClinicalData(
      userId: map['userId'] ?? '',
      age: map['age'] ?? 0,
      sexe: map['sexe'] ?? 'Autre',
      isSmoker: map['isSmoker'] ?? false,
      smokingYears: map['smokingYears'] ?? 0,
      bodyTemperature: (map['bodyTemperature'] ?? 37.0).toDouble(),
      coughIntensity: map['coughIntensity'] ?? 0,
      shortnessOfBreath: map['shortnessOfBreath'] ?? false,
      chronicFatigue: map['chronicFatigue'] ?? false,
      chestPain: map['chestPain'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'age': age,
      'sexe': sexe,
      'isSmoker': isSmoker,
      'smokingYears': smokingYears,
      'bodyTemperature': bodyTemperature,
      'coughIntensity': coughIntensity,
      'shortnessOfBreath': shortnessOfBreath,
      'chronicFatigue': chronicFatigue,
      'chestPain': chestPain,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Copy with method for updates
  ClinicalData copyWith({
    String? userId,
    int? age,
    String? sexe,
    bool? isSmoker,
    int? smokingYears,
    double? bodyTemperature,
    int? coughIntensity,
    bool? shortnessOfBreath,
    bool? chronicFatigue,
    bool? chestPain,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClinicalData(
      userId: userId ?? this.userId,
      age: age ?? this.age,
      sexe: sexe ?? this.sexe,
      isSmoker: isSmoker ?? this.isSmoker,
      smokingYears: smokingYears ?? this.smokingYears,
      bodyTemperature: bodyTemperature ?? this.bodyTemperature,
      coughIntensity: coughIntensity ?? this.coughIntensity,
      shortnessOfBreath: shortnessOfBreath ?? this.shortnessOfBreath,
      chronicFatigue: chronicFatigue ?? this.chronicFatigue,
      chestPain: chestPain ?? this.chestPain,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ClinicalData(userId: $userId, age: $age, sexe: $sexe, isSmoker: $isSmoker, smokingYears: $smokingYears, bodyTemperature: $bodyTemperature, coughIntensity: $coughIntensity, shortnessOfBreath: $shortnessOfBreath, chronicFatigue: $chronicFatigue, chestPain: $chestPain, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
