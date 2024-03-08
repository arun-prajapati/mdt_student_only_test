import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Smart_Theory_Test/views/Login/welcome.dart';

import '../../services/auth.dart';
import '../../utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  initAuthProvider(context) async {
    Provider.of<UserProvider>(context).initAuthProvider();
  }

  getStatus() async {
    var sharedPref = await SharedPreferences.getInstance();
    var data = sharedPref.getBool('theoryTestPractice');

    if (data == null) {
      setState(() {});
      //theoryTestPractice();
    }
    log('SharedPref Data $data');
  }

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Welcome()));
//                   Consumer<UserProvider>(
//                     builder: (context, user, child) {
//                       switch (user.status) {
//                         case Status.Uninitialized:
//                           return SplashScreen();
// //          case Status.RouteLogin:
// //          case Status.Authenticating:
// //            return SignInForm();
//                         case Status.Unauthenticated:
//                           return Welcome();
//                         case Status.Authenticating:
//                           return Welcome();
//                         case Status.Authenticated:
//                           //  return LayoutTemplate(user: user.user);
//                           // return MyBooking();
//                           return HomeScreen();
//                         //    return ChangeNotifierProvider(
//                         // builder: (context) => TodoProvider(authProvider),
//                         //    child: HomeView(),
//                         //  );
//                         default:
//                           return Welcome();
//                       }
//                     },
//                   ))
    });
    super.initState();
    getStatus();
  }

  @override
  Widget build(BuildContext context) {
    initAuthProvider(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: AppColors.white),
        //child: welcome(),
        child: Center(
          child: Image.asset(
            "assets/stt_Logo.png",
            height: 206,
            width: 265,
            //fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
