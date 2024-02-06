import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_app/views/Login/login.dart';
import 'package:toast/toast.dart';

import '../../custom_button.dart';
import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../services/auth.dart';
import '../../services/driver_profile_services.dart';
import '../../services/navigation_service.dart';
import '../../widget/CustomAppBar.dart';
import '../../widget/CustomSpinner.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  final NavigationService _navigationService = locator<NavigationService>();
  final DriverProfileServices api_services = new DriverProfileServices();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final UserProvider auth_services = new UserProvider();
  TextEditingController old_password = new TextEditingController(), new_password = new TextEditingController(), cnf_password = new TextEditingController();
  late int _userType = 2;
  late int _userId;

  //Call APi Services
  Future<int> getUserDetail() async {
    Map response = await Provider.of<UserProvider>(context, listen: false).getUserData();
    _userId = response['id'];
    return _userId;
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  //call api for change password
  Future<Map?> changePasswordApiCall(Map<String, String> params) async {
    try {
      Map response = await api_services.changePassword(params);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.initializeApi("Loading...");
    });
    // KeyboardVisibilityNotification().addNewListener(
    //   onChange: (bool visible) {
    //     if (!visible) {
    //       FocusScopeNode currentFocus = FocusScope.of(context);
    //       if (!currentFocus.hasPrimaryFocus) {
    //         currentFocus.unfocus();
    //       }
    //     }
    //   },
    // );
  }

  @override
  void dispose() {
    super.dispose();
  }

  initializeApi(String loaderMessage) {
    checkInternet();

    CustomSpinner.showLoadingDialog(context, _keyLoader, loaderMessage);
    getUserDetail().then((user_id) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    });
  }

  void closeLoader() {
    try {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          CustomAppBar(
              preferedHeight: Responsive.height(24, context),
              title: 'Change Password',
              textWidth: Responsive.width(35, context),
              iconLeft: Icons.arrow_back,
              onTap1: () {
                _navigationService.goBack();
              },
              iconRight: null),
          Container(
              margin: EdgeInsets.fromLTRB(0, Responsive.height(11, context), 0, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                // border: BoxBorder(),
                // boxShadow: [
                //   BoxShadow(
                //       color: Color.fromRGBO(0, 0, 0, 1),
                //       offset: Offset(1, 2),
                //       blurRadius: 5.0)
                // ],
              ),
              // height: Responsive.height(47, context),
              padding: EdgeInsets.fromLTRB(5, 40, 5, 20),
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(children: [
                  CustomTextField(
                    label: 'Enter Old Password',
                    heading: 'Old Password',
                    controller: old_password,
                  ),
                  CustomTextField(
                    label: 'Enter new Password',
                    heading: 'new Password',
                    controller: new_password,
                  ),
                  CustomTextField(
                    label: 'Enter confirm Password',
                    heading: 'confirm Password',
                    controller: cnf_password,
                  ),

                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 75, vertical: 0),
                    child: CustomButton(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      title: 'Update',
                      onTap: () {
                        if (this.old_password.text == null || this.old_password.text.trim() == '') {
                          Toast.show('Please enter old password!',
                              // textStyle: context,
                              duration: Toast.lengthLong,
                              gravity: Toast.center);
                        } else if (this.new_password.text == null || this.new_password.text.trim() == '') {
                          Toast.show('Please enter new password!',
                              //textStyle: context,
                              duration: Toast.lengthLong,
                              gravity: Toast.center);
                        } else if (this.cnf_password.text == null || this.cnf_password.text.trim() == '') {
                          Toast.show('Please enter confirm password!',
                              // textStyle: context,
                              duration: Toast.lengthLong,
                              gravity: Toast.center);
                        } else if (this.new_password.text != this.cnf_password.text.trim()) {
                          Toast.show('Confirm password does not match with new password!',
                              // textStyle: context,
                              duration: Toast.lengthLong,
                              gravity: Toast.center);
                        } else {
                          try {
                            CustomSpinner.showLoadingDialog(context, _keyLoader, "Loading...");
                            Map<String, String> requestParams = {
                              'id': this._userId.toString(),
                              'user_type': this._userType.toString(),
                              'old_password': this.old_password.text,
                              'new_password': this.new_password.text,
                              'cnf_password': this.cnf_password.text
                            };
                            changePasswordApiCall(requestParams).then((response) {
                              closeLoader();
                              Toast.show(response!["message"],
                                  //textStyle: context,
                                  duration: Toast.lengthLong,
                                  gravity: Toast.bottom);
                              if (response['success'] == true) _navigationService.goBack();
                            });
                          } catch (e) {
                            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
                            Toast.show('Failed request! please try again.', textStyle: context, duration: Toast.lengthLong, gravity: Toast.bottom);
                          }
                        }
                      },
                    ),
                  ),
                  // Container(
                  //   height: 40,
                  //   width: constraints.maxWidth * 0.65,
                  //   alignment: Alignment.center,
                  //   child: Material(
                  //     borderRadius: BorderRadius.circular(10),
                  //     color: Color(0xFFed1c24),
                  //     // elevation: 5.0,
                  //     child: MaterialButton(
                  //       onPressed:
                  //       child: LayoutBuilder(
                  //         builder: (context, constraints) {
                  //           return Container(
                  //             width: 100,
                  //             alignment: Alignment.center,
                  //             child: AutoSizeText(
                  //               'Update',
                  //               style: TextStyle(
                  //                 fontFamily: 'Poppins',
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.w700,
                  //                 color: Color.fromRGBO(255, 255, 255, 1.0),
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ]);
              })),
        ],
      ),
    );
  }
}
