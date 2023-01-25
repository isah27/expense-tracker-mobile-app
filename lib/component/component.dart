import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../model/expense_model.dart';
import '../pages/login_page.dart';
import '../useful method/usefull_methods.dart';

class ExpenseTrackerIMG extends StatelessWidget {
  const ExpenseTrackerIMG({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.25,
      child: Image.asset(
        "assets/tracker.png",
        fit: BoxFit.contain,
      ),
    );
  }
}

class BackNavigation extends StatelessWidget {
  const BackNavigation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 35.sp,
            ))
      ],
    );
  }
}

class FirstNameField extends StatelessWidget {
  const FirstNameField({
    Key? key,
    required this.firstNameController,
    required this.user,
    required this.size,
  }) : super(key: key);

  final TextEditingController firstNameController;
  final SignUp user;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: firstNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Enter your first name");
        }
        if (value.length < 3) {
          return ("Enter valid name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        user.firstName = value!;
      },
      style: TextStyle(
        fontSize: sizeAble(14.sp),
      ),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person, size: sizeAble(20.sp)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.1,
          vertical: size.height * 0.02,
        ),
        hintText: "First Name",
        hintStyle: TextStyle(fontStyle: FontStyle.italic),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.03),
        ),
      ),
    );
  }
}

class LastNameField extends StatelessWidget {
  const LastNameField({
    Key? key,
    required this.secondNameController,
    required this.user,
    required this.size,
  }) : super(key: key);

  final TextEditingController secondNameController;
  final SignUp user;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: secondNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Enter your first name");
        }

        return null;
      },
      onSaved: (value) {
        user.secondName = value!;
      },
      style: TextStyle(
        fontSize: sizeAble(14.sp),
      ),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person, size: sizeAble(20.sp)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.1,
          vertical: size.height * 0.02,
        ),
        hintText: "Last Name",
        hintStyle: TextStyle(fontStyle: FontStyle.italic),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.03),
        ),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({
    Key? key,
    required this.emailController,
    required this.user,
    required this.size,
  }) : super(key: key);

  final TextEditingController emailController;
  final SignUp user;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        fontSize: sizeAble(14.sp),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your email");
        }
        // reg expression for mail validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        user.email = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email, size: sizeAble(20.sp)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.1,
          vertical: size.height * 0.02,
        ),
        hintText: "Email",
        hintStyle: TextStyle(fontStyle: FontStyle.italic),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.03),
        ),
      ),
    );
  }
}

class PassWordField extends StatelessWidget {
  const PassWordField({
    Key? key,
    required this.passwordController,
    required this.size,
  }) : super(key: key);

  final TextEditingController passwordController;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      style: TextStyle(
        fontSize: sizeAble(14.sp),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Password is require for registration");
        }
        if (value.length < 6) {
          return ("Enter valid password(Min. 6 Character)");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, size: sizeAble(20.sp)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.1,
          vertical: size.height * 0.02,
        ),
        hintStyle: TextStyle(fontStyle: FontStyle.italic),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.03),
        ),
      ),
    );
  }
}

class ConfirmPassword extends StatelessWidget {
  const ConfirmPassword({
    Key? key,
    required this.confirmPasswordController,
    required this.passwordController,
    required this.user,
    required this.size,
  }) : super(key: key);

  final TextEditingController confirmPasswordController;
  final TextEditingController passwordController;
  final SignUp user;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      obscureText: true,
      controller: confirmPasswordController,
      style: TextStyle(
        fontSize: sizeAble(14.sp),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return ("This field is require for registration");
        }
        if (passwordController.text != value) {
          return ("Password dont match");
        }
        return null;
      },
      onSaved: (value) {
        user.password = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, size: sizeAble(20.sp)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.1,
          vertical: size.height * 0.02,
        ),
        hintStyle: TextStyle(fontStyle: FontStyle.italic),
        hintText: "Confirm password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.03),
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    required this.onTap,
    required this.text,
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;
  final Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(size.width * 0.03),
      color: Colors.indigo,
      child: MaterialButton(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.1,
          vertical: size.height * 0.02,
        ),
        minWidth: size.width * 0.85,
        onPressed: () => onTap(),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: sizeAble(14.sp),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ErrorText extends StatelessWidget {
  const ErrorText({
    Key? key,
    required this.size,
    required this.loginError,
  }) : super(key: key);

  final Size size;
  final String? loginError;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.02,
      child: Text(
        loginError!,
        style: TextStyle(
            color: loginError!.length != 2 ? Colors.red : Colors.white,
            fontStyle: FontStyle.italic),
      ),
    );
  }
}

class AppText extends StatelessWidget {
  const AppText({
    Key? key,
    required this.controller,
    required this.size,
    required this.hintText,
    required this.onValidate,
    this.textInputType = TextInputType.name,
  }) : super(key: key);

  final TextEditingController controller;
  final Function(String? value) onValidate;
  final String hintText;
  final Size size;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: controller,
      keyboardType: textInputType,
      validator: (value) {
        return onValidate(value);
      },
      onSaved: (value) {
        controller.text = value!;
      },
      style: TextStyle(
        fontSize: sizeAble(14.sp),
      ),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.02,
        ),
        hintText: hintText,
        hintStyle: TextStyle(fontStyle: FontStyle.italic),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.02),
        ),
      ),
    );
  }
}

class AppCustomAppBar extends StatelessWidget {
  const AppCustomAppBar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.03,
        horizontal: size.width * 0.03,
      ),
      decoration: BoxDecoration(
        color: Colors.indigo,
      ),
      child: Text(
        "WELCOME " + LoginPageState.username!.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w300,
          color: Colors.white,
          fontSize: 14.sp,
        ),
        overflow: TextOverflow.fade,
      ),
    );
  }
}
