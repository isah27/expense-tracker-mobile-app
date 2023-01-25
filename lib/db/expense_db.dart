import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:expense_tracker/model/expense_model.dart';

class DataBaseHelper {
  static const _dbName = 'ExpenseDB.db';
  static const _dbVersion = 1;

  //singleton constructor
  DataBaseHelper._();
  static final DataBaseHelper instance = DataBaseHelper._();

  Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String path = join(dataDirectory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: onCreateDB);
  }

  onCreateDB(Database db, int version) async {
    db.execute('''
    CREATE TABLE ${Expense.tblExpense}(
      ${Expense.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${Expense.colUserId} INTEGER NOT NULL,
      ${Expense.colBId} INTEGER NOT NULL,
      ${Expense.colDescription} TEXT NOT NULL,
      ${Expense.colPrice} TEXT NOT NULL,
      ${Expense.colDate}  TEXT NOT NULL
    )
''');
    db.execute('''
    CREATE TABLE ${ChartExpense.tblSumInDays}(
      ${ChartExpense.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${ChartExpense.colUserId} INTEGER NOT NULL,
      ${ChartExpense.colBId} INTEGER NOT NULL,
      ${ChartExpense.colPrice} TEXT NOT NULL,
      ${ChartExpense.colDate}  TEXT NOT NULL
    )
''');
    db.execute('''
    CREATE TABLE ${Budget.tblBudget}(
      ${Budget.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${Budget.colUserId} INTEGER NOT NULL,
      ${Budget.colDesc} TEXT,
      ${Budget.colAmount}  INTEGER NOT NULL
    )
''');
    db.execute('''
    CREATE TABLE ${SignUp.tbluser}(
      ${SignUp.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${SignUp.colFirstName} TEXT NOT NULL,
      ${SignUp.colSecondName}  TEXT NOT NULL,
      ${SignUp.colEmail} TEXT NOT NULL,
      ${SignUp.colPassword} TEXT NOT NULL
    )
''');
  }

  // insert data into user table
  Future<int> insertUser(SignUp user) async {
    Database? db = await instance.database;
    return await db!.insert(SignUp.tbluser, user.tomap());
  }

  // update data in user table
  Future<int> updateUser(SignUp user) async {
    Database? db = await instance.database;
    return await db!.update(SignUp.tbluser, user.tomap(),
        where: '${SignUp.colId}=?', whereArgs: [user.id]);
  }

  // delete data from user table and every other related data in other tables
  deleteUser(int userId) async {
    Database? db = await instance.database;
    await db!.delete(SignUp.tbluser,
        where: '${SignUp.colId} = ?', whereArgs: [userId]);
    await db.delete(Budget.tblBudget,
        where: "${Budget.colUserId}=?", whereArgs: [userId]);
    await db.delete(Expense.tblExpense,
        where: "${Expense.colBId}=?", whereArgs: [userId]);
    await db.delete(ChartExpense.tblSumInDays,
        where: "${ChartExpense.colBId}=?", whereArgs: [userId]);
  }

  //fetch data from user table
  Future<List<SignUp>> fetchUser(String email, String password) async {
    Database? db = await instance.database;
    List<Map> user = await db!.query(SignUp.tbluser,
        where: "${SignUp.colEmail}=? and ${SignUp.colPassword}=?",
        whereArgs: [email, password]);
    return user.isEmpty ? [] : user.map((o) => SignUp.fromMap(o)).toList();
  }

  //check if user table has a record
  Future<int> fetchAllUser() async {
    Database? db = await instance.database;
    List<Map> user = await db!.query(
      SignUp.tbluser,
    );
    return user.isEmpty ? 0 : 1;
  }

  // insert data into budget table
  Future<int> insertBudget(Budget budget) async {
    Database? db = await instance.database;
    return await db!.insert(Budget.tblBudget, budget.tomap());
  }

  // update data in budget table
  Future<int> updateBudget(Budget budget) async {
    Database? db = await instance.database;
    return await db!.update(Budget.tblBudget, budget.tomap(),
        where: '${Budget.colId}=?', whereArgs: [budget.id]);
  }

  // delete data from budget table
  deleteBudget(int id) async {
    Database? db = await instance.database;
    await db!.delete(Budget.tblBudget,
        where: '${Budget.colId} = ?', whereArgs: [id]);
    await db.delete(Expense.tblExpense,
        where: "${Expense.colBId}=?", whereArgs: [id]);
    await db.delete(ChartExpense.tblSumInDays,
        where: "${ChartExpense.colBId}=?", whereArgs: [id]);
  }

  //fetch data from budget table
  Future<List<Budget>> fetchBudget(int id) async {
    Database? db = await instance.database;
    List<Map> budget = await db!.query(Budget.tblBudget,
        where: "${Budget.colUserId}=?",
        whereArgs: [id],
        orderBy: Budget.colAmount);
    return budget.isEmpty ? [] : budget.map((o) => Budget.fromMap(o)).toList();
  }

