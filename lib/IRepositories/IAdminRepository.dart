import 'package:flutter/material.dart';
import 'package:food_donation/Models/Donation.dart';
import '../Models/Counts.dart';
import '../Models/userData.dart';

abstract class IAdminRepository{
  Future<Counts> getDashboardCounts(BuildContext context);
  Future<List<Donation>> getRequestsByType(BuildContext context,int type);
  Future<List<Donation>> getDonationsByType(BuildContext context,int type);
}