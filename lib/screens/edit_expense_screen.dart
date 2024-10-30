import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditExpenseScreen extends StatefulWidget {
  final String expenseId;
  final String initialTitle;
  final double initialValue;
  final String initialCategory;

  EditExpenseScreen({
    required this.expenseId,
    required this.initialTitle,
    required this.initialValue,
    required this.initialCategory,
  });

  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController _titleController;
  late TextEditingController _valueController;
  late TextEditingController _categoryController;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _valueController = TextEditingController(text: widget.initialValue.toString());
    _categoryController = TextEditingController(text: widget.initialCategory);
  }

  void _updateExpense() async {
    try {
      await _firestore.collection('expenses').doc(widget.expenseId).update({
        'title': _titleController.text,
        'value': double.parse(_valueController.text),
        'category': _categoryController.text,
      });
      Navigator.pop(context);
    } catch (e) {
      print('Erro ao atualizar despesa: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editando Despesa'),
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
              onPressed: _updateExpense,
              child: Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
