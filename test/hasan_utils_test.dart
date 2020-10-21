import 'package:flutter_test/flutter_test.dart';
import 'package:hasan_utils/hasan_utils.dart';

void main() {
  // Api tests
  test('Api tests', () {
    final baseUrl = 'https://example.com/api/v1/';

    Api.options(baseUrl: baseUrl);

    Api.get('login', null);

    expect(Api.baseUrl, baseUrl);
  });

  // Validate
  test('Validate tests', () async {
    expect(Validate.email('hassanx220@gmail.com'), true);
    expect(Validate.email('hassanx220@gmail'), false);
    expect(Validate.email('@gmail'), false);
    expect(Validate.email(''), false);
    expect(Validate.email(null), false);

    expect(Validate.between('Hasan', 3, 5), true);
    expect(Validate.between('Hasan', 3, 10), true);
    expect(Validate.between('Hasan', 6, 10), false);
    expect(Validate.between(null, 6, 10), false);

    expect(Validate.empty(null), true);
    expect(Validate.empty(''), true);
    expect(Validate.empty('Hasan'), false);

    expect(Validate.range(2, 1, 2), true);
    expect(Validate.range(2020, 1800, 2030), true);
    expect(Validate.range(2020, 2019, 2022), true);
    expect(Validate.range(2020.02, 6, 10), false);
    expect(Validate.range(-2020, 6, 10), false);
    expect(Validate.range(null, 6, 10), false);

    expect(Validate.integer(2), true);
    expect(Validate.integer(-2), true);
    expect(Validate.integer(2.0), false);
    expect(Validate.integer(2.5), false);
    expect(Validate.integer('2'), true);
    expect(Validate.integer('2', parseString: false), false);
    expect(Validate.integer('2.5'), false);
    expect(Validate.integer(''), false);
    expect(Validate.integer('', parseString: false), false);
    expect(Validate.integer(null), false);
  });
}
