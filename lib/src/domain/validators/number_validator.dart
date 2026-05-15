int requirePositiveInt(String? value, String fieldName) {
  final number = int.tryParse(value?.trim() ?? '');
  if (number == null || number <= 0) {
    throw FormatException('$fieldName должен быть положительным числом');
  }
  return number;
}
