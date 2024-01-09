import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/auth.dart';
import '../../widget/welcome/welcome.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  initAuthProvider(context) async {
    Provider.of<AuthProvider>(context).initAuthProvider();
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
    super.initState();
    getStatus();
  }

  @override
  Widget build(BuildContext context) {
    initAuthProvider(context);
    return Scaffold(
      body: Container(
        child: welcome(),
      ),
    );
  }
}
