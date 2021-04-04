import 'dart:io';

class FileUtils {
  static Future delete({required String path, Function? onError}) async {
    try {
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      if (onError != null) {
        onError();
      }
    }
  }
}
