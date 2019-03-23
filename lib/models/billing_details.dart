class BillingDetails {
  String status;
  String firstName;
  String lastName;
  String address1;
  String city;
  String state;
  String postCode;
  String country;
  String email;
  String phone;

  BillingDetails({
    this.status,
    this.firstName,
    this.lastName,
    this.address1,
    this.state,
    this.postCode,
    this.country,
    this.city,
    this.phone,
    this.email
  });

  factory BillingDetails.fromJson(Map data){
    return BillingDetails(
      status: data['status'],
      firstName: data['billing_first_name'],
      lastName: data['billing_last_name'],
      address1: data['billing_address_1'],
      city: data['billing_city'],
      state: data['billing_state'],
      postCode: data['billing_postcode'],
      country: data['billing_country'],
      email: data['billing_email'],
      phone: data['billing_phone']
    );
  }
}