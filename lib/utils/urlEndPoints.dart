import 'constants.dart';

class URLEndPoints {
  static get login_url {
    return Constants.AUTH_SERVER + "supplier/login";
  }

  static get register_device_url {
    return Constants.NOTIFICATION_SERVER + "notification/devices";
  }

  static get get_specific_user_url {
    return Constants.ACCOUNT_MANAGEMENT_SERVER + "account/supplier";
  }

  static get get_specific_user_login_url {
    return Constants.ACCOUNT_MANAGEMENT_SERVER + "account/user";
  }

  static get forgot_password_url {
    return Constants.AUTH_SERVER + "sendVerificationCode";
  }

  static get validate_verification_code {
    return Constants.AUTH_SERVER + "validateVerificationCode";
  }

  static get create_password {
    return Constants.AUTH_SERVER + "resetPassword";
  }

  static get change_password {
    return Constants.AUTH_SERVER + "changePassword/v1";
  }

  static get img_upload_url {
    return Constants.COMMON_SERVER + "storage/files/multipart";
  }

  static get retrieve_orders {
    return Constants.ORDER_MANAGEMENT_SERVER + "orders/po";
  }

  static get edit_place_order {
    return Constants.ORDER_MANAGEMENT_SERVER + "orders/po/draft/edit/place";
  }

  static get validate_add_on_order {
    return Constants.ORDER_MANAGEMENT_SERVER + "orders/po/validate/addOn";
  }

  static get create_draft_orders {
    return Constants.ORDER_MANAGEMENT_SERVER + "orders/po/draft";
  }

  static get retrieve_outlets {
    return Constants.INVENTORY_SERVER +
        "inventory/deliveryPreference/linkedOutlets";
  }

  static get retrieve_supplier_delivery_dates {
    return Constants.INVENTORY_SERVER +
        "inventory/deliveryPreference/delivery/settings";
  }

  static get retrieve_outlet_market_list {
    return Constants.INVENTORY_SERVER + "inventory/marketlist";
  }

  static get order_summary_url {
    return Constants.REPORT_SERVER + "reports/order/summary";
  }

  static get retrive_paginated_orders_url {
    return Constants.ORDER_MANAGEMENT_SERVER + "orders/po";
  }

  static get acknowledge_order {
    return Constants.ORDER_MANAGEMENT_SERVER + 'orders/po/acknowledge';
  }

  static get void_order {
    return Constants.ORDER_MANAGEMENT_SERVER + 'orders/po/reject';
  }

  static get order_activity_url {
    return Constants.ORDER_MANAGEMENT_SERVER + "orders/activitylogs";
  }

  static get customersList_url {
    return Constants.INVENTORY_SERVER +
        "inventory/deliveryPreference/linkedOutlets";
  }

  static get favourite_url {
    return Constants.INVENTORY_SERVER +
        "inventory/deliveryPreference/favourite";
  }

  static get recent_orderd_outlets {
    return Constants.INVENTORY_SERVER +
        "inventory/deliveryPreference/recent/order/outlets";
  }

  static get customers_report_data {
    return Constants.REPORT_SERVER + "reports/customers";
  }

  static get buyer_people_url {
    return Constants.ACCOUNT_MANAGEMENT_SERVER + "account/users/outlet";
  }

  //Invoice related URLs.
  static get retrive_invoices_url {
    return Constants.INVOICE_SERVER + "supplier/eInvoices/v1";
  }

  static get retrive_specific_invoice {
    return Constants.INVOICE_SERVER + 'invoice';
  }

  static get retrive_specific_order_details {
    return Constants.ORDER_MANAGEMENT_SERVER + '/orders/po/orderById';
  }

  static get retrive_invoices_summary {
    return Constants.REPORT_SERVER + 'reports/invoices/summary';
  }

  static get retrieve_categories {
    return Constants.REPORT_SERVER + "reports/category";
  }

  static get retrieve_catalogue {
    return Constants.INVENTORY_SERVER + "inventory/products";
  }

  static get retrieve_subCategories {
    return Constants.COMMON_SERVER + "inventory/productcategories";
  }

  static get fav_sku_url {
    return Constants.INVENTORY_SERVER + "inventory/product/favourites";
  }

  static get user_goals_url {
    return Constants.ACCOUNT_MANAGEMENT_SERVER + "/account/user/goal";
  }
}
