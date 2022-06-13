import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donation/IRepositories/IReceiverRepository.dart';
import 'package:food_donation/Models/Donation.dart';
import '../Utils/Utils.dart';

class ReceiverRepository extends IReceiverRepository{
  @override
  Future requestFood(BuildContext context, Donation donation) async{
    try{
     await FirebaseFirestore.instance.collection("foodRequest").doc().set(donation.toJsonForFoodRequest());
     await FirebaseFirestore.instance.collection("Counts").doc("91yPvyPpYYxKWXefTyh7").update({"pendingRequests": FieldValue.increment(1)});
    }catch(e){
      throw e;
    }
  }

  @override
  Future<List<Donation>> getFoodRequests(BuildContext context, String userId) async{
    List<Donation> foodRequests=[];
    try{
      QuerySnapshot<dynamic> querySnapshot=await FirebaseFirestore.instance.collection("foodRequest").where("userId",isEqualTo: userId).where("status",isNull: true,).get();
      if(querySnapshot.docs.length>0){
        for(int i=0;i<querySnapshot.docs.length;i++){
          foodRequests.add(Donation.fromJsonforFoodRequest(querySnapshot.docs[i].data()));
          log(foodRequests[i].toJson().toString());
        }

      }else{
        Utils.showError(context,"No Wanted Requests Yet");
      }
      return foodRequests;
    }catch(e){
      throw e;
    }
  }

  @override
  Future<List<Donation>> getUnReceivedDonations(BuildContext context) async{
    List<Donation> donations=[];
    try{
      QuerySnapshot<dynamic> querySnapshot=await FirebaseFirestore.instance.collection("Donations").where("status",isNull: true).get();
      if(querySnapshot.docs.length>0){
        for(int i=0;i<querySnapshot.docs.length;i++){
          Donation donation=Donation.fromJson(querySnapshot.docs[i].data());
          donation.id=querySnapshot.docs[i].id;
          donations.add(donation);
        }
      }else{
        Utils.showError(context,"No UnReceived Donations yet");
      }
      return donations;
    }catch(e){
      throw e;
    }
  }

  @override
  Future receiveDonation(BuildContext context, String donationId) async{
    try{
      if(FirebaseAuth.instance.currentUser!=null){
        await FirebaseFirestore.instance.collection("Donations").doc(donationId).update({"status":FirebaseAuth.instance.currentUser?.uid});
        await FirebaseFirestore.instance.collection("Counts").doc("91yPvyPpYYxKWXefTyh7").update({"pendingDonations": FieldValue.increment(-1),"fulfilledDonations":FieldValue.increment(1)});
      }
    }catch(e){
      throw e;
    }
  }

  @override
  Future<List<Donation>> getReceivedDonations(BuildContext context) async{
    List<Donation> donations=[];
    try{
      QuerySnapshot<dynamic> querySnapshot=await FirebaseFirestore.instance.collection("Donations").where("status",isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();
      if(querySnapshot.docs.length>0){
        for(int i=0;i<querySnapshot.docs.length;i++){
          Donation donation=Donation.fromJson(querySnapshot.docs[i].data());
          donation.id=querySnapshot.docs[i].id;
          donations.add(donation);
        }
      }else{
        Utils.showError(context,"No Received Donations yet");
      }
      return donations;
    }catch(e){
      throw e;
    }
  }

  @override
  Future<List<Donation>> getFulFulFilledRequests(BuildContext context) async{
    List<Donation> foodRequests=[];
    try{
      QuerySnapshot<dynamic> querySnapshot=await FirebaseFirestore.instance.collection("foodRequest").where("userId",isEqualTo: FirebaseAuth.instance.currentUser?.uid).where("status",isNull:false).get();
      if(querySnapshot.docs.length>0){
        for(int i=0;i<querySnapshot.docs.length;i++){
          Donation donation=Donation.fromJson(querySnapshot.docs[i].data());
          donation.id=querySnapshot.docs[i].id;
          log(foodRequests[i].toJson().toString());
        }

      }else{
        Utils.showError(context,"No FulFilled Requests Yet");
      }
      return foodRequests;
    }catch(e){
      throw e;
    }
  }


}