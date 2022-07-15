import 'dart:convert';

class Rating {
  String? ratedByName,ratedById,ratedOn,donationId,comment;
  double? rating;
  Rating({
    this.ratedByName,
    this.ratedById,
    this.ratedOn,
    this.donationId,
    this.comment,
    this.rating
  });
  static List<Rating> ratingListFromJson(String str) => List<Rating>.from(json.decode(str).map((x) => Rating.fromJson(x)));

  Map<String, dynamic> toJson() => {
    "ratedByName": ratedByName,
    "ratedById": ratedById,
    "ratedOn": ratedOn,
    "donationId": donationId,
    "comment": comment,
    "rating": rating,
  };
  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    ratedByName: json["ratedByName"],
    ratedById: json["ratedById"],
    ratedOn: json["ratedOn"],
    donationId: json["donationId"],
    comment: json["comment"],
    rating: json["rating"],
  );
}