class CustomerModel {
  int? id;

  String customerName;
  String address;
  String type;
  String email;
  String mobile;
  String city;
  String country;
  String phone;
  String rateType;
  String pinNo;
  String gstinNo;
  String place;
  String customerType;
  String discountPercentage;
  String creditDays;
 String imagePath;
List<String> additionalImages;

  CustomerModel({
    this.id,
    required this.customerName,
    required this.address,
    required this.type,
    required this.email,
    required this.mobile,
    required this.city,
    required this.country,
    required this.phone,
    required this.rateType,
    required this.pinNo,
    required this.gstinNo,
    required this.place,
    required this.customerType,
    required this.discountPercentage,
    required this.creditDays,
  required this.imagePath,
required this.additionalImages,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'address': address,
      'type': type,
      'email': email,
      'mobile': mobile,
      'city': city,
      'country': country,
      'phone': phone,
      'rateType': rateType,
      'pinNo': pinNo,
      'gstinNo': gstinNo,
      'place': place,
      'customerType': customerType,
      'discountPercentage': discountPercentage,
      'creditDays': creditDays,
      'imagePath': imagePath,
'additionalImages': additionalImages.join('|'),
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      customerName: map['customerName'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      email: map['email'] ?? '',
      mobile: map['mobile'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      phone: map['phone'] ?? '',
      rateType: map['rateType'] ?? '',
      pinNo: map['pinNo'] ?? '',
      gstinNo: map['gstinNo'] ?? '',
      place: map['place'] ?? '',
      customerType: map['customerType'] ?? '',
      discountPercentage: map['discountPercentage'] ?? '',
      creditDays: map['creditDays'] ?? '',
    imagePath: map['imagePath'] ?? '',
additionalImages:
    map['additionalImages'] == null ||
            map['additionalImages'].toString().isEmpty
        ? []
        : map['additionalImages'].toString().split('|'), 
    );
  }
}