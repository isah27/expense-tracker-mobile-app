import 'package:expense_tracker/db/expense_db.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../component/component.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //form key
  final _formKey = GlobalKey<FormState>();
  //SignUp class object
  static SignUp user = SignUp();
  // editing controllers
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  static DataBaseHelper? _dbHelper;
  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DataBaseHelper.instance;
    });
  }

  @override
  Widget build(BuildContext context) {
    // screen size
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: size.height * 0.01),
            // back navigation
            const BackNavigation(),
            SizedBox(height: size.height * 0.01),
            CreateNewAcctText(size: size),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * 0.04),
                    topRight: Radius.circular(size.width * 0.04),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.01,
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: size.height * 0.04),

                          //firstName field
                          FirstNameField(
                              firstNameController: firstNameController,
                              user: user,
                              size: size),
                          SizedBox(height: size.height * 0.04),
                          //secondName field
                          LastNameField(
                              secondNameController: secondNameController,
                              user: user,
                              size: size),
                          SizedBox(height: size.height * 0.04),
                          //email field
                          EmailField(
                              emailController: emailController,
                              user: user,
                              size: size),
                          SizedBox(height: size.height * 0.04),
                          //password field
                          PassWordField(
                              passwordController: passwordController,
                              size: size),
                          SizedBox(height: size.height * 0.04),
                          //confirm field
                          ConfirmPassword(
                              confirmPasswordController:
                                  confirmPasswordController,
                              passwordController: passwordController,
                              user: user,
                              size: size),
                          SizedBox(height: size.height * 0.04),
                          //Register button
                          AppButton(
                              size: size,
                              text: "Sign Up",
                              onTap: () => signUp()),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signUp() async {
    var form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      await _dbHelper!.insertUser(user);
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    }
  }
}

class CreateNewAcctText extends StatelessWidget {
  const CreateNewAcctText({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.02,
      ),
      child: Row(
        children: [
          Text(
            "Create new account",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
