import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_database_app/controller.dart';
import 'package:freelancing_database_app/home.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Base design size (width x height)
      builder: (context, child) {
        return GetMaterialApp(
          theme: ThemeData(
              //     primaryColor: Colors.grey.shade300,
              //     secondaryHeaderColor: Colors.grey.shade300,
              colorScheme: ColorScheme.light(
            primary: Colors.teal,
            secondary: Colors.teal,
          )),
          onInit: () {
            Get.put(
              HomeController(),
            );
          },
          debugShowCheckedModeBanner: false,
          title: 'Freelaning Database App',
          home: FiverrHomepage(),
        );
      },
    );
  }
}
