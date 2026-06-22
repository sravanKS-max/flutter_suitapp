class ApiConfig {
  // Base URL for API endpoints
  static const String baseUrl = 'https://flutterapp.suitapp.in/api';

  // Full API base URL with version
  static const String apiBaseUrl = baseUrl;

  // Common endpoints
  static const String loginEndpoint = '/login';
  static const String companiesUrl = '/companies';
  static const String insertLoginLogUrl = '/insertLoginLog';
  static const String getrootNameUrl = '/GetRouteName';
  static const String getCustomersUrl = '/GetCustomerDetails';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
