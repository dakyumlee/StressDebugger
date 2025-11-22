class ApiConfig {
  static const String localBaseUrl = 'http://localhost:8080/api';
  static const String productionBaseUrl = 'https://your-production-url.com/api';
  
  static String get baseUrl {
    const bool isProduction = bool.fromEnvironment('dart.vm.product');
    return isProduction ? productionBaseUrl : localBaseUrl;
  }
}
