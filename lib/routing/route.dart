import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:Smart_Theory_Test/main.dart';
import 'package:Smart_Theory_Test/main.dart';
import 'package:Smart_Theory_Test/views/AIRecommendations/LessonRecommendations.dart';
import 'package:Smart_Theory_Test/views/AIRecommendations/TheoryRecommondation.dart';
import 'package:Smart_Theory_Test/views/Bookings/MyBookings.dart';
import 'package:Smart_Theory_Test/views/Calendar/calendar.dart';
import 'package:Smart_Theory_Test/views/DrawerScreens/AboutUs.dart';
import 'package:Smart_Theory_Test/views/DrawerScreens/ContactUs.dart';
import 'package:Smart_Theory_Test/views/DrawerScreens/Help.dart';
import 'package:Smart_Theory_Test/views/DrawerScreens/Pricing.dart';
import 'package:Smart_Theory_Test/views/DrawerScreens/FAQ.dart';
import 'package:Smart_Theory_Test/views/DrawerScreens/Settings.dart';
import 'package:Smart_Theory_Test/views/DrawerScreens/TestStructure.dart';
import 'package:Smart_Theory_Test/views/ChangePassword/change-password.dart';
import 'package:Smart_Theory_Test/views/Driver/BookPassAssistLesson/BookPassAssistLesson.dart';
import 'package:Smart_Theory_Test/views/Driver/BookTest/BookTestForm.dart';
import 'package:Smart_Theory_Test/views/Driver/HazardPerception/hazardPerception_VideosList.dart';
import 'package:Smart_Theory_Test/views/HighwayCode/HigwayCode.dart';
import 'package:Smart_Theory_Test/views/Home/home_view.dart';
import 'package:Smart_Theory_Test/views/Login/login.dart';
import 'package:Smart_Theory_Test/views/Login/social_login_email_register.dart';
import 'package:Smart_Theory_Test/views/Login/welcome.dart';
import 'package:Smart_Theory_Test/views/Splash/splash_page.dart';
import 'package:Smart_Theory_Test/views/Driver/BookLession/BookLessionForm.dart';
import 'package:Smart_Theory_Test/views/Driver/HazardPerception/hazardPerception_Test.dart';
import 'package:Smart_Theory_Test/views/Driver/HazardPerception/hazardPerception_TestReplay.dart';
import 'package:Smart_Theory_Test/views/Driver/HazardPerception/hazardPerception_Confirmation.dart';
import 'package:Smart_Theory_Test/views/Driver/HazardPerception/hazardPerception_Options.dart';
import 'package:Smart_Theory_Test/views/Driver/HazardPerception/hazardPerception_Tutorial.dart';
import 'package:Smart_Theory_Test/views/Driver/HazardPerception/hazardPerception_TestResult.dart';
import 'package:Smart_Theory_Test/views/Driver/DriverProfile.dart';
import 'package:Smart_Theory_Test/views/Driver/PracticeTheoryTest.dart';
import 'package:Smart_Theory_Test/views/Payment/CardPayment.dart';

import '../views/AIRecommendations/TestRecommendations.dart';
import '../views/Login/register.dart';
import 'route_names.dart' as routes;

String? user;
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case routes.WelcomeRoute:
      return MaterialPageRoute(builder: (context) => Welcome());
    case routes.AboutUsRoute:
      return MaterialPageRoute(builder: (context) => AboutUs());
    case routes.ContactUsRoute:
      return MaterialPageRoute(builder: (context) => ContactUs());
    case routes.HelpRoute:
      return MaterialPageRoute(builder: (context) => Help());
    case routes.FAQRoute:
      return MaterialPageRoute(builder: (context) => TileApp());
    case routes.SettingRoute:
      return MaterialPageRoute(builder: (context) => Settings());
    case routes.HomeRoute:
      return MaterialPageRoute(builder: (context) => HomeView());
    case routes.LoginRoute:
      return MaterialPageRoute(builder: (context) => SignInForm());
    case routes.SocialEmailRegistration:
      return MaterialPageRoute(
          builder: (context) => SocialLoginEmailRegister(), settings: settings);
    case routes.DriverProfileRoute:
      return MaterialPageRoute(builder: (context) => DriverProfile());
    case routes.ChangePasswordRoute:
      return MaterialPageRoute(builder: (context) => ChangePassword());
    case routes.RegisterRoute:
    // return MaterialPageRoute(builder: (context) => Register());
    case routes.SplashRoute:
      return MaterialPageRoute(builder: (context) => SplashScreen());
    case routes.HomePageRoute:
      return MaterialPageRoute(builder: (context) => HomePage());
    case routes.HighwayCodeRoute:
      return MaterialPageRoute(builder: (context) => HighwayCode());
    case routes.MyBookingRoute:
      return MaterialPageRoute(builder: (context) => MyBooking());

    // case routes.BiddingDetailRoute:
    //   return MaterialPageRoute(builder: (context) => BiddingDetails());
    case routes.BookTestFormRoute:
      return MaterialPageRoute(builder: (context) => BookTestForm());
    case routes.BookLessionFormRoute:
      return MaterialPageRoute(
          builder: (context) => BookLessionForm(), settings: settings);
    // case routes.BookPassAssistLessonsFormRoute:
    //   return MaterialPageRoute(
    //       builder: (context) => BookPassAssistLessonForm());
    case routes.PracticeTheoryTestRoute:
      return MaterialPageRoute(builder: (context) => PracticeTheoryTest());
    case routes.HazardPerceptionTestRoute:
      return MaterialPageRoute(builder: (context) => HazardPerceptionTest());
    case routes.HazardPerceptionTestReplayRoute:
      return MaterialPageRoute(
          builder: (context) => HazardPerceptionTestReplay());
    case routes.HazardPerceptionConfirmationRoute:
      return MaterialPageRoute(
          builder: (context) => HazardPerceptionConfirmation());
    case routes.HazardPerceptionOptionsRoute:
      return MaterialPageRoute(builder: (context) => HazardPerceptionOptions());
    case routes.HazardPerceptionTutorialRoute:
      return MaterialPageRoute(
          builder: (context) => HazardPerceptionTutorial());
    case routes.HazardPerceptionTestResultRoute:
      return MaterialPageRoute(
          builder: (context) => HazardPerceptionTestResult(),
          settings: settings);
    case routes.HazardPerceptionVideosListRoute:
      return MaterialPageRoute(
          builder: (context) => HazardPerceptionVideosList());
    // case routes.CalendarRoute:
    //   return MaterialPageRoute(builder: (context) => Calender());
    // case routes.CardPaymentRoute:
    //   return MaterialPageRoute(
    //       builder: (context) => CardPayment(), settings: settings);

    case routes.PricingRoute:
      return MaterialPageRoute(builder: (context) => Pricing());

    case routes.TestStructRoute:
      return MaterialPageRoute(builder: (context) => TestStructure());

    // case routes.LessonRecommendationsRoute:
    //   return MaterialPageRoute(builder: (context) => LessonRecommendations());

    // case routes.TestRecommendationsRoute:
    //   return MaterialPageRoute(builder: (context) => TestRecommendations());
    case routes.TheoryRecommendationsRoute:
      return MaterialPageRoute(builder: (context) => TheoryRecommendations());
//      var userName = settings.arguments as String;
//      return MaterialPageRoute(
//          builder: (context) => HomeView(userName: userName));
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No path for ${settings.name}'),
          ),
        ),
      );
  }
}
