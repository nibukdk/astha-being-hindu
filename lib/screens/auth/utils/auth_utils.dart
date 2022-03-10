enum AuthState {
  loggedIn,
  loggedOut,
}

enum ViewState {
  idle,
  busy,
}

enum AuthMode { signin, register }

extension AuthModeExtension on AuthMode {
  String get titleText {
    switch (this) {
      case AuthMode.register:
        return "Already Have an account?";

      case AuthMode.signin:
        return "Don't have an account yet?";
      default:
        return "Don't have an account yet?";
    }
  }

  String get linkText {
    switch (this) {
      case AuthMode.register:
        return "Sign In";
      case AuthMode.signin:
        return "Register";
      default:
        return "Register";
    }
  }
}
