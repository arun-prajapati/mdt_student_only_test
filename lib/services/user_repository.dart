//import 'package:flutter/widgets.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:main_flutter/enums/Autentication_status.dart';
//import 'package:main_flutter/locater.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//import 'booking_service.dart';
//final storage = FlutterSecureStorage();
//
//class UserRepository with ChangeNotifier {
//
//  FirebaseAuth _auth;
//  FirebaseUser _user;
//  GoogleSignIn _googleSignIn;
//  Status _status = Status.Uninitialized;
//
//  final _api = locator<Api>();
//
//  UserRepository.instance()
//      : _auth = FirebaseAuth.instance,
//        _googleSignIn = GoogleSignIn() {
//    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
//  }
//
//  Status get status => _status;
//  FirebaseUser get user => _user;
//
//  Future<bool> signIn(String email, String password) async {
//    try {
//      _status = Status.Authenticating;
//      notifyListeners();
//      await _auth.signInWithEmailAndPassword(email: email, password: password);
//      return true;
//    } catch (e) {
//      _status = Status.Unauthenticated;
//      notifyListeners();
//      return false;
//    }
//  }
//
//  Future<bool> signInRest(String username, String password) async {
//    try {
//      _status = Status.Authenticating;
//      notifyListeners();
//      var jwt = await _api.attemptLogIn(username, password);
//      if(jwt != null) {
//        storage.write(key: "jwt", value: jwt);
//      }
//      else{
//        return false;
//      }
//      return true;
//    } catch (e) {
//      _status = Status.Unauthenticated;
//      notifyListeners();
//      return false;
//    }
//  }
//  Future<bool> signInWithGoogle() async {
//    try {
//      _status = Status.Authenticating;
//      notifyListeners();
//      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//      final GoogleSignInAuthentication googleAuth =
//      await googleUser.authentication;
//      final AuthCredential credential = GoogleAuthProvider.getCredential(
//        accessToken: googleAuth.accessToken,
//        idToken: googleAuth.idToken,
//      );
//      await _auth.signInWithCredential(credential);
//      return true;
//    } catch (e) {
//      print(e);
//      _status = Status.Unauthenticated;
//      notifyListeners();
//      return false;
//    }
//
//  }
//
//  Future signOut() async {
//    _auth.signOut();
//    _googleSignIn.signOut();
//    _status = Status.Unauthenticated;
//    notifyListeners();
//    return Future.delayed(Duration.zero);
//  }
//
//  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
//    if (firebaseUser == null) {
//      _status = Status.Unauthenticated;
//    } else {
//      _user = firebaseUser;
//      _status = Status.Authenticated;
//    }
//    notifyListeners();
//  }
//}