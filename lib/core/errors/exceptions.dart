class ApiKeyMissingException implements Exception {
  final String message;
  ApiKeyMissingException([this.message = 'Gemini API Key is missing']);
}

class GeminiAnalysisException implements Exception {
  final String message;
  GeminiAnalysisException(this.message);

  @override
  String toString() => 'GeminiAnalysisException: $message';
}
