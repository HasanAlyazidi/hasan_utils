import 'package:flutter/foundation.dart';

class ApiAuthorization {
  ApiAuthorization({@required this.type, @required this.token});

  final String type;
  final Function token;

  factory ApiAuthorization.bearer({Function token}) {
    return ApiAuthorization(type: 'Bearer', token: token);
  }

  dynamic get header {
    return '$type ${token()}';
  }
}
