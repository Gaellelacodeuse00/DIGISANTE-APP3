import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1E40AF), Color(0xFF6B21A8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20), // CORRIGÉ
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Center(
              child: Icon(LucideIcons.wifi, size: 100, color: Colors.white),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            "Capteurs IoT Connectés",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Connexion automatique via Bluetooth avec vos appareils de mesure",
              style: TextStyle(fontSize: 18, color: Color(0xFFBFDBFE)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
