import 'package:expense_tracker/component/component.dart';
import 'package:expense_tracker/db/expense_db.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/pages/insert_budget_page.dart';
import 'package:expense_tracker/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //form key
  final _formKey = GlobalKey<FormState>();
  static int? userId;
  static String? username;
  //editing controller
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  static String? loginError;
  static DataBaseHelper? _dbHelper;
  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DataBaseHelper.instance;
      loginError = "hi";
    });
  }

  @override
  Widget build(BuildContext context) {
    // screen size
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.01,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ExpenseTrackerIMG(size: size),
                    SizedBox(height: size.height * 0.03),
                    EmailField(
                        emailController: mailController,
                        user: SignUp(),
                        size: size),
                    SizedBox(height: size.height * 0.04),
                    PassWordField(
                        passwordController: passwordController, size: size),
                    ErrorText(size: size, loginError: loginError),
                    SizedBox(height: size.height * 0.01),
                    AppButton(
                        onTap: () => signIn(
                            mailController.text, passwordController.text),
                        text: "Login",
                        size: size),
                    SizedBox(height: size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () => checkUser(),
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    var form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      List<SignUp> user = await _dbHelper!.fetchUser(email, password);
      if (user.isNotEmpty) {
        if (user.first.email == email && user.first.password == password) {
          setState(() {
            userId = user.first.id;
            username = user.first.firstName! + " " + user.first.secondName!;
            loginError = "hi";
          });

          Navigator.pushAndRemoveUntil(
              (context),
              MaterialPageRoute(builder: (context) => const BudgetInputPage()),
              (route) => false);
        }
      } else {
        setState(() {
          loginError = "User not found!";
          Fluttertoast.showToast(msg: "User not found!");
        });
      }
    }
  }

//check if user table has data
  checkUser() async {
    int numOfUsers = await _dbHelper!.fetchAllUser();
    if (numOfUsers == 0) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const RegisterPage()));
    } else {
      setState(() {
        loginError = "Can't open multiple account";
      });
    }
  }
}


