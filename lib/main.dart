import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'widgets/beginning/onboarding_screen.dart';
import 'widgets/home/home_screen.dart';
import 'utils/theme.dart'; // Import du thème personnalisé
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/vitals_provider.dart';
import 'providers/clinical_data_provider.dart';
import 'providers/alerts_provider.dart';
import 'providers/predictions_provider.dart';

Future<void> main() async {
  // Assure que les widgets Flutter sont prêts
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialise les données de localisation pour le formatage des dates en français
  await initializeDateFormatting('fr_FR', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => VitalsProvider()),
        ChangeNotifierProvider(create: (_) => ClinicalDataProvider()),
        ChangeNotifierProvider(create: (_) => AlertsProvider()),
        ChangeNotifierProvider(create: (_) => PredictionsProvider()),
      ],
      child: MaterialApp(
        title: 'DIGISANTE',
        debugShowCheckedModeBanner: false,
        theme: appTheme, // ✨ Utilisation du thème personnalisé
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData) {
              // Si l'utilisateur est connecté, il va directement à l'accueil
              return const HomeScreen();
            }
            // Sinon, il voit l'écran d'onboarding
            return const OnboardingScreen();
          },
        ),
      ),
    );
  }
}
