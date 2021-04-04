import 'package:flutter_test/flutter_test.dart';
import 'package:hasan_utils/hasan_utils.dart';

void main() {
  // Api tests
  test('Api tests', () {
    final baseUrl = 'https://jsonplaceholder.typicode.com/';

    Api.options(baseUrl: baseUrl);

    Api.get('todos/1', null);

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

  // File Downloader tests
  test('File Downloader tests', () async {
    final downloader = FileDownloader();

    bool isDownloaded = false;
    bool isError = false;
    List<String> callbacks = [];

    await downloader.start(
      url: 'http://www.africau.edu/images/default/sample.pdf',
      location: '/tmp',
      onDone: (_) => isDownloaded = true,
    );

    await downloader.start(
      url: 'http://www.example.com/wrong-path/file.pdf',
      location: '/tmp',
      onError: (_) => isError = true,
    );

    await downloader.start(
      url: 'http://www.africau.edu/images/default/sample.pdf',
      location: '/tmp',
      onStart: () => callbacks.add('onStart'),
      onProgress: (_) {
        if (callbacks.contains('onProgress')) {
          return;
        }

        callbacks.add('onProgress');
      },
      onDone: (_) => callbacks.add('onDone'),
      onExit: () => callbacks.add('onExit'),
    );

    expect(true, isDownloaded);
    expect(true, isError);
    expect('onStart', callbacks[0]);
    expect('onProgress', callbacks[1]);
    expect('onDone', callbacks[2]);
    expect('onExit', callbacks[3]);
  });
}
