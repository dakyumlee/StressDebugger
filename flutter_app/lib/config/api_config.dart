class ApiConfig {
  static const String localBaseUrl = 'http://localhost:8080/api';
  
  static String get baseUrl {
    const apiUrl = String.fromEnvironment('API_URL', defaultValue: localBaseUrl);
    return apiUrl;
  }
}
