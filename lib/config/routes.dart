// Routes from page to another page

class MainRoutes {
  // SPLASH SCREEN

  // REGISTER
  static const verifyRegister = 'verify_register';
  static const register = 'register';
  static const otp = 'registerOtp';
  static const otpVerify = 'registerOtp_verify';

  // FORGOT PASSWORD
  static const forgotPassword = 'forgot_pass';
  static const resetPassword = 'reset_pass';

  // LOGIN
  static const login = 'login';

  // SETUP VALID AFTER REGISTER (OTP)
  static const setupEValid = 'evalid';
  static const setupEValidOtp = 'evalid_otp';
  static const setupCValid = 'cvalid';
  static const setupCValidOtp = 'cvalid_otp';
  static const setupVProfile = 'vprofile';
  static const setupVMuslim = 'vMuslim';

  // HOMEPAGE
  static const home = 'home';

  // LOCATIONS
  static const locationList = 'location_list';
  static const locationDetail = 'location_detail';

  // HISTORY
  static const historyList = 'history_list';
  static const historyDetail = 'history_detail';

  // MAP PAGE
  static const map = 'map';

  // SCAN PAGE
  static const scan = 'scan';

  // INFO PAGE
  static const info = 'info';

  // GUIDE PAGE
  static const guide = 'guide';

  // SETTING PAGE
  static const setting = 'setting';

  // MY ACCOUNT PAGE
  static const profile = 'profile';
  static const account = 'account';

  // HISTORY
  static const history = 'history';

  // SECURITY PIN
  static const securityCreate = 'create';
  // static const securityChange = 'security_change';
  static const securityOtp = 'security_otp';
  static const securitySet = 'security_Set';
  static const passcodeKey = 'passcode_key';

  // VERIFY EMAIL
  static const verifyEmail = 'verify_email';
  static const verifyEmailOtp = 'verify_email_otp';

  // DELETE ACCOUNT
  static const deleteAccount = 'delete_account';
  static const deleteMobile = 'delete_mobile';

  // SCANNER
  static const scannerPage = 'scanner_page'; // OLD
  static const scannerScreen = 'scanner_screen';
  static const scannerResultScreen = 'scanner_result_screen';

  // MAINTENANCE
  static const maintenanceScreen = 'maintenance_screen';

  // SERVICE ERROR
  static const serviceScreen = 'service_screen';

  // SEARCH RESULTS
  static const searchResultsPage = 'search_results_page';
  static const searchAPIPage = 'search_api';
}
