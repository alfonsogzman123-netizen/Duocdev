class ApiConfig {
  static const _defaultBaseUrl = 'http://10.0.2.2:3000';
  static const baseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );
  static const timeoutSeconds = 10;

  static bool get isConfigured => baseUrl.trim().isNotEmpty;
}
