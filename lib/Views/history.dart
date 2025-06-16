import 'package:flutter/material.dart';
import 'package:maize_doc/Views/database_helper.dart';
import 'package:maize_doc/Views/welcomepage.dart';
import 'package:intl/intl.dart';

class DiseaseHistoryPage extends StatefulWidget {
  final String username;
  const DiseaseHistoryPage({Key? key, required this.username}) : super(key: key);

  @override
  _DiseaseHistoryPageState createState() => _DiseaseHistoryPageState();
}

class _DiseaseHistoryPageState extends State<DiseaseHistoryPage> {
  late Future<List<Map<String, dynamic>>> _diseaseHistory;

  @override
  void initState() {
    super.initState();
    _diseaseHistory = DatabaseHelper().getDiseaseHistory();
  }

  Future<void> _clearHistory() async {
    await DatabaseHelper().clearDiseaseHistory(); // Implement this method in DatabaseHelper
    setState(() {
      _diseaseHistory = DatabaseHelper().getDiseaseHistory(); // Refresh the data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Disease Detection History", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _diseaseHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No history available."));
          } else {
            final history = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        dataRowHeight: 30,
                        headingRowHeight: 30,
                        columnSpacing: 15,
                        columns: const [
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Disease')),
                          DataColumn(label: Text('Confidence (%)')),
                        ],
                        rows: history.map((record) {
                          final date = DateTime.parse(record['timestamp']);
                          final formattedDate = DateFormat('yyyy-MM-dd').format(date);

                          return DataRow(cells: [
                            DataCell(Text(formattedDate, style: const TextStyle(fontSize: 12))),
                            DataCell(Text(record['disease'], style: const TextStyle(fontSize: 12))),
                            DataCell(Text(record['confidence'].toStringAsFixed(2), style: const TextStyle(fontSize: 12))),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'Clear History',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage(username: widget.username)),
            );
          } else if (index == 1) {
            _showClearConfirmationDialog();
          }
        },
        backgroundColor: Colors.green, // Set the background color
        selectedItemColor: Colors.white, // Set the selected item color
        unselectedItemColor: Colors.white70, // Set the unselected item color
      ),

    );
  }

  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Clear History"),
          content: const Text("Are you sure you want to clear the disease history?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _clearHistory();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Clear"),
            ),
          ],
        );
      },
    );
  }
}