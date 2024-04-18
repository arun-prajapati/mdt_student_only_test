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

  @override
  void initState() {
    // Timer(Duration(seconds: 2), () {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => Welcome()));
    // });
    super.initState();
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
            "assets/s_logo.png",
            height: 206,
            width: 265,
            //fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
