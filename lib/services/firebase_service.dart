import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart' as app_user;
import '../models/vital_model.dart';
import '../models/alert_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Authentification ---

  // Obtient l'utilisateur actuellement authentifié
  app_user.User? getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      return app_user.User(uid: user.uid, email: user.email!);
    }
    return null;
  }

  // S'inscrire avec email et mot de passe
  Future<app_user.User?> signUpWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user != null) {
        // Mettre à jour le displayName dans Auth si fourni
        if (displayName != null && displayName.isNotEmpty) {
          await user.updateDisplayName(displayName);
        }

        // Vérifier si le document existe déjà (bien que rare pour un nouvel utilisateur)
        final docRef = _firestore.collection('users').doc(user.uid);
        final docSnapshot = await docRef.get();
        if (!docSnapshot.exists) {
          // Créer un document dans Firestore
          await docRef.set({
            'email': email,
            'displayName': displayName ?? '',
            'createdAt': FieldValue.serverTimestamp(),
            'lastLogin': FieldValue.serverTimestamp(),
            'role': 'user',
            'riskStatus': 'Indéterminé', // Champ spécifique à votre app
          });
          debugPrint('Document utilisateur créé dans Firestore : ${user.uid}');
        } else {
          debugPrint('Document utilisateur existe déjà : ${user.uid}');
        }
        return app_user.User(uid: user.uid, email: email);
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'inscription : ${e.toString()}');
      // Gestion d'erreur : vous pouvez lever une exception ou retourner null
      throw Exception('Échec de l\'inscription : ${e.toString()}');
    }
    return null;
  }

  // Se connecter avec email et mot de passe
  Future<app_user.User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user != null) {
        // Mettre à jour la dernière connexion dans Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
        return app_user.User(uid: user.uid, email: email);
      }
    } catch (e) {
      debugPrint('Erreur lors de la connexion : ${e.toString()}');
      throw Exception('Échec de la connexion : ${e.toString()}');
    }
    return null;
  }

  // Se déconnecter
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // --- Firestore ---

  // Enregistrer un relevé de signes vitaux
  Future<void> saveVital(String userId, Vital vital) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('vitals')
          .add({
            'heartRate': vital.heartRate,
            'oxygenSaturation': vital.oxygenSaturation,
            'respiratoryRate': vital.respiratoryRate,
            'timestamp': vital.timestamp,
          });
    } catch (e) {
      debugPrint(e.toString()); // Gérez les erreurs
    }
  }

  // Enregistrer une alerte
  Future<void> saveAlert(String userId, Alert alert) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('alerts')
          .add({
            'message': alert.message,
            'level': alert.level.toString(),
            'timestamp': alert.timestamp,
          });
    } catch (e) {
      debugPrint(e.toString()); // Gérez les erreurs
    }
  }

  // Exemple pour mettre à jour les données utilisateur
  Future<void> updateUserProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      debugPrint('Erreur mise à jour profil : ${e.toString()}');
    }
  }
}
