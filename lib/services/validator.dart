class Validate {
  // RegEx pattern for validating email addresses.
  static String emailPattern = r'^.+@[a-zA-Z]+\.[a-zA-Z]+(\.?[a-zA-Z]+)$';
  static RegExp emailRegEx = RegExp(emailPattern);
  // Validates an email address.

  static bool isEmail(String value) {
    if (emailRegEx.hasMatch(value.trim())) {
      return true;
    }
    return false;
  }

  //password validation

  static late String passwordPattern =
      r"^(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$";
  static RegExp passwordRegEx = RegExp(passwordPattern);
  static bool isPassword(String value) {
    if (passwordRegEx.hasMatch(value.trim())) {
      return true;
    }
    return false;
  }

  /*
   * Returns an error message if password does not validate.
   */
  static String? validatePassword(String value) {
    String passWord = value.trim();

    if (passWord.isEmpty) {
      return 'Password Number is required.';
    }

    if (!isPassword(value)) {
      return 'Password strength is low';
    }

    return null;
  }

  static RegExp _numeric = RegExp(r'^-?[0-9]+$');

  static bool isNumeric(String value) {
    return _numeric.hasMatch(value);
  }

  static bool isMobile(String value) {
    // Validates an mobile no

    if (isNumeric(value)) {
      if (value.length != 10)
        return false;
      else
        return true;
    }
    return false;
  }

  static String? isValidMobile(String value) {
    String mob = value.trim();

    if (mob.isEmpty) {
      return 'Phone Number is required';
    }

    if (isNumeric(value)) {
      if (value.length != 10)
        return 'Phone Number is not Valid';
      else
        return null;
    }
    return null;
  }

  /*
   * Returns an error message if email does not validate.
   */
  static String? validateEmail(String value) {
    String emailPhone = value.trim();

    if (emailPhone.isEmpty) {
      return 'Email is required.';
    }

    if (!isMobile(value) && !isEmail(value)) {
      if (!isNumeric(value)) {
        return 'Email is not Valid';
      } else {
        return 'Phone Number is not Valid';
      }
    } else if (isMobile(value)) {
      return null;
    }
    return null;
  }

  static String? emailValidation(String s) {
    RegExp pattern = RegExp(r'^.+@[a-zA-Z]+\.[a-zA-Z]+(\.?[a-zA-Z]+)$');
    if (s.isEmpty) {
      return "Please enter email ";
    } else if (!pattern.hasMatch(s)) {
      return "Enter valid email";
    }
    return null;
  }

  /*
   * Returns an error message if required field is empty.
   */
  static String? requiredField(String value, String message) {
    if (value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? nameValidation(String s) {
    String patttern = r'^[a-z A-Z,.\-]+$';
    RegExp regExp = RegExp(patttern);
    if (s.isEmpty || s.length <= 2) {
      return 'Please enter full name';
    } else if (!regExp.hasMatch(s)) {
      return 'Please enter valid name';
    }
    return null;
  }

  static String? passwordValidation(String s) {
    if (s.isEmpty || s == "") {
      return "Please enter password";
    } else if (s.length < 6) {
      return "Password must not be less then 6 digits";
    }
    // emit(ValidState("valid"));
    return null;
  }

  static String? confirmPasswordValidation(String s, val) {
    if (s.isEmpty || s == "") {
      return "Please enter password";
    } else if (s != val) {
      return "Password and confirm password doesn't match";
    }
    // emit(ValidState("valid"));
    return null;
  }
}
