class ExpenseModel {
  final String merchantName;
  final String category;
  final double amount;
  final String date;

  ExpenseModel({
    required this.merchantName,
    required this.category,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'merchantName': merchantName,
      'category': category,
      'amount': amount,
      'date': date,
    };
  }

  factory ExpenseModel.fromMap(Map map) {
    return ExpenseModel(
      merchantName: map['merchantName'],
      category: map['category'],
      amount: map['amount'],
      date: map['date'],
    );
  }
}