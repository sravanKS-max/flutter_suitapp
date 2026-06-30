class ApiConfig {
  // Base URL for API endpoints
  static const String baseUrl = 'https://flutterapp.suitapp.in/api';

  // Full API base URL with version
  static const String apiBaseUrl = baseUrl;

  // Common endpoints
  static const String loginEndpoint = '/login';
  static const String companiesUrl = '/companies';
  static const String insertLoginLogUrl = '/insertLoginLog';

  //suitapp
  static const String getrootNameUrl = '/GetRouteName';
  static const String getCustomersUrl = '/GetCustomerDetails';
  static const String sendOtp = '/sendOtp';
  static const String resetPassword = '/resetPassword';
  static const String getAttendanceTypes = '/getAttendanceTypes';
  static const String insertEmployeeAttendance = '/insertEmployeeAttendance';
  static const String checkTodayAttendance = '/checkTodayAttendance';
  static const String getLeaveTypes = '/getLeaveTypes';
  static const String insertLeaveRequest = '/insertLeaveRequest';
  // static const String getLeaveRequests = '/getLeaveRequests';
  static const String getAllRootsByEmp = '/getAllRootsByEmp';
  
 

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
         