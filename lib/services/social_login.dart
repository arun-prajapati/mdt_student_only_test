import 'dart:convert';
import 'dart:developer' as devtools;
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

//import 'package:sign_in_apple/sign_in_apple.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:student_app/enums/Autentication_status.dart';
import 'package:student_app/main.dart';
import 'package:student_app/services/auth.dart';

import '../Constants/global.dart';
import '../locater.dart';
import '../views/spinner.dart';
import '../widget/CustomSpinner.dart';
import 'auth.dart' as auth;
import 'navigation_service.dart';

class SocialLoginService {
  final NavigationService _navigationService = locator<NavigationService>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  late BuildContext globalContext;

  SocialLoginService(BuildContext context) {
    globalContext = context;
  }

  Future<void> googleSignIn() async {
    try {
      devtools.log("In sign in method:");
      showLoader("Loading...");
      await Firebase.initializeApp().then((value) async {
        FirebaseAuth auth = FirebaseAuth.instance;
        final GoogleSignIn googleSignIn = GoogleSignIn(
          scopes: <String>['email'],
        );
        bool checkSignIn = await googleSignIn.isSignedIn();
        if (checkSignIn) googleSignIn.signOut();
        final GoogleSignInAccount? googleSignInAccount =
            await googleSignIn.signIn();
        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );
          try {
            UserCredential authResult =
                await auth.signInWithCredential(credential);
            User? _user = authResult.user;
            //showValidationDialog(globalContext, _user!.toString());
            // IdTokenResult _idTokenResult = await _user.getIdToken(refresh: false);
            // print("Goggle Email..: "+_user.email);
            // print("Google uid..:" +googleSignInAccount.id);
            // print("Google accessToken..:" + googleSignInAuthentication.accessToken);
            Map params = {
              'token': googleSignInAuthentication.accessToken,
              'social_type': 'google',
              'social_site_id': googleSignInAccount.id,
              'email': googleSignInAccount.email,
              'phone': _user?.phoneNumber != null ? _user?.phoneNumber : null,
              'accessType': 'login'
            };
            print("Goggle Email..:");
            devtools.log("Social user: $params");
            socialLoginApi(params);
          } catch (e, s) {
            closeLoader();
            showValidationDialog(globalContext, e.toString());
            await sendErrorLogs("Google Sigin error(First): $e $s");

            devtools.log("Google Exception 1: $e");
            if (e == 'account-exists-with-different-credential') {
              // Toast.show("Account exists with different credential",
              //     duration: Toast.lengthLong, gravity: Toast.bottom);
              Fluttertoast.showToast(
                  msg: 'Account exists with different credential');
            } else {
              if (e == 'invalid-credential') {
                // Toast.show("Invalid credential",
                //     duration: Toast.lengthLong, gravity: Toast.bottom);
                Fluttertoast.showToast(msg: 'Invalid credential');
              }
            }
          }
        } else {
          closeLoader();
        }
      });
    } catch (e, s) {
      print("||||||||||||||||||||||||||| $e");
      closeLoader();
      await sendErrorLogs("Google Sigin error(Second): $e $s");
      devtools.log("Google Exception: $e");
    }
  }

  /* googleSignIn({

    bool isUser = false,
  }) async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
      ],
    );
    final googleUser = await googleSignIn.signIn();

    try {
      devtools.log("In sign in method:");
      showLoader("Loading...");
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
        if (value.user != null) {
          Map params = {
            'token': credential.accessToken,
            'social_type': 'google',
            'social_site_id': googleUser?.id,
            'email': googleUser?.email,
            'phone': value.user?.phoneNumber != null ? value.user?.phoneNumber : null,
            'accessType': 'login'
          };
          socialLoginApi(params);
          // ApiResponse response =
          // await authRepository.checkUser(value.user!.email.toString());
          // if (response.response.statusCode == 200) {
          //   login(
          //       email: value.user!.email,
          //       isUser: isUser,
          //       password: value.user!.uid);
          // } else {
          //   registerEmp(
          //     email: value.user!.email,
          //     isUser: isUser,
          //     password: value.user!.uid,
          //     name: value.user!.displayName,
          //   );
          // }
          // var userModel = UserModel.fromJson(response.response.data['data']);
          // Global.userModel = userModel;
          // await sharedPreferences.setString(
          //     "user", jsonEncode(response.response.data['data']));
          // emit(AuthState(userModel: userModel));
          // navigationKey.currentState?.pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (_) => const BottomNavScreen()),
          //         (route) => false);
          print('USERRRR ------------------           ${value.user}');
        }
      });
    } catch (e, s) {
      closeLoader();
      showValidationDialog(globalContext, e.toString());
      await sendErrorLogs("Google Sigin error(First): $e $s");

      devtools.log("Google Exception 1: $e");
      if (e == 'account-exists-with-different-credential') {
        Toast.show("Account exists with different credential",
            duration: Toast.lengthLong, gravity: Toast.bottom);
      } else {
        if (e == 'invalid-credential') {
          Toast.show("Invalid credential",
              duration: Toast.lengthLong, gravity: Toast.bottom);
        }
      }
    }
  }*/

  Future<void> sendErrorLogs(String msg) async {
    final url = Uri.parse("$api/api/error-logs");
    Map<String, String> body = {"message": msg};
    await http.post(url, body: body);
  }

  showValidationDialog(BuildContext context, String message) {
    //print("valid");
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Smart Theory Test'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }

  //social_type = facebook, google, apple
  Future<Map> socialLogin(Map params) async {
    final url = Uri.parse("$api/api/social-login?token=" +
        params['token'] +
        "&social_type=" +
        params['social_type'] +
        "&id=" +
        params['social_site_id'] +
        "&email=" +
        params['email']);
    final response = await http.get(url);
    Map data = json.decode(response.body);
    print("data....");
    print(data);
    return data;
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential?> signInWithApple(context) async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.final rawNonce = generateNonce();
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      await Firebase.initializeApp().then((value) async {
        if (await SignInWithApple.isAvailable()) {
          showLoader("Loading...");
          // Request credential for the currently signed in Apple account.
          final appleCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            nonce: nonce,
          );
          // Create an `OAuthCredential` from the credential returned by Apple.
          final oauthCredential = OAuthProvider("apple.com").credential(
            idToken: appleCredential.identityToken,
            rawNonce: rawNonce,
          );

          print("UID : ${oauthCredential.idToken}");
          // Sign in the user with Firebase. If the nonce we generated earlier does
          // not match the nonce in `appleCredential.identityToken`, sign in will fail.
          UserCredential user =
              await FirebaseAuth.instance.signInWithCredential(oauthCredential);
          User? userData = user.user;
          print("UserData : ${user.credential}");
          Map params = {
            'token': user.credential?.accessToken,
            'social_type': 'apple',
            'social_site_id': user.user?.uid,
            'email': user.user?.email,
            'phone':
                user.user?.phoneNumber != null ? user.user?.phoneNumber : null,
            'accessType': 'login'
          };
          socialLoginApi(params);
        } else {
          print('PRINT ');
          closeLoader();
          // Toast.show(
          //   "Apple sign-in not allowed with this device.",
          //   duration: 3,
          //   gravity: Toast.bottom,
          // );
          Fluttertoast.showToast(
              msg: 'Apple sign-in not allowed with this device.');
        }
      });
      //SignInWithApple.isAvailable();
    } catch (e) {
      // closeLoader();
      Spinner.close(context);
      print("Apple signin exception : $e");
      Fluttertoast.showToast(
          msg: 'Apple sign-in not allowed with this device.');
      return null;
    }
  }

  // Future<void> facebookSignIn() async {
  //   try {
  //     showLoader("Loading...");

  //     await Firebase.initializeApp().then((value) async {
  //       FirebaseAuth auth = FirebaseAuth.instance;

  //       final LoginResult loginResult =
  //           await FacebookAuth.instance.login(permissions: ["email"]);
  //       devtools.log("Facebook status ${loginResult.status}");
  //       devtools.log("Facebook token ${loginResult.accessToken}");
  //       switch (loginResult.status) {
  //         case LoginStatus.success:
  //           getFacebookUserDetail(loginResult.accessToken!.token)
  //               .then((detail) {
  //             print("facebook detail.....");
  //             print(detail);
  //             Map params = {
  //               'token': loginResult.accessToken!.token,
  //               'social_type': 'facebook',
  //               'social_site_id': detail['id'],
  //               'email': detail['email'] != null ? detail['email'] : null,
  //               'phone': detail['phone'] != null ? detail['phone'] : null,
  //               'accessType': 'login',
  //             };
  //             socialLoginApi(params);
  //           });
  //           break;
  //         case LoginStatus.cancelled:
  //           closeLoader();
  //           break;
  //         case LoginStatus.failed:
  //           closeLoader();
  //           ToastContext().init(globalContext);

  //           Toast.show(loginResult.message.toString(),
  //               duration: Toast.lengthLong, gravity: Toast.bottom);
  //           break;
  //         case LoginStatus.operationInProgress:
  //           // TODO: Handle this case.
  //           break;
  //       }
  //       // Create a credential from the access token
  //       // final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //       //
  //       // // Once signed in, return the UserCredential
  //       // UserCredential authResult = await auth.signInWithCredential(facebookAuthCredential);
  //       // User? _user = authResult.user;
  //       // devtools.log("User Data: $_user");
  //     });

  //     //return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //     // final facebookLogin = FacebookLogin();
  //     // bool checkSignIn = await facebookLogin.isLoggedIn;
  //     // if (checkSignIn) facebookLogin.logOut();
  //     // final result = await facebookLogin.logIn(["email"]);
  //     // switch (result.status) {
  //     //   case FacebookLoginStatus.loggedIn:
  //     //     getFacebookUserDetail(result.accessToken.token).then((detail) {
  //     //       print("facebook detail.....");
  //     //       print(detail);
  //     //       Map params = {
  //     //         'token': result.accessToken.token,
  //     //         'social_type': 'facebook',
  //     //         'social_site_id': detail['id'],
  //     //         'email': detail['email'] != null ? detail['email'] : null,
  //     //         'phone': detail['phone'] != null ? detail['phone'] : null,
  //     //         'accessType': 'login',
  //     //       };
  //     //       socialLoginApi(params);
  //     //     });
  //     //     break;
  //     //   case FacebookLoginStatus.cancelledByUser:
  //     //     closeLoader();
  //     //     break;
  //     //   case FacebookLoginStatus.error:
  //     //     closeLoader();
  //     //     Toast.show(result.errorMessage, globalContext,
  //     //         duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //     //     break;
  //     //}
  //   } catch (e) {
  //     closeLoader();
  //     devtools.log("Exception(facebook): $e");
  //   }
  // }
  /* Future<void> googleSignIn() async {
    try {
      showLoader("Loading...");
      FirebaseAuth auth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();
      bool checkSignIn = await googleSignIn.isSignedIn();
      if (checkSignIn) googleSignIn.signOut();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        try {
          UserCredential authResult =
              await auth.signInWithCredential(credential);
          User? _user = authResult.user;
          // IdTokenResult _idTokenResult = await _user.getIdToken(refresh: false);
          // print("Goggle Email..: "+_user.email);
          // print("Google uid..:" +googleSignInAccount.id);
          // print("Google accessToken..:" + googleSignInAuthentication.accessToken);
          if (_user != null) {
            Map params = {
              'token': googleSignInAuthentication.accessToken,
              'social_type': 'google',
              'social_site_id': googleSignInAccount.id,
              'email': _user.email != null ? _user.email : null,
              'phone': _user.phoneNumber != null ? _user.phoneNumber : null,
              'accessType': 'login'
            };
            socialLoginApi(params);
          }

          // print("Goggle Email..:");
          // print(params);
        } catch (e) {
          closeLoader();
          // print("Exception:........" + e.toString());
          if (e == 'account-exists-with-different-credential') {
            Toast.show("Account exists with different credential",
                duration: Toast.lengthLong, gravity: Toast.bottom);
          } else if (e == 'invalid-credential') {
            Toast.show("Invalid credential",
                duration: Toast.lengthLong, gravity: Toast.bottom);
          }
        }
      } else {
        closeLoader();
      }
    } catch (e) {
      closeLoader();
      print(e);
    }
  } */

  /*  Future<void> facebookSignIn() async {
    try {
      showLoader("Loading...");
      final facebookLogin = FacebookLogin();
      bool checkSignIn = await facebookLogin.isLoggedIn;
      if (checkSignIn) facebookLogin.logOut();
      final result = await facebookLogin.logIn(["email"]);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          getFacebookUserDetail(result.accessToken.token).then((detail) {
            print("facebook detail.....");
            print(detail);
            Map params = {
              'token': result.accessToken.token,
              'social_type': 'facebook',
              'social_site_id': detail['id'],
              'email': detail['email'] != null ? detail['email'] : null,
              'phone': detail['phone'] != null ? detail['phone'] : null,
              'accessType': 'login',
            };
            socialLoginApi(params);
          });
          break;
        case FacebookLoginStatus.cancelledByUser:
          closeLoader();
          break;
        case FacebookLoginStatus.error:
          closeLoader();
          Toast.show(result.errorMessage,
              duration: Toast.lengthLong, gravity: Toast.bottom);
          break;
      }
    } catch (e) {
      closeLoader();
      print(e);
    }
  } */

  /*   Future<void> appleSignIn() async {
    try {
      if (await AppleSignIn.isAvailable()) {
         showLoader("Loading...");
        List<Scope> scopes = [Scope.email, Scope.fullName];
        final _firebaseAuth = FirebaseAuth.instance;
        final result = await AppleSignIn.performRequests( [AppleIdRequest(requestedScopes: scopes)]);
        switch (result.status) {
          case AuthorizationStatus.authorized:
            final appleIdCredential = result.credential;
            final oAuthProvider = OAuthProvider(providerId: 'apple.com');
            final credential = oAuthProvider.getCredential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
            );
            final authResult = await _firebaseAuth.signInWithCredential(credential);
            print("authResult...");
            print("UID........."+authResult.user.uid);
            print("Emil......"+authResult.user.email);
            print("Token...."+String.fromCharCodes(appleIdCredential.authorizationCode));
            Map params = {
              'token': String.fromCharCodes(appleIdCredential.authorizationCode),
              'social_type': 'apple',
              'social_site_id': authResult.user.uid,
              'email':authResult.user.email == null?null:authResult.user.email,
              'phone':authResult.user.phoneNumber == null?null:authResult.user.phoneNumber,
              'accessType': 'login'
            };
            socialLoginApi(params);
            // final firebaseUser = authResult.user;
            // if (scopes.contains(Scope.fullName)) {
            //   final displayName = '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
            //   print("displayName...");
            //   print(displayName);
            //   //await firebaseUser.updateProfile(displayName: displayName);
            // }
            break;
          case AuthorizationStatus.error:
            closeLoader();
            break;
          case AuthorizationStatus.cancelled:
            closeLoader();
            break;
          default:
            closeLoader();
        }

      } else {
        Toast.show("Apple sign-in not allowed with this device.", globalContext,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (exception) {
      closeLoader();
      print(exception);
    }
  }
*/
  void navigateFromEmailRegister(Map params) {
    _navigationService.navigateTo('/social_email_registration',
        arguments: params);
  }

  void showLoader(String message) {
    CustomSpinner.showLoadingDialog(globalContext, _keyLoader, message);
  }

  // Future<String> readFile() async {
  //   Uri url = Uri.parse('https://mockdvsatest.co.uk/app_logs.txt');
  //   String data = await http.read(url);
  //   return data;
  // }

  void closeLoader() {
    try {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    } catch (e) {}
  }

  Future<Map> getFacebookUserDetail(String token) async {
    final url = Uri.parse(
        "https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=" +
            token);
    final response = await http.get(url);
    Map data = jsonDecode(response.body);
    return data;
  }

  Future<void> socialLoginApi(Map params) async {
    try {
      Map? loginResponse =
          await Provider.of<auth.UserProvider>(globalContext, listen: false)
              .socialLoginWithMdtRegister(params);
      closeLoader();
      print('JJKJKJKJK ${loginResponse}');
      print('DFDFDFDFF ${params}');
      if (loginResponse != null) {
        if (loginResponse['success'] == false) {
          navigateFromEmailRegister(params);
        }
      }
      if (loginResponse == null && params['accessType'] == 'login') {
        // print("ZZZZZZZZZZZZ ${globalContext
        //     .read<auth.UserProvider>()
        //     .status}");
        // globalContext.read<auth.UserProvider>().status = Status.Authenticated;
        // _navigationService.navigateToReplacement('/Authorization');
        // _navigationService.navigatorKey.currentState?.pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
      }
    } catch (e) {
      closeLoader();
    }
  }
}
