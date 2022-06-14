import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_donation/IRepositories/IAdminRepository.dart';
import 'package:food_donation/Models/Counts.dart';
import 'package:food_donation/Models/Donation.dart';

class AdminRepository extends IAdminRepository{
  @override
  Future<Counts> getDashboardCounts(BuildContext context) async{
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore.instance.collection("Counts").doc("91yPvyPpYYxKWXefTyh7").get();
    return Counts.fromJson(docSnapshot.data()!);
  }

  @override
  Future<List<Donation>> getDonationsByType(BuildContext context, int type) async{
    List<Donation> donations=[];
    try{
      if(type==0){
        QuerySnapshot<Map<String,dynamic>> snapshot =  await FirebaseFirestore.instance.collection("Donations").where("status",isNull: true).get();
        if(snapshot.docs.length>0){
          for(int i=0;i<snapshot.docs.length;i++){
            donations.add(Donation.fromJson(snapshot.docs[i].data()));
          }
          return donations;
        }
      }else{
        QuerySnapshot<Map<String,dynamic>> snapshot = await FirebaseFirestore.instance.collection("Donations").where("status",isNull: false).get();
        if(snapshot.docs.length>0){
          for(int i=0;i<snapshot.docs.length;i++){
            donations.add(Donation.fromJson(snapshot.docs[i].data()));
          }
          return donations;
        }
      }
    }catch(e){
      throw e;
    }
    return donations;
  }

  @override
  Future<List<Donation>> getRequestsByType(BuildContext context, int type) async{
    List<Donation> requests=[];
    try{
      if(type==0){
        QuerySnapshot<Map<String,dynamic>> snapshot =  await FirebaseFirestore.instance.collection("foodRequest").where("status",isNull: true).get();
        if(snapshot.docs.length>0){
          for(int i=0;i<snapshot.docs.length;i++){
            requests.add(Donation.fromJson(snapshot.docs[i].data()));
          }
          return requests;
        }
      }else{
        QuerySnapshot<Map<String,dynamic>> snapshot = await FirebaseFirestore.instance.collection("foodRequest").where("status",isNull: false).get();
        if(snapshot.docs.length>0){
          for(int i=0;i<snapshot.docs.length;i++){
            requests.add(Donation.fromJson(snapshot.docs[i].data()));
          }
          return requests;
        }
      }
    }catch(e){
      throw e;
    }
    return requests;
  }
}