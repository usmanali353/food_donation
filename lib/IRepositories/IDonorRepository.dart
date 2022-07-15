import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/Donation.dart';

abstract class IDonorRepository{
  Future donateFood(BuildContext context,Donation donation,List<XFile> images);
  Future<List<Donation>> getDonations(BuildContext context,String userId);
  Future<List<Donation>> getFoodRequests(BuildContext context);
  Future fulfillRequest(BuildContext context,String userId,String comment,double rating,String ratedFor);
  Future<List<Donation>> getRequestsFulfilledByDonor(BuildContext context,String? userId);
  Future<List<Donation>> getDonationsReceivedByReceivers(BuildContext context,String? userId);
  Future addPricedDonations(BuildContext context,Donation donation,XFile image);
  Future<List<Donation>> getPricedDonation(BuildContext context,String? userId);
}