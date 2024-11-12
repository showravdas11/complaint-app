import 'package:flutter/material.dart';

class DashboardOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // Prevents scrolling in case it's inside another scrollable widget
        children: [
          _buildOverviewCard(
            icon: Icons.person_outline,
            iconColor: Colors.blue,
            count: '1',
            label: 'TOTAL USERS',
          ),
          _buildOverviewCard(
            icon: Icons.group_outlined,
            iconColor: Colors.purple,
            count: '3',
            label: 'TOTAL MEMBERS',
          ),
          _buildOverviewCard(
            icon: Icons.category_outlined,
            iconColor: Colors.cyan,
            count: '6',
            label: 'TOTAL CATEGORIES',
          ),
          _buildOverviewCard(
            icon: Icons.article_outlined,
            iconColor: Colors.green,
            count: '0',
            label: 'TOTAL ARTICLES',
          ),
          _buildOverviewCard(
            icon: Icons.email_outlined,
            iconColor: Colors.purple,
            count: '0',
            label: 'TOTAL SUBSCRIBERS',
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard({
    required IconData icon,
    required Color iconColor,
    required String count,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
