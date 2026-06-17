import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// A single profile statistic (count + label) used in the profile header.
class StatColumn extends StatelessWidget {
  final int count;
  final String label;

  const StatColumn({super.key, required this.count, required this.label});

  /// Formats large numbers like Instagram (e.g. 1240 -> 1.2K).
  static String formatCount(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
    }
    return '$value';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatCount(count),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.black),
        ),
      ],
    );
  }
}
