import 'package:encrypt/encrypt.dart';

// ignore_for_file: avoid_print

void main(List<String> args) {
  assert(args.length == 2);

  final encrypter = Encrypter(AES(Key.fromBase64(args[0])));

  final iv = IV.fromSecureRandom(16);
  final encrypted = encrypter.encrypt(args[1], iv: iv);

  print('${iv.base64}:${encrypted.base64}');
}
