import 'dart:io';
import 'package:Smart_Theory_Test/provider/VideoProvider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:Smart_Theory_Test/routing/route.dart' as router;
import 'package:Smart_Theory_Test/services/auth.dart';
import 'package:Smart_Theory_Test/services/navigation_service.dart';
import 'package:Smart_Theory_Test/services/subsciption_provider.dart';
import 'package:Smart_Theory_Test/views/Home/home_content_mobile.dart';
import 'package:Smart_Theory_Test/views/Login/welcome.dart';
import 'package:Smart_Theory_Test/views/Splash/splash.dart';
import 'package:toast/toast.dart';

import 'enums/Autentication_status.dart';
import 'locater.dart';

const bool debugEnableDeviceSimulator = true;
//final storage = FlutterSecureStorage();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  if (Platform.isIOS) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDzBy37Xp2_udzDrnMYdqMxn0IFiZtyEzQ",
            appId: "1:825629569582:ios:aa2dece8930b72964c65bf",
            messagingSenderId: "825629569582",
            projectId: "smart-theory-test"));
  }
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  // ignore: invalid_use_of_visible_for_testing_member
  // SharedPreferences.setMockInitialValues({});
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  setupLocator();
  // PurchaseSub.init();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => VideoIndexProvider()),
      ],
      child: MaterialApp(
        navigatorObservers: [],
        // title: "Student Theory Test",
        //locale: DevicePreview.ofDeviceOrientation(context).locale, // <--- Add the locale
        //builder: DevicePreview.appBuilder,
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          // textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Poppins'),
        ),
        builder: EasyLoading.init(),
        navigatorKey: locator<NavigationService>().navigatorKey,
        home: HomePage(),
        onGenerateRoute: router.generateRoute,
        debugShowCheckedModeBanner: false,
        title: "Smart Theory Test",
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
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
