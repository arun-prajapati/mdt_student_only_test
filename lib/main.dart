import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_app/services/auth.dart';
import 'package:student_app/services/navigation_service.dart';
import 'package:student_app/views/Home/home_content_mobile.dart';
import 'package:student_app/views/Login/welcome.dart';
import 'package:student_app/views/Splash/splash.dart';
import 'package:provider/provider.dart';
import 'package:student_app/routing/route.dart' as router;
//import 'locater.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'enums/Autentication_status.dart';
import 'locater.dart';

const bool debugEnableDeviceSimulator = true;
//final storage = FlutterSecureStorage();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: invalid_use_of_visible_for_testing_member
  // SharedPreferences.setMockInitialValues({});

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  setupLocator();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        //locale: DevicePreview.ofDeviceOrientation(context).locale, // <--- Add the locale
        //builder: DevicePreview.appBuilder,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Poppins'),
        ),
        navigatorKey: locator<NavigationService>().navigatorKey,
        home: HomePage(),
        onGenerateRoute: router.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    return Consumer<AuthProvider>(
      builder: (context, user, child) {
        switch (user.status) {
          case Status.Uninitialized:
            return SplashScreen();
//          case Status.RouteLogin:
//          case Status.Authenticating:
//            return SignInForm();
          case Status.Unauthenticated:
            return Welcome();
          case Status.Authenticating:
            return Welcome();
          case Status.Authenticated:
            //  return LayoutTemplate(user: user.user);
            // return MyBooking();
            return HomeScreen();
          //    return ChangeNotifierProvider(
          // builder: (context) => TodoProvider(authProvider),
          //    child: HomeView(),
          //  );
          default:
            return Welcome();
        }
      },
    );
  }
}
