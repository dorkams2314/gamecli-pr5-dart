import 'dart:convert';
import 'dart:io';

import 'package:gamecli/gamecli.dart';

void main(List<String> arguments) {
  stdout.encoding = utf8;
  stderr.encoding = utf8;

  final db = GamePortalDatabase.inApp();
  try {
    runMenu(db);
  } finally {
    db.close();
  }
}
