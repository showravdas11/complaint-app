import 'package:complaint_app/utils/text_theme.dart';
import 'package:complaint_app/widget/dashboard_overview.dart';
import 'package:complaint_app/widget/issue_table.dart';
import 'package:complaint_app/widget/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF2A4320),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 16,
                ),
                child: Text(
                  "Welcome Superadmin",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppTextTheme.englishTextStyle.fontFamily,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 20),
                child: Text(
                  "Here's what's happening with your System",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppTextTheme.englishTextStyle.fontFamily,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 16, right: 16, bottom: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    IssueCard(
                      title: 'TOTAL ISSUES',
                      yearLabel: '2024',
                      count: 10,
                      icon: Icons.chat,
                      iconColor: Color(0xFFE3FCEF),
                      percentage: '0%',
                    ),
                    IssueCard(
                      title: 'PENDING ISSUES',
                      yearLabel: '2024',
                      count: 8,
                      icon: Icons.help_outline,
                      iconColor: Color(0xFFFDEFDA),
                      percentage: '0%',
                    ),
                    IssueCard(
                      title: 'SOLVED ISSUES',
                      yearLabel: '2024',
                      count: 0,
                      icon: Icons.help_outline,
                      iconColor: Color(0xFFFDEFDA),
                      percentage: '0%',
                    ),
                    IssueCard(
                      title: 'CLOSED ISSUES',
                      yearLabel: '2024',
                      count: 1,
                      icon: Icons.help_outline,
                      iconColor: Color(0xFFFDEFDA),
                      percentage: '0%',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PieChartWidget(),
              const SizedBox(height: 16),
              IssuesTable(),
              const SizedBox(height: 16),
              DashboardOverview()
            ],
          ),
        ),
      ),
    );
  }
}

class IssueCard extends StatelessWidget {
  final String title;
  final String yearLabel;
  final int count;
  final IconData icon;
  final Color iconColor;
  final String percentage;

  const IssueCard({
    required this.title,
    required this.yearLabel,
    required this.count,
    required this.icon,
    required this.iconColor,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTextTheme.englishTextStyle.fontFamily,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 229, 25, 25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  yearLabel,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTextTheme.englishTextStyle.fontFamily,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTextTheme.englishTextStyle.fontFamily,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.green[800],
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontFamily: AppTextTheme.englishTextStyle.fontFamily,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.arrow_upward,
                    color: Colors.green,
                    size: 14,
                  ),
                  Text(
                    ' $percentage',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
