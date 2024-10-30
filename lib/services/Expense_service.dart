import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseService {
  final CollectionReference _expenseCollection = FirebaseFirestore.instance.collection('expenses');

  // Adicionar despesa
  Future<void> addExpense(Expense expense) async {
    await _expenseCollection.add(expense.toMap());
  }

  // Atualizar despesa
  Future<void> updateExpense(Expense expense) async {
    await _expenseCollection.doc(expense.id).update(expense.toMap());
  }

  // Excluir despesa
  Future<void> deleteExpense(String id) async {
    await _expenseCollection.doc(id).delete();
  }

  // Obter despesas
  Stream<List<Expense>> getExpenses() {
    return _expenseCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expense.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
