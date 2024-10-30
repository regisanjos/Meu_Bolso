import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  final _categoryController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _saveExpense() async {
    try {
      await _firestore.collection('expenses').add({
        'title': _titleController.text,
        'value': double.parse(_valueController.text),
        'category': _categoryController.text,
        'date': DateTime.now(),
      });
      Navigator.pop(context);
    } catch (e) {
      print('Erro ao salvar despesa: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Despesa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _valueController,
              decoration: InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Categoria'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveExpense,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
