import 'package:complaint_app/utils/text_theme.dart';
import 'package:flutter/material.dart';

class IssuesTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latest Issues',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: AppTextTheme.englishTextStyle.fontFamily,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 6,
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            height: 330,
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(const Color(0xFFF0F8F5)),
                    columnSpacing: 25,
                    columns: [
                      DataColumn(label: Text('Issue Id', style: _columnHeaderStyle)),
                      DataColumn(label: Text('Name', style: _columnHeaderStyle)),
                      DataColumn(label: Text('Email', style: _columnHeaderStyle)),
                      DataColumn(label: Text('Creation Time', style: _columnHeaderStyle)),
                      DataColumn(label: Text('Subject', style: _columnHeaderStyle)),
                      DataColumn(label: Text('Status', style: _columnHeaderStyle)),
                    ],
                    rows: [
                      _buildDataRow('CD3725', 'Anonymous', '2 days ago', 'Pending', Colors.red),
                      _buildDataRow('481CC5', 'Anonymous', '2 days ago', 'Pending', Colors.red),
                      _buildDataRow('461427', 'Anonymous', '2 days ago', 'Pending', Colors.red),
                      _buildDataRow('846D91', 'Anonymous', '5 days ago', 'Closed', Colors.green),
                      _buildDataRow('FD6A37', 'Anonymous', '5 days ago', 'Pending', Colors.red),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(String issueId, String name, String creationTime, String status, Color statusColor) {
    return DataRow(
      cells: [
        DataCell(Text(issueId, style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600))),
        DataCell(
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, color: Colors.white),
                radius: 14,
              ),
              const SizedBox(width: 8),
              Text(name, style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const DataCell(Text('showrav@gmil.com', style: TextStyle(color: Colors.blue))),
        DataCell(Text(creationTime, style: const TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w500))),
        const DataCell(Text('No Subject', style: TextStyle(color: Colors.black))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [statusColor.withOpacity(0.2), statusColor.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  final TextStyle _columnHeaderStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: Color(0xFF2A4320),
  );
}
