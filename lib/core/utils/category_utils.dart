import 'package:flutter/material.dart';

class CategoryUtils {
  static String getFullName(String category) {
    switch (category) {
      case 'SP':
      case 'Supplements':
        return 'Supplements';
      case 'SC':
      case 'Skincare':
        return 'Skincare';
      case 'PC':
      case 'Personal Care':
        return 'Personal Care';
      case 'NF':
      case 'Natural Food':
        return 'Natural Food';
      case 'KD':
      case 'Kids':
        return 'Kids';
      default:
        return 'Others';
    }
  }

  static IconData getIcon(String category) {
    switch (category) {
      case 'SP':
      case 'Supplements':
        return Icons.healing_rounded;
      case 'SC':
      case 'Skincare':
        return Icons.face_retouching_natural_rounded;
      case 'PC':
      case 'Personal Care':
        return Icons.spa_rounded;
      case 'NF':
      case 'Natural Food':
        return Icons.eco_rounded;
      case 'KD':
      case 'Kids':
        return Icons.child_care_rounded;
      default:
        return Icons.shopping_bag_outlined;
    }
  }

  static Color getColor(String category) {
    switch (category) {
      case 'SP':
      case 'Supplements':
        return const Color(0xFFE17055); // Orange
      case 'SC':
      case 'Skincare':
        return const Color(0xFFFD79A8); // Pink
      case 'PC':
      case 'Personal Care':
        return const Color(0xFF00CEC9); // Teal
      case 'NF':
      case 'Natural Food':
        return const Color(0xFF00B894); // Green
      case 'KD':
      case 'Kids':
        return const Color(0xFF0984E3); // Blue
      default:
        return const Color(0xFF636E72); // Gray
    }
  }
}
