import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'You cannot share empty note',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
