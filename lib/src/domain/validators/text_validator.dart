String requireText(String? value, String fieldName) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) {
    throw FormatException('$fieldName не может быть пустым');
  }
  return text;
}

String requireEmail(String? value) {
  final email = requireText(value, 'email');
  if (!email.contains('@') || !email.contains('.')) {
    throw const FormatException('email выглядит некорректно');
  }
  return email;
}
