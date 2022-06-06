import 'dart:convert';
class Donation {
  Donation({
    this.userId,
    this.name,
    this.description,
    this.address,
    this.phone,
    this.lat,
    this.lng,
    this.availableUpTo,
    this.status,
    this.deliveryType,
    this.category,
    this.createdOn,
    this.personsQuantity,
    this.images,
    this.id
  });

  static Donation donationFromJson(String str) => Donation.fromJson(json.decode(str));

  static String donationToJson(Donation data) => json.encode(data.toJson());

  String? userId;
  String? id;
  String? name;
  String? description;
  String? address;
  String? phone;
  double? lat;
  double? lng;
  String? createdOn,availableUpTo,status;
  List<dynamic>? images=[];
  int? deliveryType,category;
  int? personsQuantity;

  factory Donation.fromJson(Map<String, dynamic> json) => Donation(
      userId: json["userId"],
      name: json["name"],
    description: json["description"],
    images: json["images"],
    address: json["address"],
    phone: json["phone"],
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
    availableUpTo: json["availableUpTo"],
      status: json["status"],
     category: json["category"],
    createdOn: json["createdOn"],
    personsQuantity: json["personsQuantity"],
      deliveryType:json["deliveryType"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "personsQuantity": personsQuantity,
    "description": description,
    "images": images,
    "address": address,
    "phone": phone,
    "lat": lat,
    "lng": lng,
    "availableUpTo": availableUpTo,
    "status":status,
    "category":category,
    "createdOn":createdOn,
    "deliveryType":deliveryType
  };

  Map<String, dynamic> toJsonForFoodRequest() => {
    "userId": userId,
    "name": name,
    "description": description,
    "address": address,
    "phone": phone,
    "lat": lat,
    "lng": lng,
    "status":status,
    "deliveryType":deliveryType,
    "category":category,
    "createdOn":createdOn,
    "personsQuantity":personsQuantity,
  };

  factory Donation.fromJsonforFoodRequest(Map<String, dynamic> json) => Donation(
      userId: json["userId"],
      name: json["name"],
      description: json["description"],
      address: json["address"],
      phone: json["phone"],
      lat: json["lat"].toDouble(),
      lng: json["lng"].toDouble(),
      status: json["status"],
      category: json["category"],
      createdOn: json["createdOn"],
      personsQuantity: json["personsQuantity"],
      deliveryType:json["deliveryType"]
  );
}
