import 'package:flutter/material.dart';
import 'package:food_donation/Models/Donation.dart';

abstract class IReceiverRepository{
  Future requestFood(BuildContext context,Donation donation);
  Future<List<Donation>> getFoodRequests(BuildContext context,String userId);
  Future<List<Donation>> getUnReceivedDonations(BuildContext context);
  Future receiveDonation(BuildContext context,String donationId);
  Future<List<Donation>> getReceivedDonations(BuildContext context,String userId);
  Future<List<Donation>> getFulFulFilledRequests(BuildContext context,String userId);
}