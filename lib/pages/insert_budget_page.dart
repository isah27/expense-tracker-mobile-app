import 'package:expense_tracker/component/component.dart';
import 'package:expense_tracker/db/expense_db.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/pages/login_page.dart';
import 'package:expense_tracker/pages/main_page.dart';
import 'package:expense_tracker/useful%20method/usefull_methods.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class BudgetInputPage extends StatefulWidget {
  const BudgetInputPage({Key? key}) : super(key: key);

  @override
  State<BudgetInputPage> createState() => BudgetInputPageState();
}

class BudgetInputPageState extends State<BudgetInputPage> {
  //form key
  final _formKey = GlobalKey<FormState>();
  //creating an object for class Budget
  static Budget budget = Budget();
  // list of budget
  List<Budget> budgetData = [];
  //variable to hold selected budget id
  static int? bId;
  //variable to hold selected budget amount
  static int? bAmount;
  //variable to hold selected budget description
  static String? bDescription;
  // budget Description text edit controller
  final budgetDescController = TextEditingController();
// budget amount text edit controller
  final budgetAmountController = TextEditingController();
  //currency format
  final oCcy = NumberFormat("#,##0.00", "en_US");
  static DataBaseHelper? _dbHelper;
  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DataBaseHelper.instance;
    });
    fetchBudget();
  }

  @override
  Widget build(BuildContext context) {
    // screen size
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SingleChildScrollView(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AppCustomAppBar(size: size),
              Container(
                height: size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * 0.03),
                    topRight: Radius.circular(size.width * 0.03),
                  ),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Form(
                  key: _formKey,
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(height: size.height * 0.01),
                        // expense tracker image
                        ExpenseTrackerIMG(size: size),
                        SizedBox(height: size.height * 0.02),
                        // budget description textfield
                        AppText(
                            controller: budgetDescController,
                            size: size,
                            hintText: "Budget Description(optional)",
                            onValidate: (value) {
                              return null;
                            }),
                        SizedBox(height: size.height * 0.02),
                        // budget amont texfield
                        AppText(
                            textInputType: TextInputType.number,
                            controller: budgetAmountController,
                            size: size,
                            hintText: "Budget amount",
                            onValidate: (value) {
                              if (value!.isEmpty) {
                                return ("Please enter your Budget");
                              }
                              // reg expression for mail validation
                              if (!RegExp("^[0-9+]+").hasMatch(value)) {
                                return ("Enter a valid Budget");
                              }
                              //if(value.length>)
                              return null;
                            }),
                        SizedBox(height: size.height * 0.02),
                        // input or update button
                        AppButton(
                            onTap: () {
                              onSubmit();
                            },
                            text: budget.id == null
                                ? "Input Budget"
                                : "Update Budget",
                            size: size),
                        const SizedBox(height: 20),
                        Text(
                          "Budgets",
                          style: TextStyle(
                              color: Colors.indigo.shade600,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        // list of budget
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: size.height * 0.01),
                              color: Colors.white,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            MainPageState.bId =
                                                budgetData[index].id;
                                            MainPageState.bAmount =
                                                budgetData[index].amount;
                                            bDescription =
                                                budgetData[index].description;
                                          });

                                          Navigator.pushAndRemoveUntil(
                                              (context),
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MainPage()),
                                              (route) => false);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: size.height * 0.01),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    oCcy.format(
                                                        budgetData[index]
                                                            .amount),
                                                    style: TextStyle(
                                                        // height: 2,
                                                        fontSize:
                                                            sizeAble(16.sp),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black87),
                                                  ),
                                                  SizedBox(
                                                      width: size.width * 0.03),
                                                  Text(
                                                    budgetData[index]
                                                        .description!,
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize:
                                                            sizeAble(12.sp),
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                // crossAxisAlignment: CrossAxisAlignment.end,
                                                // mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    child: Icon(
                                                      Icons.edit_note_rounded,
                                                      color: Colors.indigo,
                                                      size: sizeAble(28.sp),
                                                    ),
                                                    onTap: () {
                                                      budget.id =
                                                          budgetData[index].id;
                                                      budgetDescController
                                                              .text =
                                                          budgetData[index]
                                                              .description!;
                                                      budgetAmountController
                                                              .text =
                                                          budgetData[index]
                                                              .amount
                                                              .toString();
                                                    },
                                                  ),
                                                  InkWell(
                                                    child: Icon(
                                                      Icons.delete,
                                                      size: sizeAble(28.sp),
                                                      color: Colors.red,
                                                    ),
                                                    onTap: () async {
                                                      _dbHelper!.deleteBudget(
                                                          budgetData[index]
                                                              .id!);
                                                      fetchBudget();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Title(color: Colors.black, child: const Text("title")),

                                      const Divider(),
                                    ],
                                  );
                                },
                                itemCount: budgetData.length,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  clearText() {
    budgetAmountController.clear();
    budgetDescController.clear();
  }

  onSubmit() async {
    var form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      budget.userId = LoginPageState.userId;
      if (budget.id == null) {
        budget.amount = int.parse(budgetAmountController.text);
        budget.description = budgetDescController.text;
        await _dbHelper?.insertBudget(budget);
      } else if (budget.id != null) {
        await _dbHelper?.updateBudget(budget);
        budget.id = null;
      }
      clearText();
      fetchBudget();
    }
  }

  fetchBudget() async {
    List<Budget> x = await _dbHelper!.fetchBudget(LoginPageState.userId!);
    setState(() {
      budgetData = x;
    });
  }
}
