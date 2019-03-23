class Order{
  int id;
  int parentId;
  String number;
  String status;
  String currency;
  String dateCreated;
  String discountTotal;
  String discountTax;
  String shippingTotal;
  String shippingTax;
  String cartTax;
  String total;
  String totalTax;
  int customerId;

  String paymentMethod;
  String paymentMethodTitle;
  String datePaid;
  String dateCompleted;
  List lineItems;

  List taxLines;
  List shippingLines;
  List feeLines;
  List couponLines;
  List refund;

  String billingFirstName;
  String billingLastName;
  String billingAddress1;
  String billingCity;
  String billingState;
  String billingPostCode;
  String billingCountry;
  String billingEmail;
  String billingPhone;

  String shippingFirstName;
  String shippingLastName;
  String shippingAddress1;
  String shippingCity;
  String shippingState;
  String shippingPostCode;
  String shippingCountry;
  String shippingEmail;
  String shippingPhone;

  Order({this.id, this.parentId, this.number, this.status, this.currency,
      this.dateCreated, this.discountTotal, this.discountTax,
      this.shippingTotal, this.shippingTax, this.cartTax, this.total,
      this.totalTax, this.customerId, this.paymentMethod,
      this.paymentMethodTitle, this.datePaid, this.dateCompleted,
      this.lineItems, this.taxLines, this.shippingLines, this.feeLines,
      this.couponLines, this.refund, this.billingFirstName,
      this.billingLastName, this.billingAddress1, this.billingCity,
      this.billingState, this.billingPostCode, this.billingCountry,
      this.billingEmail, this.billingPhone, this.shippingFirstName,
      this.shippingLastName, this.shippingAddress1, this.shippingCity,
      this.shippingState, this.shippingPostCode, this.shippingCountry,
      this.shippingEmail, this.shippingPhone});


  factory Order.fromJson(Map data){
    return Order(
      id: data['id'],
      parentId: data['parent_id'],
      number: data['number'],
      status: data['status'],
      currency: data['currency'],
      dateCreated: data['date_created'],
      discountTotal: data['discount_total'],
      discountTax: data['discount_tax'],
      shippingTotal: data['shipping_total'],
      shippingTax: data['shipping_tax'],
      cartTax: data['cart_tax'],
      total: data['total'],
      totalTax: data['total_tax'],
      customerId: data['customer_id'],
      paymentMethod: data['payment_method'],
      paymentMethodTitle: data['payment_method_title'],
      datePaid: data['date_paid'],
      dateCompleted: data['date_completed'],
      lineItems: data['line_items'],
      taxLines: data['tax_lines'],
      shippingLines: data['shipping_lines'],
      feeLines: data['fee_lines'],
      couponLines: data['coupon_lines'],
      refund: data['refunds'],
      billingFirstName: data['billing']['first_name'],
      billingLastName: data['billing']['last_name'],
      billingAddress1: data['billing']['address_1'],
      billingCity: data['billing']['city'],
      billingCountry: data['billing']['country'],
      billingEmail: data['billing']['email'],
      billingPhone: data['billing']['phone'],
      billingPostCode: data['billing']['postcode'],
      billingState: data['billing']['state'],
      shippingAddress1: data['shipping']['address_1'],
      shippingCity: data['shipping']['city'],
      shippingCountry: data['shipping']['country'],
      shippingEmail: data['shipping']['email'],
      shippingFirstName: data['shipping']['first_name'],
      shippingLastName: data['shipping']['last_name'],
      shippingPhone: data['shipping']['phone'],
      shippingPostCode: data['shipping']['postcode'],
      shippingState: data['shipping']['state'],
    );
  }

}