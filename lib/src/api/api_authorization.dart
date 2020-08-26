import 'package:flutter/foundation.dart';

class ApiAuthorization {
  final String type;
  final Function token;

  ApiAuthorization({@required this.type, @required this.token});

  factory ApiAuthorization.bearer({Function token}) {
    return ApiAuthorization(type: 'Bearer', token: token);
  }

  dynamic get header {
    return '$type ${token()}';
  }
}
