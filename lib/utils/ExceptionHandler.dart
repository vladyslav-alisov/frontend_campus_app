class ExceptionHandle {
  //todo after debug change to Unknown problem
  static String errorTranslate({var exception}) {
    if (exception.toString().contains("Password is incorrect") || exception.toString().contains("User not found")) {
      return "Your username and/or password do not match.";
    }
    if (exception.toString().contains("Failed host lookup")) {
      return "Connection problem. Please try again later.";
    }
    return exception.toString();
  }
}
