import 'package:complaint_app/utils/text_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Issues By Category",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w700,
            fontFamily: AppTextTheme.englishTextStyle.fontFamily,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          height: 200,
          child: PieChart(
            PieChartData(
              sections: getSections(),
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 60,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LegendItem(
              color: const Color(0xFF947DFF),
              text: 'Technical Support',
            ),
            const SizedBox(width: 16),
            LegendItem(
              color: Colors.green,
              text: 'General Inquiry',
            ),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> getSections() {
    return [
      PieChartSectionData(
        color: const Color(0xFF947DFF),
        value: 66.7,
        title: '66.7%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 33.3,
        title: '33.3%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: AppTextTheme.englishTextStyle.fontFamily,
          ),
        ),
      ],
    );
  }
}
