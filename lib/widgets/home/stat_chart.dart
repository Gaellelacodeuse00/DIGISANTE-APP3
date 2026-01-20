import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/vital_model.dart';

// Ce widget nécessite une bibliothèque de graphiques comme fl_chart.
// Assurez-vous d'ajouter la dépendance dans votre pubspec.yaml.
// Pour cet exemple, nous simulons un graphique avec une image statique
// ou une représentation très simple.

class StatChart extends StatelessWidget {
  final List<Vital> vitalsHistory;
  final String title;

  const StatChart({
    super.key,
    required this.vitalsHistory,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Trier l'historique par timestamp
    final sortedVitals = List<Vital>.from(vitalsHistory)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(
          screenWidth * 0.04,
        ), // Padding responsive basé sur la largeur
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.045, // Taille de police responsive
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 0,
              height: screenHeight * 0.02,
            ), // Espacement responsive
            // Graphique réel avec fl_chart
            SizedBox(
              height:
                  screenHeight *
                  0.2, // Hauteur responsive basée sur la hauteur de l'écran
              child: sortedVitals.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucune donnée disponible',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: sortedVitals.asMap().entries.map((entry) {
                              final index = entry.key.toDouble();
                              final vital = entry.value;
                              return FlSpot(index, vital.respiratoryRate);
                            }).toList(),
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blue.withValues(alpha: 0.1),
                            ),
                            dotData: FlDotData(show: false),
                          ),
                        ],
                        minX: 0,
                        maxX: sortedVitals.length.toDouble() - 1,
                        minY: 0,
                        maxY:
                            sortedVitals
                                .map((v) => v.respiratoryRate)
                                .reduce((a, b) => a > b ? a : b) +
                            5,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
