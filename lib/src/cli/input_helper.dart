import 'dart:convert';
import 'dart:io';

import '../domain/validators/number_validator.dart';
import '../domain/validators/text_validator.dart';

String readText(String label, String fieldName) {
  while (true) {
    stdout.write(label);
    try {
      return requireText(stdin.readLineSync(encoding: utf8), fieldName);
    } on FormatException catch (error) {
      stdout.writeln(error.message.toLowerCase());
    }
  }
}

String readEmail(String label) {
  while (true) {
    stdout.write(label);
    try {
      return requireEmail(stdin.readLineSync(encoding: utf8));
    } on FormatException catch (error) {
      stdout.writeln(error.message.toLowerCase());
    }
  }
}

int readPositiveInt(String label, String fieldName) {
  while (true) {
    stdout.write(label);
    try {
      return requirePositiveInt(stdin.readLineSync(encoding: utf8), fieldName);
    } on FormatException catch (error) {
      stdout.writeln(error.message.toLowerCase());
    }
  }
}
