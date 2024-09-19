import 'dart:convert';

import 'package:encrypt/encrypt.dart';

class AesEncryption {
  Key generateRandomKey() {
    return Key.fromSecureRandom(32);
  }

  Key parseKeyFromEncoded(String encoded) {
    final key = Key.fromBase64(encoded);
    return key;
  }

  String encryptMessage(String message, Key key) {
    final iv = IV.allZerosOfLength(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(message, iv: iv);
    return base64Encode(encrypted.bytes);
  }

  String decryptMessage(String encryptedMessage, Key key) {
    final iv = IV.allZerosOfLength(16);
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt64(encryptedMessage, iv: iv);
  }
}
