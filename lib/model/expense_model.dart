class Expense {
  static const tblExpense = 'expense';
  static const colId = 'id';
  static const colUserId = 'userId';
  static const colBId = 'bId';
  static const colDescription = 'description';
  static const colPrice = 'price';
  static const colDate = 'date';

  Expense(
      {this.id,
      this.description,
      this.price,
      this.date,
      this.bId,
      this.userId});

  Expense.fromMap(Map<dynamic, dynamic> map) {
    id = map[colId];
    userId = map[colUserId];
    bId = map[colBId];
    description = map[colDescription];
    price = map[colPrice];
    date = map[colDate];
  }

  int? id;
  int? userId;
  int? bId;
  String? description;
  String? price;
  String? date;
  Map<String, dynamic> tomap() {
    var map = <String, dynamic>{
      colBId: bId,
      colUserId: userId,
      colDescription: description,
      colPrice: price,
      colDate: date
    };
    if (id != null) map[colId] = id;
    return map;
  }
}

class ChartExpense {
  static const tblSumInDays = 'sumInDays';
  static const colId = 'id';
  static const colUserId = 'userId';
  static const colBId = 'bId';
  static const colPrice = 'price';
  static const colDate = 'date';

  ChartExpense({this.id, this.price, this.date, this.bId, this.userId});

  ChartExpense.fromMap(Map<dynamic, dynamic> map) {
    id = map[colId];
    userId = map[colUserId];
    bId = map[colBId];
    price = map[colPrice];
    date = map[colDate];
  }

  int? id;
  int? userId;
  int? bId;
  String? price;
  String? date;
  Map<String, dynamic> tomap() {
    var map = <String, dynamic>{colUserId:userId, colBId: bId, colPrice: price, colDate: date};
    if (id != null) map[colId] = id;
    return map;
  }
}

class Budget {
  static const tblBudget = 'budget';
  static const colId = 'id';
  static const colUserId = 'userId';
  static const colDesc = 'description';
  static const colAmount = 'amount';

  Budget({this.id, this.description, this.amount, this.userId});

  Budget.fromMap(Map<dynamic, dynamic> map) {
    id = map[colId];
    userId = map[colUserId];
    description = map[colDesc];
    amount = map[colAmount];
  }

  int? id;
  int? userId;
  int? amount;
  String? description;
  Map<String, dynamic> tomap() {
    var map = <String, dynamic>{
      colUserId: userId,
      colDesc: description,
      colAmount: amount
    };
    if (id != null) map[colId] = id;
    return map;
  }
}

class SignUp {
  static const tbluser = 'user';
  static const colId = 'id';
  static const colFirstName = 'firstName';
  static const colSecondName = 'secondName';
  static const colEmail = 'email';
  static const colPassword = 'password';

  SignUp({this.id, this.firstName, this.secondName, this.email, this.password});

  SignUp.fromMap(Map<dynamic, dynamic> map) {
    id = map[colId];
    firstName = map[colFirstName];
    secondName = map[colSecondName];
    email = map[colEmail];
    password = map[colPassword];
  }

  int? id;
  String? firstName;
  String? secondName;
  String? email;
  String? password;
  Map<String, dynamic> tomap() {
    var map = <String, dynamic>{
      colFirstName: firstName,
      colSecondName: secondName,
      colEmail: email,
      colPassword: password
    };
    if (id != null) map[colId] = id;
    return map;
  }
}
