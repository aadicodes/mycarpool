import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env.dev', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'FIREBASE_API_KEY_IOS')
  static final String fbApiKeyIOS = _Env.fbApiKeyIOS;
  @EnviedField(varName: 'FIREBASE_API_KEY_ANDROID')
  static final String fbApiKeyAndroid = _Env.fbApiKeyAndroid;
  @EnviedField(varName: 'FIREBASE_API_KEY_WEB')
  static final String fbApiKeyWeb = _Env.fbApiKeyWeb;
  @EnviedField(varName: 'FIREBASE_PROJECT_ID')
  static final String fbProjectId = _Env.fbProjectId;
  @EnviedField(varName: 'FIREBASE_APP_ID_IOS')
  static final String fbAppIdIOS = _Env.fbAppIdIOS;
  @EnviedField(varName: 'FIREBASE_APP_ID_ANDROID')
  static final String fbAppIdAndroid = _Env.fbAppIdAndroid;
  @EnviedField(varName: 'FIREBASE_APP_ID_WEB')
  static final String fbAppIdWeb = _Env.fbAppIdWeb;

  @EnviedField(varName: 'FIREBASE_PROJECT_ID')
  static final String projectId = _Env.fbProjectId;
  @EnviedField(varName: 'FIREBASE_MESSAGING_SENDER_ID')
  static final String fbMessagingSenderId = _Env.fbMessagingSenderId;
  @EnviedField(varName: 'FIREBASE_STORAGE_BUCKET')
  static final String fbStorageBucket = _Env.fbStorageBucket;

  @EnviedField(varName: 'BASE_URL')
  static final String baseUrl = _Env.baseUrl;
}
