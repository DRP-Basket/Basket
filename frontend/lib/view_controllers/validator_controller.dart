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
    } else if (!RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
        .hasMatch(value)) {
      return "Please enter a valid phone number";
    }
    return null;
  }

  static String? validateAddress(String value) {
    if (value.isEmpty) {
      return "Address can't be empty";
    }
    return null;
  }

  static String? validateDescription(String value) {
    if (value.isEmpty) {
      return "Description can't be empty";
    }
    return null;
  }
}
