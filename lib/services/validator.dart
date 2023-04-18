class Validate {
  // RegEx pattern for validating email addresses.
  static String emailPattern =
      r"^((([A-Za-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([A-Za-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
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

  /*
   * Returns an error message if required field is empty.
   */
  static String? requiredField(String value, String message) {
    if (value.trim().isEmpty) {
      return message;
    }
    return null;
  }
}
