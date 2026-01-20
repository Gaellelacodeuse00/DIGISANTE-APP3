import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final String? displayName = user?.displayName ?? user?.email;
    final email = user?.email ?? 'Aucun e-mail';
    final initials = displayName?.isNotEmpty == true
        ? displayName!.split(' ').map((e) => e[0]).take(2).join()
        : '?';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: EdgeInsets.only(
                top: screenHeight * 0.08,
                bottom: screenHeight * 0.05,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF9333EA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // Back button + Title
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: screenWidth * 0.1,
                          height: screenWidth * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Text(
                        "Mon Profil",
                        style: TextStyle(fontSize: screenWidth * 0.06, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // PROFILE CARD
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Avatar
                            Container(
                              width: screenWidth * 0.2,
                              height: screenWidth * 0.2,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                initials,
                                style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.075),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.04),
                            // Name + Tag + Badge
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(displayName ?? 'Utilisateur', style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  Text("Patient ID: #${user?.uid.substring(0, 7).toUpperCase() ?? 'N/A'}", style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.035)),
                                  const SizedBox(height: 6),
                                  // Badge
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025, vertical: screenHeight * 0.005),
                                    decoration: BoxDecoration(
                                      color: Colors.green[600],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "Compte vérifié",
                                      style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.03),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: screenHeight * 0.04,
                           child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () { /* TODO: Implement edit profile */ },
                            child: Text(
                              "Modifier le profil",
                              style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.03),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // CONTENT
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // PERSONAL INFO CARD
                  _buildInfoCard(
                    screenWidth: screenWidth,
                    title: "Informations personnelles",
                    children: [
                      _infoTile(screenWidth, Icons.calendar_month, Colors.blue, "Date de naissance", "15 Mars 1990 (34 ans)"),
                      SizedBox(height: screenHeight * 0.01),
                      _infoTile(screenWidth, Icons.phone, Colors.green, "Téléphone", "+225 07 12 34 56 78"),
                      SizedBox(height: screenHeight * 0.01),
                      _infoTile(screenWidth, Icons.email, Colors.purple, "Email", email),
                      SizedBox(height: screenHeight * 0.01),
                      _infoTile(screenWidth, Icons.location_on, Colors.orange, "Localisation", "Abidjan, Cocody"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInfoCard(
                    screenWidth: screenWidth,
                    title: "Paramètres",
                    children: [
                      _settingsItem(screenWidth, Icons.bluetooth, "Appareils connectés"),
                      _settingsItem(screenWidth, Icons.shield, "Confidentialité et sécurité"),
                      _settingsItem(screenWidth, Icons.description, "Mes documents"),
                      _settingsItem(screenWidth, Icons.help_outline, "Aide et support"),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  // LOGOUT BUTTON
                  InkWell(
                    onTap: () => _handleLogout(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth * 0.035),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: screenWidth * 0.025),
                          Text("Se déconnecter", style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.04)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required double screenWidth, required String title, required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold)),
          SizedBox(height: screenWidth * 0.04),
          ...children
        ],
      ),
    );
  }

  Widget _infoTile(double screenWidth, IconData icon, Color color, String label, String value) {
    return Row(
      children: [
        Container(
          width: screenWidth * 0.11,
          height: screenWidth * 0.11,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(screenWidth * 0.035),
          ),
          child: Icon(icon, color: color),
        ),
        SizedBox(width: screenWidth * 0.03),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.03)),
            Text(value, style: TextStyle(fontSize: screenWidth * 0.04)),
          ],
        )
      ],
    );
  }

  Widget _settingsItem(double screenWidth, IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          SizedBox(width: screenWidth * 0.04),
          Expanded(child: Text(title, style: TextStyle(fontSize: screenWidth * 0.04))),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
