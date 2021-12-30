import 'package:stack_trace/stack_trace.dart';

import 'package:hasan_utils/src/api/api_request_options.dart';

class ApiInterceptor {
  ApiInterceptor({this.onRequest});

  /// Handler for every request.
  ///
  /// Request will be excuted if returned true, otherwise it will be ignored
  final bool Function(ApiRequestOptions options, List<Frame> trace)? onRequest;
}
