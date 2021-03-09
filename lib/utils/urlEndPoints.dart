class URLEndPoints {
  static const String auth_server =
      "https://zm-staging-authserv.zeemart.asia/services/";
  static const String account_managent_server =
      "https://zm-staging-accountmanagementserv.zeemart.asia/";
  static const String report_management_server =
      "https://zm-staging-reportmanagementserv.zeemart.asia/services/";
  static const String order_management_server =
      "https://zm-staging-ordermanagementserv.zeemart.asia/services/";
  static const String inventory_management_server =
      "https://zm-staging-inventorymanagement.zeemart.asia/services/";

  static const String login_url = auth_server + "supplier/login";
  static const String get_specific_user_url =
      account_managent_server + "account/supplier";
  static const String forgot_password_url =
      auth_server + "sendVerificationCode";
  static const String validate_verification_code =
      auth_server + "validateVerificationCode";
  static const String create_password = auth_server + "resetPassword";
  static const String change_password = auth_server + "changePassword/v1";

  static const String img_upload_url =
      "http://zm-staging-commonservices.zeemart.asia/services/storage/files/multipart";
  static const String retrieve_orders = order_management_server + "orders/po";
  static const String create_draft_orders = order_management_server + "orders/po/draft";
  static const String retrieve_outlets = inventory_management_server +
      "inventory/deliveryPreference/linkedOutlets";
  static const String retrieve_supplier_delivery_dates = inventory_management_server +
      "inventory/deliveryPreference/delivery/settings";
  static const String retrieve_outlet_market_list =
      inventory_management_server + "inventory/marketlist";
  static const String order_summary_url =
      report_management_server + "reports/order/summary";
  static const String retrive_paginated_orders_url =
      order_management_server + "orders/po";
  static const String order_activity_url =
      order_management_server + "orders/activitylogs";

  static const String customersList_url = inventory_management_server +
      "inventory/deliveryPreference/linkedOutlets";
  static const String favourite_url =
      inventory_management_server + "inventory/deliveryPreference/favourite";
}
