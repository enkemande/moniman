import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> storePrivateKey(String privateKey) async {
    await _storage.write(key: 'private_key', value: privateKey);
  }

  Future<void> storePublicKey(String privateKey) async {
    await _storage.write(key: 'public_key', value: privateKey);
  }

  Future<String?> getPrivateKey() async {
    return await _storage.read(key: 'private_key');
  }

  Future<String?> getPublicKey() async {
    return await _storage.read(key: 'public_key');
  }
}
