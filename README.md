# gamecli

## что есть

- пользователи
- игры
- платформы
- связь игр и платформ

## структура

```text
gamecli/
├── pubspec.yaml
├── bin/
│   └── main.dart
├── lib/
│   ├── gamecli.dart
│   └── src/
│       ├── domain/
│       │   ├── models/
│       │   └── validators/
│       ├── data/
│       │   ├── database.dart
│       │   └── repositories/
│       └── cli/
│           ├── menu.dart
│           └── input_helper.dart
└── test/
    ├── domain_test.dart
    ├── data_test.dart
    └── validation_test.dart
```

## запуск

```bash
dart pub get
dart run bin/main.dart
```

## тесты

```bash
dart test
```
