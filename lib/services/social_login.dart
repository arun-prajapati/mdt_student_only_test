import 'dart:convert';
import 'dart:developer' as devtools;
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:Smart_Theory_Test/Constants/app_colors.dart';
import 'package:Smart_Theory_Test/responsive/size_config.dart';
import 'package:Smart_Theory_Test/utils/app_colors.dart';
import 'package:Smart_Theory_Test/views/Home/home_content_mobile.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

//import 'package:sign_in_apple/sign_in_apple.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:Smart_Theory_Test/enums/Autentication_status.dart';
import 'package:Smart_Theory_Test/main.dart';
import 'package:Smart_Theory_Test/services/auth.dart';

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
  String deviceId = '';

  getDeviceId() async {
    // var platform = PlatformDeviceId.deviceInfoPlugin;
    String consistentUdid = await FlutterUdid.consistentUdid;
    log(consistentUdid, name: "consistent_Udid");
    if (Platform.isIOS) {
      // String consistentUdid = await FlutterUdid.consistentUdid;
      // String udid = await FlutterUdid.udid;
      // log(udid, name: "UNIQUE_ID");
      // log(consistentUdid, name: "consistent_Udid");
      deviceId = consistentUdid;
      print("========== IOS =========== $consistentUdid");
      return consistentUdid;
    } else {
      deviceId = consistentUdid;
      print("========== ANDROID =========== $consistentUdid");
      return consistentUdid;
    }
  }

  SocialLoginService(BuildContext context) {
    globalContext = context;
    getDeviceId();
  }

  Future<void> googleSignIn() async {
    try {
      devtools.log("In sign in method:");
      showLoader("Loading...");
      await Firebase.initializeApp().then((value) async {
        FirebaseAuth auth = FirebaseAuth.instance;
        final GoogleSignIn googleSignIn = GoogleSignIn(
          scopes: <String>['email'],
          // clientId:
          //     "825629569582-bci1rmu8nq0qi8f3ubu7l18qf5g7emjj.apps.googleusercontent.com",
          // serverClientId:
          //     "825629569582-ro8vjoi5q3t59bhb55m589bjfe4lglrm.apps.googleusercontent.com",
        );
        bool checkSignIn = await googleSignIn.isSignedIn();
        if (checkSignIn) googleSignIn.disconnect();
        print('jjjjjjjjJJJJJJJ $checkSignIn');
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
              'accessType': 'login',
              'device_id': deviceId,
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
          print("Userdata : $userData");
          print("User credential : ${user.credential}");
          Map params = {
            'token': user.credential?.accessToken,
            'social_type': 'apple',
            'social_site_id': user.user?.uid,
            'email': user.user?.email,
            'phone':
                user.user?.phoneNumber != null ? user.user?.phoneNumber : null,
            'accessType': 'login',
            'device_id': deviceId,
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

  void navigateFromEmailRegister(Map params) {
    _navigationService.navigateTo('/social_email_registration',
        arguments: params);
  }

  void showLoader(String message) {
    CustomSpinner.showLoadingDialog(globalContext, _keyLoader, message);
  }

  void closeLoader() {
    try {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    } catch (e) {}
  }

  facebookSignIn() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ["public_profile", "email"],
        loginBehavior: LoginBehavior.dialogOnly,
      ).catchError((e) {
        print('ERORRRR ========== $e');
      });
      if (loginResult.status == LoginStatus.success) {
        print("%%%%%%%%%%%%%%%%%");

        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential)
            .then((value) {
          if (value.user != null) {
            print("UserData : ${value.user}");
            Map params = {
              'token': loginResult.accessToken!.token,
              'social_type': 'facebook',
              'social_site_id': value.user?.uid,
              'email': value.user?.email,
              'phone': value.user?.phoneNumber != null
                  ? value.user?.phoneNumber
                  : null,
              'accessType': 'login'
            };
            print("SOCIAL AUTH PARAM : ${jsonEncode(params)}");
            socialLoginApi(params);
          }
        }).catchError((e) {
          print('ERORRRR ========== $e');
        });
        // var apiResponseLongToken =
        //     await repository.longLivedAccessTokenFacebook(
        //         token: loginResult.accessToken!.token);
        // longLivedToken = apiResponseLongToken.response.data['access_token'];
      } else {
        print("%%%%%%%%%%%%%%%%% ELSE");
      }
      await FacebookAuth.instance.getUserData().then((value) {
        print("getUserData ${jsonEncode(value)}");
      });
      final token = loginResult.accessToken!.token;
      print("FACEBOOK TOKEN $token");
      if (token.isNotEmpty) {
        // await loginWithFacebookAccount(
        //     longLivedToken, spinnerItemId, invitekey, context);
      }
      // }
    } catch (e) {
      print('888888*********** $e');
      // snackBar(context, message: e.toString(), color: Colors.red);
    }
    // _loading = false;
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
              .socialLoginWithMdtRegister(globalContext, params);
      closeLoader();
      print('JJKJKJKJK ${loginResponse}');
      print('DFDFDFDFF ${params}');
      if (loginResponse != null) {
        if (loginResponse['success'] == false) {
          if (loginResponse['message'] == 'device-exist') {
            print('loginResponse ${loginResponse['message']}');
            showDialog(
                context: globalContext,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Smart Theory Test',
                        style: AppTextStyle.appBarStyle),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hey there ${loginResponse['user_name'].toString().substring(0, 1).toUpperCase() + loginResponse['user_name'].toString().substring(1)}",
                          style: AppTextStyle.textStyle.copyWith(
                              fontSize: 16,
                              color: Dark,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 1.5,
                        ),
                        Text(
                          'You seem to have changed your phone. Would you like to'
                          ' move your app to your new phone?',
                          style: AppTextStyle.textStyle.copyWith(
                              fontSize: 16,
                              color: Dark,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 1.5,
                        ),
                        // Text('Thanks'),
                      ],
                    ),
                    //Text('${userName.substring(0,1).toUpperCase()+userName.substring(1)} $contact'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          globalContext.read<UserProvider>().updateDeviceID();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Ok',
                          style: AppTextStyle.textStyle.copyWith(
                              fontSize: 16,
                              color: Dark,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // launchUrl(
                          //   Uri(
                          //     scheme: 'tel',
                          //     path: '$contact',
                          //   ),
                          //   mode: LaunchMode.externalApplication,
                          // );
                        },
                        child: Text(
                          'Cancel',
                          style: AppTextStyle.textStyle.copyWith(
                              fontSize: 16,
                              color: Dark,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                    actionsAlignment: MainAxisAlignment.start,
                    contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 1.0),
                  );
                });

            // _userId = apiResponse['user_id'];
            // globalContext.read<UserProvider>().showDeviceExistDialog(
            //       globalContext,
            //       Provider.of<UserProvider>(globalContext, listen: false)
            //           .userName,
            //       Provider.of<UserProvider>(globalContext, listen: false)
            //           .contact,
            //     );
          } else {
            navigateFromEmailRegister(params);
          }
        }
      }
      if (loginResponse == null && params['accessType'] == 'login') {
        // var authData = globalContext.read<UserProvider>();
        // print("ZZZZZZZZZZZZ ${globalContext
        //     .read<auth.UserProvider>()
        //     .status}");
        // globalContext.read<auth.UserProvider>().status = Status.Authenticated;
        // _navigationService.navigateToReplacement('/Authorization');
        _navigationService.navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
        // authData.googleNavigate = true;
      }
    } catch (e) {
      closeLoader();
    }
  }
}
