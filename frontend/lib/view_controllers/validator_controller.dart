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
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  static String? validateName(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    return null;
  }

  static String? validateContactNumber(String value) {
    if (value.isEmpty) {
      return "Phone number can't be empty";
    } else if (int.tryParse(value) == null) {
      return "Phone number does not only contain digits, please remove white spaces";
    }
    return null;
  }

  static String? validateLocation(String value) {
    if (value.isEmpty) {
      return "Location can't be empty";
    }
    return null;
  }
}