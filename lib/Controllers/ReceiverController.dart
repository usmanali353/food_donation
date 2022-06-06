import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donation/IRepositories/IReceiverRepository.dart';
import 'package:food_donation/Models/Donation.dart';
import 'package:food_donation/Models/userData.dart';
import 'package:food_donation/Ui/Receiver/ReceiverHome.dart';
import 'package:food_donation/Utils/Address.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/Locator.dart';
import '../Utils/Utils.dart';
import 'AccountController.dart';

class ReceiverController extends GetxController{
 late TextEditingController descriptionTextEditingController,addressTextEditingController,personsQuantityTextEditingController;
  int? selectedCategoryId,selectedDeliveryTypeId;

  String? selectedCategory,selectedDeliveryType;
  Address? address;
 List<String> categories=["Cooked Food","Fruits","Vegetables","Sweets","Chocolates","Cakes","Biscuits","Milk","Grains","Mix Items","Others",];
 List<String> deliveryTypes=["Pick Up","Drop Off"];
  var foodRequests=[].obs;
  var donations=[].obs;
  var donated=[].obs;
 var fulfilledRequests=[].obs;
 late IReceiverRepository receiverRepository;
 Rx<bool> addingFoodRequest=false.obs;
  void onInit(){
    super.onInit();
    descriptionTextEditingController = TextEditingController();
    addressTextEditingController = TextEditingController();
    personsQuantityTextEditingController = TextEditingController();
    receiverRepository=locator<IReceiverRepository>();
  }

  void requestFood(BuildContext context){
    Utils.isInternetAvailable().then((isConnected){
      if(isConnected){
        if(selectedCategory==null){
          Utils.showError(context,"Select Category");
        }else if(descriptionTextEditingController.text.isEmpty){
          Utils.showError(context,"Please Provide Some Description");
        }else if(personsQuantityTextEditingController.text.isEmpty){
          Utils.showError(context,"Please Specify for how many persons Food is required");
        }else if(selectedDeliveryType==null){
          Utils.showError(context,"Please Specify how you will receive the Donated Food");
        }else if(addressTextEditingController.text.isEmpty){
          Utils.showError(context,"Please Specify Your Address");
        }else if(address==null){
          Utils.showError(context,"Please Specify Your Address");
          addressTextEditingController.text="";
        }else{
          SharedPreferences.getInstance().then((prefs){
            if(prefs.getString("user_data")!=null){
              UserData user= UserData.userFromJson(prefs.getString("user_data")!);
              addingFoodRequest.value=true;
              receiverRepository.requestFood(context,Donation(name: user.name,userId: FirebaseAuth.instance.currentUser?.uid,phone: user.phone,description: descriptionTextEditingController.text,deliveryType: selectedDeliveryTypeId,category: selectedCategoryId,lat: address?.latitude,lng: address?.longitude,address: address?.address,createdOn: DateTime.now().toIso8601String(),personsQuantity: int.parse(personsQuantityTextEditingController.text) )).then((value){
                descriptionTextEditingController.text="";
                addressTextEditingController.text = "";
                personsQuantityTextEditingController.text= "";
                selectedDeliveryType=null;
                selectedCategory=null;
                addingFoodRequest.value=false;
                Get.offAll(()=>ReceiverHome());
              }).catchError((error){
                Utils.showError(context,error.toString());
                addingFoodRequest.value=false;
              });

            }
          });
        }

      }else{
        Utils.showError(context,"Device is not Connected to the Network");
      }
    });
  }
  Future getFoodRequests(BuildContext context)async{
    bool isConnected = await  Utils.isInternetAvailable();
    if(isConnected){
      foodRequests.clear();
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      List<Donation> foodRequestList=await receiverRepository.getFoodRequests(context, userId!);
      foodRequests.assignAll(foodRequestList);
      log("Food Requests "+foodRequests.length.toString());
    }else{
      Utils.showError(context,"Your Device is not connected to Network");
    }
  }

 Future getUnReceivedDonations(BuildContext context)async{
   bool isConnected = await  Utils.isInternetAvailable();
   if(isConnected){
     List<Donation> donationsList=await receiverRepository.getUnReceivedDonations(context);
     donations.clear();
     donations.assignAll(donationsList);
     log("Un Received Donations "+donationsList.length.toString());
   }else{
     Utils.showError(context,"Your Device is not connected to Network");
   }
 }

 void receiveDonations(BuildContext context,String donationId){
    Utils.isInternetAvailable().then((isConnected){
      if(isConnected){
        addingFoodRequest.value=true;
        receiverRepository.receiveDonation(context, donationId).then((value){
          addingFoodRequest.value=false;
          Get.offAll(()=>ReceiverHome());
        }).catchError((error){
          Utils.showError(context, error);
          addingFoodRequest.value=false;
        });
      }else{
        Utils.showError(context,"Your Device is not connected to Network");
      }
    });

 }
 Future getReceivedDonations(BuildContext context)async{
   bool isConnected = await  Utils.isInternetAvailable();
   if(isConnected){
     donated.clear();
     List<Donation> donationsList=await receiverRepository.getReceivedDonations(context);
     donated.assignAll(donationsList);
     log("Received Donations "+donationsList.length.toString());
   }else{
     Utils.showError(context,"Your Device is not connected to Network");
   }
 }
 Future getFulfilledRequests(BuildContext context)async{
   bool isConnected = await  Utils.isInternetAvailable();
   if(isConnected){
     fulfilledRequests.clear();
     List<Donation> donationsList=await receiverRepository.getFulFulFilledRequests(context);
     fulfilledRequests.assignAll(donationsList);
   }else{
     Utils.showError(context,"Your Device is not connected to Network");
   }
 }
 void getUserInfoById(BuildContext context,String userId){
   addingFoodRequest.value=true;
   Get.find<AccountController>().accountRepository.getUserInfoById(context, userId).then((userInfo){
     addingFoodRequest.value=false;
   }).catchError((error){
     Utils.showError(context, error.toString());
     addingFoodRequest.value=false;
   });
 }
}