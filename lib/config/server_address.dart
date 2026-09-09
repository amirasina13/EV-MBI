import 'config.dart';

class ServerAddresses {
  // Get country code
  static final country = '$apiVersionDefault/countries';

  /* ------------------------------------------------------------------GLOBAL */
  // Get global
  static final global = '$apiVersionDefault/global';

  /* ----------------------------------------------------------------------OTP*/
  // Generate the otp
  static final generateOtp = '$apiVersionDefault/otp/generate';
  // Verify the otp entered
  static final verifyOtp = '$apiVersionDefault/otp/verify';

  /* ---------------------------------------------------USER REGISTER & LOGIN */
  // Verify user phone/email to get vToken
  static final verifyRegister = '$apiVersionDefault/register/verify';
  // User register
  static final register = '$apiVersionDefault/register';
  // User login
  static final login = '$apiVersionDefault/login';
  // User verify token
  static final verify = '$apiVersionDefault/login/verify';

  /* ----------------------------------------------------------FORGOT PASSWORD*/
  // Pass mobile no parameter
  static final forgot = '$apiVersionDefault/forgot';
  // Pass the otp, token, new password
  static final reset = '$apiVersionDefault/forgot/reset';

  /* ------------------------------------------------------------USER PROFILE */
  // Get user profile
  static final profile = '$apiVersionDefault/user/profile';
  // Update user profile (Will use in profile setting)
  static final profileUpdate = '$apiVersionDefault/user/profile/update';
  // Upload/Update user profile photo
  static final profilePhoto = '$apiVersionDefault/user/profile/upload';
  // Delete user account
  static final deleteAccount = '$apiVersionDefault/user/profile/delete';

  /* -----------------------------------------------------------------LOCATION EV*/
  // Show location List
  static final locationList = '$apiVersionDefault/locations/lists';
  // Show location details
  static final locationDetail = '$apiVersionDefault/locations/detail';

  /* ------------------------------------------------------------HOMEPAGE */
  // Get homepage
  static final getHomepage = '$apiVersionDefault/locations/home';

  /* -----------------------------------------------------------------TRANSACTION HISTORY */
  // Show transaction List
  static final transactionList = '$apiVersionDefault/user/transactions/lists';
  // Show transaction details
  static final transactionDetail =
      '$apiVersionDefault/user/transactions/details';

  /* -----------------------------------------------------------------LOCATION EV*/
  // scan code
  static final scanCode = '$apiVersionDefault/user/transactions/scan';
}
