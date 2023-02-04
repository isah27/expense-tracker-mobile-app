import 'package:expense_tracker/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//   runApp(DevicePreview(
//     enabled: true,
//     builder: (context) => const MyApp(),
//   ));
// }
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense',
        // useInheritedMediaQuery: true,
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const LoginPage(),
      );
    });
  }
}
