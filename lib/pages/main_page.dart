import 'package:expense_tracker/db/expense_db.dart';
import 'package:expense_tracker/model/chart_model.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/pages/chart_page.dart';
import 'package:expense_tracker/pages/dropdown_page/expense_history.dart';
import 'package:expense_tracker/pages/insert_budget_page.dart';
import 'package:expense_tracker/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../useful method/usefull_methods.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final bu = const BudgetInputPage();
  //default vale for dropdow
  dynamic currentItem = "Home";
  //form key
  final _formKey = GlobalKey<FormState>();
  // var to receive selected budget id
  static int? bId = BudgetInputPageState.bId;
  // var to receive selected budget amount
  static int? bAmount = BudgetInputPageState.bAmount;
  //balance
  static int balance = 0;
  //total expense
  static int totalExpense = 0;
  //currency
  final oCcy = NumberFormat("#,##0.00", "en_US");

  //editing controller
  static final TextEditingController budgetDescriptionController =
      TextEditingController();
  static final TextEditingController budgetCostController =
      TextEditingController();
  static DataBaseHelper? dbHelper;
  static List<ChartExpense> data = [];
  static int initPrice = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      dbHelper = DataBaseHelper.instance;
      fetchChartExpense();
    });
    fetchChartExpense();
  }

  List<ChartData> pieData = [];

  static Expense expense = Expense();
  static ChartExpense chartExpense = ChartExpense();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Map<String, dynamic> pages = {
      "Home": const MainPage(),
      'Expense log': const ExpenseHistory(),
      'Switch Budget': const BudgetInputPage(),
      'Delete Account': const LoginPage()
    };

    final descriptionField = TextFormField(
      controller: budgetDescriptionController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your expense description");
        }
        return null;
      },
      onSaved: (value) {
        budgetDescriptionController.text = value!;
        setState(() {
          expense.description = value;
        });
      },
      style: TextStyle(fontSize: sizeAble(14.sp)),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.02,
        ),
        hintText: "Expense Description",
        prefixIcon: Icon(Icons.description, size: 20.sp),
        hintStyle: TextStyle(fontStyle: FontStyle.italic),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.02),
        ),
      ),
    );
    final costField = TextFormField(
      autofocus: false,
      controller: budgetCostController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter the price");
        }
        // reg expression for expenses cost validation
        if (!RegExp("^[0-9+]+").hasMatch(value)) {
          return ("Enter a valid price");
        }
        //cheking the balance
        if (expense.id == null) {
          if ((balance - int.parse(value)) < 0) {
            return ("Insufficient fund(Top-Up your account)");
          }
        } else if (expense.id != null) {
          balance += initPrice;
          if ((balance - int.parse(value)) < 0) {
            return ("Insufficient fund(Top-Up your account)");
          }
        }

        return null;
      },
      style: TextStyle(
        fontSize: sizeAble(14.sp),
      ),
      onSaved: (value) {
        budgetCostController.text = value!;
        setState(() {
          expense.price = value;
          chartExpense.price = value;
        });
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.02,
        ),
        hintText: "Price",
        prefixIcon: Icon(Icons.monetization_on_rounded, size: 20.sp),
        hintStyle: TextStyle(fontStyle: FontStyle.italic),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.02),
        ),
      ),
    );
    //insert expense button
    final budgetButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(size.width * 0.03),
      color: Colors.indigo,
      child: MaterialButton(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        minWidth: size.width * 0.9,
        onPressed: () => onSubmit(),
        child: Text(
          expense.id != null ? "Update Expense" : "Input Budget",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: BudgetInputPageState.bDescription!.length < 7
                  ? 30
                  : size.width * 0.25,
              child: Text(
                BudgetInputPageState.bDescription!.toUpperCase(),
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.2,
              child: Text(
                oCcy.format(bAmount),
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: 15.sp,
                ),
              ),
            ),
          ],
        ),
        actions: [
          DropdownButton(
            dropdownColor: Colors.indigo[700],

            // down arrow icon
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            // Array list of items
            items: pages.keys.map((dynamic items) {
              return DropdownMenuItem(
                value: items,
                child: Text(
                  items.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            // after selecting the desire option, it will
            // change button value to the selected value

            onChanged: (dynamic newValue) {
              setState(() {
                currentItem = newValue!;
                newValue == "Home"
                    ? null
                    : Navigator.pushReplacement(
                        (context),
                        MaterialPageRoute(
                            builder: (context) => pages[currentItem]));
                //change the number to 1 which means its update in budget-input-page
                if (newValue == 'Delete Account') {
                  setState(() async {
                    await dbHelper!.deleteUser(LoginPageState.userId!);
                  });
                }
              });
            },
            value: currentItem,
          ),
        ],
      ),
      backgroundColor: Colors.indigo,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.04),
                topRight: Radius.circular(size.width * 0.04),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.01),
                    Text(
                      "Enter your expense here",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: Colors.indigo),
                    ),
                    SizedBox(height: size.height * 0.02),
                    descriptionField,
                    SizedBox(height: size.height * 0.03),
                    costField,
                    SizedBox(height: size.height * 0.02),
                    budgetButton,
                    SizedBox(height: size.height * 0.03),
                    SizedBox(
                      height: size.height * 0.5,
                      width: size.width,
                      child: PieChart(data: pieData),
                    ),
                    SizedBox(
                      height: size.height * 0.5,
                      width: size.width,
                      child: data.isEmpty
                          ? null
                          : LineCharts(
                              data: data,
                              width: data.length * 100,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  clearText() {
    budgetCostController.clear();
    budgetDescriptionController.clear();
  }

  onSubmit() async {
    var form = _formKey.currentState;
    if (form!.validate()) {
      expense.date = DateFormat("yyyy-MM-dd").format(DateTime.now());

      form.save();
      expense.bId = bId;
      expense.userId = LoginPageState.userId;
      chartExpense.bId = bId;
      chartExpense.userId = LoginPageState.userId;
      if (expense.id == null) {
        await dbHelper?.insertExpense(expense);
        chartExpense.date = DateFormat("yyyy-MM-dd").format(DateTime.now());
        await dbHelper!.insertOrUpdateSumInDays(chartExpense);
      } else if (expense.id != null) {
        await dbHelper?.updateExpense(expense);
        await dbHelper!.updateSumInDays(chartExpense, initPrice);
        expense.id = null;
      }
      fetchChartExpense();
      clearText();
      data.clear();
    }
  }

  fetchChartExpense() async {
    await dbHelper!.deleteChartExpense();
    List<ChartExpense> x = await dbHelper!.fetchSumInDays(bId);
    int expense = 0;
    setState(() {
      data = x;
      for (int i = 0; i < x.length; i++) {
        expense += int.parse(x[i].price!);
      }
      //totalExpense=x.addAll(x.length)
    });
    totalExpense = expense;

    setState(() {
      balance = bAmount! - expense;
      pieData = [
        ChartData(
          desc: "Total Expense",
          amount: expense,
        ),
        ChartData(
          desc: "Balance",
          amount: balance,
        ),
      ];
    });
  }
}
