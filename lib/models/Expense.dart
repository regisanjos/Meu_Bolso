class Expense {
  final String id;
  final String title;
  final double value;
  final String category;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.value,
    required this.category,
    required this.date,
  });

  
  factory Expense.fromFirestore(Map<String, dynamic> data, String id) {
    return Expense(
      id: id,
      title: data['title'] ?? '',
      value: (data['value'] ?? 0).toDouble(),
      category: data['category'] ?? 'Outros',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

 
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'value': value,
      'category': category,
      'date': date,
    };
  }
}
