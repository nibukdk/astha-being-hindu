class AuthValidators {
  static const String emailErrMsg =
      "Invlid Email Address, Please provide a valid email.";
  static const String passwordErrMsg =
      "Password must have atleast 6 characters.";
  static const String confirmPasswordErrMsg = "Two passwords don't match.";

// A simple email validator that  checks presence and position of @
  String? emailValidator(String? val) {
    final String email = val as String;

    // If length of email is <=3 then its invlaid
    if (email.length <= 3) return emailErrMsg;

    // Validation related to @
    final hasAtSymbol = email.contains('@');
    final indexOfAt = email.indexOf('@');
    // Check number of @
    final numberOfAt = "@".allMatches(email).length;

    // Valid if has @
    //also @ is not first or last character
    // also if number of @ is only 1

    if (!hasAtSymbol) return emailErrMsg;
    if (numberOfAt != 1) return emailErrMsg;
    if (indexOfAt == email.length - 1 || indexOfAt == 0) return emailErrMsg;

    return null;
  }

  // Password validator
  String? passwordVlidator(String? val) {
    final String password = val as String;

    if (password.isEmpty || password.length <= 5) return passwordErrMsg;

    return null;
  }

// Confirm password
  String? confirmPasswordValidator(String? val, firstPasswordInpTxt) {
    final String firstPassword = firstPasswordInpTxt;
    final String secondPassword = val as String;
    if (firstPassword.isEmpty ||
        secondPassword.isEmpty ||
        firstPassword.length != secondPassword.length) {
      return confirmPasswordErrMsg;
    }

    if (firstPassword != secondPassword) return confirmPasswordErrMsg;

    return null;
  }
}
