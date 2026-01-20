
// ignore_for_file: unreachable_switch_default

import 'package:flutter/material.dart';
import '../../models/alert_model.dart';

class AlertBanner extends StatelessWidget {
  final Alert alert;

  const AlertBanner({super.key, required this.alert});

  Color _getBannerColor(AlertLevel level) {
    switch (level) {
      case AlertLevel.critical:
        return Colors.red.shade800;
      case AlertLevel.warning:
        return Colors.orange.shade800;
      case AlertLevel.info:
      default:
        return Colors.blue.shade800;
    }
  }

  IconData _getIcon(AlertLevel level) {
    switch (level) {
      case AlertLevel.critical:
        return Icons.error_outline;
      case AlertLevel.warning:
        return Icons.warning_amber_rounded;
      case AlertLevel.info:
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: _getBannerColor(alert.level),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            _getIcon(alert.level),
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              alert.message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
