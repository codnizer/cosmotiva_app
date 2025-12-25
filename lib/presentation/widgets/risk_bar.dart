import 'package:cosmotiva/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RiskBar extends StatelessWidget {
  final double score; // 0 to 100
  final String riskLevel;

  const RiskBar({super.key, required this.score, required this.riskLevel});

  @override
  Widget build(BuildContext context) {
    Color color;
    if (score > 80) {
      color = const Color(0xFF00FF9D); // Neon Green
    } else if (score > 50) {
      color = const Color(0xFFFFD600); // Neon Yellow
    } else {
      color = const Color(0xFFFF0055); // Neon Red
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RISK LEVEL: ${riskLevel.toUpperCase()}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              '${score.toStringAsFixed(1)}/100',
              style: AppTextStyles.headerMedium.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white.withOpacity(0.1),
          ),
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * (score / 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: color,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.6),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ).animate().slideX(begin: -1, end: 0, duration: 1.seconds, curve: Curves.easeOutExpo);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
