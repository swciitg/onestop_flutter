import 'dart:math';

String generateToken() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  final buffer = StringBuffer();

  for (int i = 0; i < 5; i++) {
    buffer.write(chars[random.nextInt(chars.length)]);
  }

  return "#${buffer.toString()}#";
}
