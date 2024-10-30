import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, double>> _fetchExpensesByCategory() async {
    final querySnapshot = await _firestore.collection('expenses').get();
    Map<String, double> categoryTotals = {};

    for (var doc in querySnapshot.docs) {
      String category = doc['category'];
      double value = doc['value'];

      if (categoryTotals.containsKey(category)) {
        categoryTotals[category] = categoryTotals[category]! + value;
      } else {
        categoryTotals[category] = value;
      }
    }

    return categoryTotals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumo de Despesas'),
      ),
      body: FutureBuilder<Map<String, double>>(
        future: _fetchExpensesByCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma despesa registrada'));
          }

          final data = snapshot.data!;
          final total = data.values.reduce((a, b) => a + b);

          return Column(
            children: [
              SizedBox(height: 20),
              Text('Gasto Total: R\$ $total', style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: data.entries.map((entry) {
                      final percentage = (entry.value / total * 100).toStringAsFixed(1);
                      return PieChartSectionData(
                        title: '${entry.key} - $percentage%',
                        value: entry.value,
                        radius: 50,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
