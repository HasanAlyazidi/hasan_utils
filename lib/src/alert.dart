import 'package:flutter/material.dart';
import 'package:fast_localization/fast_localization.dart';

class Alert {
  static void show(BuildContext context, String title, String text,
      {String? buttonTitle, Function? onPressed}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: Text(buttonTitle ?? Localization.translate('ok')),
              onPressed: () async {
                Navigator.of(context).pop();

                if (onPressed != null) {
                  await onPressed();
                }
              },
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> confirm(
    BuildContext context,
    String title,
    String text,
    Function positiveButtonOnPressed, {
    String? positiveButtonTitle,
    String? negativeButtonTitle,
    Function? negativeButtonOnPressed,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: Text(positiveButtonTitle ?? Localization.translate('ok')),
              onPressed: () async {
                Navigator.of(context).pop(true);
                await positiveButtonOnPressed();
              },
            ),
            TextButton(
              child:
                  Text(negativeButtonTitle ?? Localization.translate('cancel')),
              onPressed: () async {
                Navigator.of(context).pop(false);

                if (negativeButtonOnPressed != null) {
                  await negativeButtonOnPressed();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
