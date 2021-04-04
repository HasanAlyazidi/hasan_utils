import 'package:fast_localization/fast_localization.dart';

class Validate {
  static _ValidateLengths lengths = _ValidateLengths();
  static _ValidateMessages message = _ValidateMessages();

  static bool email(String? email) {
    return email != null &&
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);
  }

  static bool between(String? string, int min, int max) {
    return string != null && string.length >= min && string.length <= max;
  }

  static bool empty(String? value) {
    return value == null || value.isEmpty;
  }

  static bool integer(value, {parseString = true}) {
    if (value is int) {
      return true;
    } else if (parseString && value is! String) {
      return false;
    }

    return parseString ? int.tryParse(value) != null : false;
  }

  static bool range(num? value, int min, int max) {
    return value != null && value >= min && value <= max;
  }
}

class _ValidateMessages {
  String get emptyEmail => t('validate.errors.emptyEmail');
  String get emptyPassword => t('validate.errors.emptyPassword');
  String get invalidEmail => t('validate.errors.invalidEmail');
  String get invalidMobileNumber => t('validate.errors.invalidMobileNumber');
  String get invalidMobileType => t('validate.errors.invalidMobileType');
  String get unknownError => t('validate.errors.unknownError');

  String emptyField(String field, {bool lowerCase = true}) => t(
      'validate.errors.emptyField',
      {"field": lowerCase ? field.toLowerCase() : field});
  String invalidField(String field) =>
      t('validate.errors.invalidField', {"field": field});
  String invalidLength(String field, int min, int max) => t(
      'validate.errors.invalidLength',
      {"field": field, "min": min.toString(), "max": max.toString()});
  String invalidPassword(int min, int max) => t(
      'validate.errors.invalidPassword',
      {"min": min.toString(), "max": max.toString()});
}

class _ValidateLengths {
  final int minNameLength = 3;
  final int maxNameLength = 60;
}
