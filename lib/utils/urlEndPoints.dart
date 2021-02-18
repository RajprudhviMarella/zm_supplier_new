
class URLEndPoints {

  static const String auth_server = "https://zm-staging-authserv.zeemart.asia/services/";
  static const String account_managent_server = "https://zm-staging-accountmanagementserv.zeemart.asia/";

  static const String login_url = auth_server + "supplier/login";
  static const String get_specific_user_url = account_managent_server + "account/supplier";
  static const String forgot_password_url = auth_server + "sendVerificationCode";
  static const String validate_verification_code = auth_server + "validateVerificationCode";
  static const String change_password = auth_server +"changePassword/v1";
  static const String img_upload_url = "http://zm-staging-commonservices.zeemart.asia/services/storage/files/multipart";
}