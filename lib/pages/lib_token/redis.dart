import 'dart:developer';

import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:redis/redis.dart';

String redisHost = String.fromEnvironment('REDIS_HOST');
String redisPass = String.fromEnvironment('REDIS_PASSWORD');
String redisUsername = String.fromEnvironment('REDIS_USERNAME');
int redisPort = int.parse(String.fromEnvironment('REDIS_PORT'));

class RedisService {
  final OneStopUser user = OneStopUser.fromJson(LoginStore.userData);

  static final RedisService _instance = RedisService._internal();
  factory RedisService() => _instance;
  RedisService._internal();

  late Command _command;

  /// Connect to Redis
  Future<void> connect() async {
    try {
      log('[Redis] Initializing connection...', name: 'RedisService');

      final conn = RedisConnection();

      _command = await conn.connect(redisHost, redisPort);

      log(
        '✅ [Redis] Connected to $redisHost:$redisPort',
        name: 'RedisService',
      );

      // If Redis requires auth
      final authResult = await _command.send_object([
        'AUTH',
        redisUsername,
        redisPass,
      ]);

      log('🔐 [Redis] Auth response: $authResult', name: 'RedisService');
    } catch (e, st) {
      log(
        '❌ [Redis] Connection failed',
        name: 'RedisService',
        error: e,
        // stackTrace: st,
      );
      rethrow;
    }
  }

  /// Store token with expiry
  Future<bool> storeToken(String token) async {
    try {
      log(
        '📦 [Redis] Storing token',
        name: 'RedisService'
      );

      final result = await _command.send_object([
        'SET',
        token,
        user.rollNo,
        'EX',
        500,
      ]);

      log('✅ [Redis] SET result: $result', name: 'RedisService');

      return result == 'OK';
    } catch (e, st) {
      log(
        '❌ [Redis] Failed to store token',
        name: 'RedisService',
        error: e,
      );
      return false;
    }
  }
  Future<String?> getToken(String token) async {
    try {
      log(
        '🔍 [Redis] Fetching token',
        name: 'RedisService',
        // extra: {'token': token},
      );

      final result = await _command.send_object(['GET', token]);

      log('📤 [Redis] GET result: $result', name: 'RedisService');

      return result as String?;
    } catch (e, st) {
      log(
        '❌ [Redis] Failed to fetch token',
        name: 'RedisService',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }
}
