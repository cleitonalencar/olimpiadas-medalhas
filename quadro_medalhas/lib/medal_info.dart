import 'package:flutter/material.dart';

class MedalInfo extends StatelessWidget {
  final int goldMedals;
  final int silverMedals;
  final int bronzeMedals;
  final int totalMedals;

  const MedalInfo({
    super.key,
    required this.goldMedals,
    required this.silverMedals,
    required this.bronzeMedals,
    required this.totalMedals,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMedalInfo(Icons.circle, Colors.yellow, goldMedals),
        const SizedBox(width: 4),
        _buildMedalInfo(Icons.circle, Colors.grey, silverMedals),
        const SizedBox(width: 4),
        _buildMedalInfo(Icons.circle, Colors.brown, bronzeMedals),
        const SizedBox(width: 20),
        _buildAllMedalsInfo(totalMedals),
      ],
    );
  }

  Widget _buildMedalInfo(IconData icon, Color color, int count) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 2),
        Text(count.toString()),
      ],
    );
  }

  Widget _buildAllMedalsInfo(int count) {
    return Column(
      children: [
        Image.asset(
          'assets/medals.png',
          width: 18,
        ),
        Text(count.toString()),
      ],
    );
  }
}
