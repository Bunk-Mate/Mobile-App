import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  Future<void> setOnboardingComplete() async {
    await _storage.write(key: 'onboarding', value: 'true');
  }

  Future<void> deleteOnboarding() async {
    await _storage.delete(key: 'onboarding');
  }

  Future<bool> getOnboardingComplete() async {
    final onboarding = await _storage.read(key: 'onboarding');
    return onboarding == 'true';
  }
}
