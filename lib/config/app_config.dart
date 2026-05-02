class AppConfig {
  static const openAIApiKey = String.fromEnvironment('OPENAI_API_KEY');
  static bool get hasApiKey => openAIApiKey.trim().isNotEmpty;
}
