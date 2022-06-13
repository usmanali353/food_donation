import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_donation/IRepositories/IAdminRepository.dart';
import 'package:food_donation/Models/Counts.dart';
import 'package:food_donation/Models/Donation.dart';
import 'package:food_donation/Models/userData.dart';

import '../Utils/Utils.dart';

class AdminRepository extends IAdminRepository{
  @override
  Future<Counts> getDashboardCounts(BuildContext context) async{
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore.instance.collection("Counts").doc("91yPvyPpYYxKWXefTyh7").get();
    return Counts.fromJson(docSnapshot.data()!);
  }

  @override
  Future<List<Donation>> getDonationsByType(BuildContext context, int type) {
    // TODO: implement getDonationsByType
    throw UnimplementedError();
  }

  @override
  Future<List<Donation>> getRequestsByType(BuildContext context, int type) {
    // TODO: implement getRequestsByType
    throw UnimplementedError();
  }
}