// insert if date is not in database else update tblSumInDays table if date exist ORDER BY userId DESC LIMIT 1
  Future<int> insertOrUpdateSumInDays(ChartExpense expense) async {
    Database? db = await instance.database;
    List<Map> queryResults = (await db!.rawQuery(
        'SELECT * FROM ${ChartExpense.tblSumInDays} WHERE ${ChartExpense.colBId}=? and ${ChartExpense.colDate}=?',
        ["${expense.bId}", "${expense.date}"]));
    List<ChartExpense> queryResult =
        queryResults.map((e) => ChartExpense.fromMap(e)).toList();
    if (queryResult.isNotEmpty) {
      int dbPrice = int.parse(queryResult.first.price!);
      int dbId = queryResult.first.id!;
      int incomingPrice = int.parse(expense.price!);
      int finalResult = dbPrice + incomingPrice;
      return await db.update(
          ChartExpense.tblSumInDays,
          ChartExpense(
                  id: expense.id,
                  userId: expense.userId,
                  bId: expense.bId,
                  price: finalResult.toString(),
                  date: expense.date)
              .tomap(),
          where: '${Expense.colId}=?',
          whereArgs: [dbId]);
    } else {
      return await db.insert(ChartExpense.tblSumInDays, expense.tomap());
    }
  }

  // update SumIndays table if user modify any expenses
  Future<int> updateSumInDays(ChartExpense expense, int initPrice) async {
    Database? db = await instance.database;
    int modifiedPrice = int.parse(expense.price!);
    List<Map> queryResults = (await db!.rawQuery(
        'SELECT * FROM ${ChartExpense.tblSumInDays} WHERE ${ChartExpense.colBId}=? and ${ChartExpense.colDate} =?',
        ["${expense.bId}", "${expense.date}"]));
    List<ChartExpense> queryResult =
        queryResults.map((e) => ChartExpense.fromMap(e)).toList();
    if (queryResult.isNotEmpty) {
      int dbPrice = int.parse(queryResult.first.price!);
      int dbId = queryResult.first.id!;
      int inserPrice = (modifiedPrice - initPrice) + dbPrice;
      return await db.update(
          ChartExpense.tblSumInDays,
          ChartExpense(
                  id: expense.id,
                  userId: expense.userId,
                  bId: expense.bId,
                  price: inserPrice.toString(),
                  date: expense.date)
              .tomap(),
          where: '${Expense.colId}=?',
          whereArgs: [dbId]);
    } else {
      return 0;
    }
  }

  //update SumInDays table if user delete expense
  Future<int> deleteFromSumInDays(ChartExpense expense) async {
    Database? db = await instance.database;
    List<Map> queryResults = await db!.rawQuery(
        'SELECT * FROM ${ChartExpense.tblSumInDays} WHERE ${ChartExpense.colBId}=? and ${ChartExpense.colDate}=?',
        ["${expense.bId}", "${expense.date}"]);
    List<ChartExpense> queryResult =
        queryResults.map((e) => ChartExpense.fromMap(e)).toList();
    if (queryResult.isNotEmpty) {
      int dbPrice = int.parse(queryResult.first.price!);
      int dbId = queryResult.first.id!;
      int inserPrice = dbPrice - int.parse(expense.price!);
      return await db.update(
          ChartExpense.tblSumInDays,
          ChartExpense(
                  id: expense.id,
                  userId: expense.userId,
                  bId: expense.bId,
                  price: inserPrice.toString(),
                  date: expense.date)
              .tomap(),
          where: '${Expense.colId}=?',
          whereArgs: [dbId]);
    } else {
      return 0;
    }
  }

  // delete data from SumInDays table if the value is equal or less than zero
  deleteChartExpense() async {
    Database? db = await instance.database;
    await db!.delete(ChartExpense.tblSumInDays,
        where: '${ChartExpense.colPrice} <= ?', whereArgs: [0]);
  }

  //fetch all data from SumInDays table ORDER BY date
  Future<List<ChartExpense>> fetchSumInDays(int? bId) async {
    Database? db = await instance.database;
    List<Map> expense = await db!.query(ChartExpense.tblSumInDays,
        where: "${ChartExpense.colBId}=?",
        whereArgs: [bId],
        orderBy: ChartExpense.colDate);
    return expense.isEmpty
        ? []
        : expense.map((o) => ChartExpense.fromMap(o)).toList();
  }

  // insert data into expense table
  Future<int> insertExpense(Expense expense) async {
    Database? db = await instance.database;
    return await db!.insert(Expense.tblExpense, expense.tomap());
  }

  // update data in expense table
  Future<int> updateExpense(Expense expense) async {
    Database? db = await instance.database;
    return await db!.update(Expense.tblExpense, expense.tomap(),
        where: '${Expense.colId}=?', whereArgs: [expense.id]);
  }

  // delete data from expense table
  Future<int> deleteExpense(int id) async {
    Database? db = await instance.database;
    return await db!.delete(Expense.tblExpense,
        where: '${Expense.colId} = ?', whereArgs: [id]);
  }

  //fetch data from expense table
  Future<List<Expense>> fetchExpense(int? bId) async {
    Database? db = await instance.database;
    List<Map> expense = await db!.query(Expense.tblExpense,
        where: "${Expense.colBId}=?",
        whereArgs: [bId],
        orderBy: Expense.colDate);
    return expense.isEmpty
        ? []
        : expense.map((o) => Expense.fromMap(o)).toList();
  }
}
