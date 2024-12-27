
class CheckoutForm {
  String firstName;
  String lastName;
  String address;
  String country;
  String postalCode;
  String phone;
  String creditCard;
  String code;
  String expiry;

  CheckoutForm(
      {required this.firstName,
      required this.lastName,
      required this.address,
      required this.country,
      required this.postalCode,
      required this.phone,
      required this.creditCard,
      required this.code,
      required this.expiry});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['address'] = address;
    data['country'] = country;
    data['postalCode'] = postalCode;
    data['phone'] = phone;
    data['creditCard'] = creditCard;
    data['code'] = code;
    data['expiry'] = expiry;
    return data;
  }
}
