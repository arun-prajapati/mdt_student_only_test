import 'package:flutter/material.dart';
import 'package:student_app/views/Home/home_content_mobile.dart';

import '../../responsive/screen_type_layout.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: HomeScreen(), key: null, tablet: HomeScreen(), desktop: HomeScreen(),
      //  desktop: HomeContentDesktop(),
    );
  }
}
