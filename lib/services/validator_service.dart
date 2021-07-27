class ValidatorService {
  static bool isEmailValid(String email) {
    final emailFormat = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
    return emailFormat.hasMatch(email);
  }

  static bool isPhoneNumberValid(String phone) {

      final parsedPhone = phone.replaceAll(RegExp(r"[^0-9]"), '');
      // E.164 https://en.wikipedia.org/wiki/E.164
      final phoneFormat = RegExp(r"^\+?[1-9]\d{1,14}$");
      return phoneFormat.hasMatch(parsedPhone);


  }
}