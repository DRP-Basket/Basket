class ValidatorController {
  ValidatorController();

  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }
}
