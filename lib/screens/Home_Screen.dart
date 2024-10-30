import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_expense_screen.dart';
import 'edit_expense_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _selectedCategory;
  String _sortOption = 'Data';
  DateTime _selectedDate = DateTime.now();

  // Função para excluir uma despesa
  void _deleteExpense(String expenseId) async {
    try {
      await _firestore.collection('expenses').doc(expenseId).delete();
    } catch (e) {
      print('Erro ao excluir despesa: $e');
    }
  }

  
  Stream<QuerySnapshot> _getFilteredExpenses() {
    Query query = _firestore.collection('expenses');

    
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      query = query.where('category', isEqualTo: _selectedCategory);
    }

    
    query = query.where(
      'date',
      isGreaterThanOrEqualTo: DateTime(_selectedDate.year, _selectedDate.month, 1),
      isLessThan: DateTime(_selectedDate.year, _selectedDate.month + 1, 1),
    );

  
    if (_sortOption == 'Valor') {
      query = query.orderBy('value', descending: true);
    } else if (_sortOption == 'Data') {
      query = query.orderBy('date', descending: true);
    }

    return query.snapshots();
  }

  
  void _selectMonth(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Despesas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExpenseScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Seletor de Mês
                DropdownButton<DateTime>(
                  hint: Text('Mês'),
                  value: _selectedDate,
                  items: List.generate(12, (index) {
                    final monthDate = DateTime(DateTime.now().year, index + 1, 1);
                    return DropdownMenuItem(
                      value: monthDate,
                      child: Text(DateFormat('MMMM').format(monthDate)),
                    );
                  }),
                  onChanged: (newDate) {
                    if (newDate != null) _selectMonth(newDate);
                  },
                ),
                
                
                DropdownButton<String>(
                  hint: Text('Categoria'),
                  value: _selectedCategory,
                  items: [
                    DropdownMenuItem(value: '', child: Text('Todas')),
                    DropdownMenuItem(value: 'Alimentação', child: Text('Alimentação')),
                    DropdownMenuItem(value: 'Transporte', child: Text('Transporte')),
                    DropdownMenuItem(value: 'Lazer', child: Text('Lazer')),
                    DropdownMenuItem(value: 'Saúde', child: Text('Saúde')),
                    
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),

               
                DropdownButton<String>(
                  value: _sortOption,
                  items: [
                    DropdownMenuItem(value: 'Data', child: Text('Data')),
                    DropdownMenuItem(value: 'Valor', child: Text('Valor')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortOption = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getFilteredExpenses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Nenhuma despesa registrada'));
                }

                final expenses = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    final expenseId = expense.id;
                    final title = expense['title'];
                    final value = expense['value'];
                    final category = expense['category'];

                    return ListTile(
                      title: Text(title),
                      subtitle: Text('R\$ $value - $category'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditExpenseScreen(
                                    expenseId: expenseId,
                                    initialTitle: title,
                                    initialValue: value,
                                    initialCategory: category,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () => _deleteExpense(expenseId),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
