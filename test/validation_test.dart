import 'package:gamecli/gamecli.dart';
import 'package:test/test.dart';

void main() {
  test('requireText trims valid text', () {
    expect(requireText('  player  ', 'никнейм'), 'player');
  });

  test('requireText rejects empty text', () {
    expect(() => requireText('   ', 'никнейм'), throwsFormatException);
  });

  test('requireEmail accepts simple valid email', () {
    expect(requireEmail('user@example.com'), 'user@example.com');
  });

  test('requireEmail rejects invalid email', () {
    expect(() => requireEmail('wrong-email'), throwsFormatException);
  });

  test('requirePositiveInt accepts positive number', () {
    expect(requirePositiveInt('2026', 'год'), 2026);
  });

  test('requirePositiveInt rejects non-positive number', () {
    expect(() => requirePositiveInt('0', 'год'), throwsFormatException);
  });
}
