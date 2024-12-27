class IpData {
  String? countryCode;
  String? countryName;
  String? city;
  String? postal;
  double? latitude;
  double? longitude;
  String? iPv4;
  String? state;

  IpData(
      {this.countryCode,
      this.countryName,
      this.city,
      this.postal,
      this.latitude,
      this.longitude,
      this.iPv4,
      this.state});

  IpData.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    countryName = json['country_name'];
    city = json['city'];
    postal = json['postal'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    iPv4 = json['IPv4'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['country_code'] = countryCode;
    data['country_name'] = countryName;
    data['city'] = city;
    data['postal'] = postal;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['IPv4'] = iPv4;
    data['state'] = state;
    return data;
  }
}