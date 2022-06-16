import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donation/IRepositories/IReceiverRepository.dart';
import 'package:food_donation/Models/Donation.dart';
import 'package:food_donation/Models/userData.dart';
import 'package:food_donation/Ui/Receiver/ReceiverHome.dart';
import 'package:food_donation/Utils/Address.dart';
import 'package:food_donation/Utils/Constants.dart';
import 'package:geolocator/geolocator.dart';
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
 var filteredList=[].obs;
 var _selected=[].obs;
 Rx<double> sliderValue=1.0.obs;
 late IReceiverRepository receiverRepository;
 Rx<bool> addingFoodRequest=false.obs;

 //variables used to check if currently List Data is Loading
 Rx<bool> fetchingPendingRequests=false.obs;
 Rx<bool> fetchingPendingDonations=false.obs;
 Rx<bool> fetchingRequestsHistory=false.obs;
 Rx<bool> fetchingDonationsHistory=false.obs;


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
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      fetchingPendingRequests.value=true;
      await receiverRepository.getFoodRequests(context, userId!).then((foodRequestList){
        foodRequests.clear();
        foodRequests.assignAll(foodRequestList);
        fetchingPendingRequests.value=false;
      }).catchError((error){
        fetchingPendingRequests.value=false;
        Utils.showError(context,error.toString());
      });

      log("Food Requests "+foodRequests.length.toString());
    }else{
      Utils.showError(context,"Your Device is not connected to Network");
    }
  }

 Future getUnReceivedDonations(BuildContext context)async{
   bool isConnected = await  Utils.isInternetAvailable();
   if(isConnected){
     fetchingPendingDonations.value=true;
     await receiverRepository.getUnReceivedDonations(context).then((donationsList){
       donations.clear();
       filteredList.clear();
       filteredList.assignAll(donationsList);
       donations.assignAll(donationsList);
       fetchingPendingDonations.value=false;
       log("Un Received Donations "+donationsList.length.toString());
     }).catchError((error){
       fetchingPendingDonations.value=false;
       Utils.showError(context, error.toString());
     });

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
 Future getReceivedDonations(BuildContext context,String? userId)async{
   bool isConnected = await  Utils.isInternetAvailable();
   if(isConnected){
      fetchingDonationsHistory.value=true;
     await receiverRepository.getReceivedDonations(context,userId!).then((donationsList){
       donated.clear();
       donated.assignAll(donationsList);
       log("Received Donations "+donationsList.length.toString());
       fetchingDonationsHistory.value=false;
     }).catchError((error){
       Utils.showError(context, error.toString());
       fetchingDonationsHistory.value=false;
     });


   }else{
     Utils.showError(context,"Your Device is not connected to Network");
   }
 }
 Future getFulfilledRequests(BuildContext context,String? userId)async{
   bool isConnected = await  Utils.isInternetAvailable();
   if(isConnected){
     fetchingRequestsHistory.value=true;
     await receiverRepository.getFulFulFilledRequests(context,userId!).then((donationsList){
       fulfilledRequests.clear();
       fulfilledRequests.assignAll(donationsList);
       fetchingRequestsHistory.value=false;
     }).catchError((error){
       fetchingRequestsHistory.value=false;
       Utils.showError(context,"No Requests Found");
     });

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

 Widget buildChips(BuildContext context) {
   List<Widget> chips =[];

   for (int i = 0; i < categories.length; i++) {
     _selected.add(false);
     FilterChip filterChip = FilterChip(
       selected: _selected[i],
       label: Text(categories[i], style: TextStyle(color: Color6, fontWeight: FontWeight.bold)),
       // avatar: FlutterLogo(),
       elevation: 5,
       pressElevation: 5,
       //shadowColor: Colors.teal,
       backgroundColor: Color2,
       selectedColor: Color1,
       onSelected: (bool selected) {
         for(int j=0;j<_selected.length;j++){
           if(_selected[j]){
             _selected[j]=false;
           }
         }
         _selected[i] = selected;
         if(_selected[i]){

           Utils.isInternetAvailable().then((result){
             if(result){
               filteredList.clear();
               for(Donation d in donations){
                 if(d.category==i+1){
                   filteredList.add(d);
                 }
               }
             }else{
               Utils.showError(context, "Network Error");
             }
           });
         }else{
           filteredList.clear();
           filteredList.assignAll(donations);
         }


       },
     );

     chips.add(Padding(
         padding: EdgeInsets.symmetric(horizontal: 10),
         child: filterChip
     ));
   }

   return ListView(
     // This next line does the trick.
     scrollDirection: Axis.horizontal,
     children: chips,
   );
 }

 void filterByDistance(BuildContext context)async{
   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
   if(!serviceEnabled){
     Utils.showError(context,"Please Enable Location Services");
     return;
   }

   Geolocator.checkPermission().then((permission){
     if(permission == LocationPermission.denied){
       Geolocator.requestPermission().then((permission){
         if(permission!= LocationPermission.denied){
           Geolocator.getCurrentPosition().then((position){
             Get.dialog(
                 AlertDialog(
                   title: Text("Select Distance"),
                   content:Container(
                       width: 950,
                       height: 64,
                       child: StatefulBuilder(
                         builder: ((context, setState) {
                           return Scaffold(
                             backgroundColor: Colors.transparent,
                             body: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text("Distance "+sliderValue.value.round().toString()+" Km"),
                                 Slider(
                                   value: sliderValue.value,
                                   onChanged: (value){
                                     setState((){
                                       sliderValue.value=value.roundToDouble();
                                     });
                                   },
                                   min: 1,
                                   max: 50,
                                   divisions: 50,
                                   label: sliderValue.value.roundToDouble().toString()+" "+"Km",
                                 ),

                               ],
                             ),
                           );
                         }),
                       )
                   ),
                   actions: [
                     TextButton(
                       onPressed: (){
                         Get.back();
                       },
                       child: Text("Cancel"),

                     ),

                     TextButton(
                       onPressed: (){
                         filteredList.clear();
                         filteredList.assignAll(foodRequests);
                         Get.back();
                       },
                       child: Text("All"),
                     ),
                     TextButton(
                       onPressed: (){
                         filteredList.clear();
                         for(Donation d in donations){
                           double distance=Geolocator.distanceBetween(position.latitude, position.longitude, d.lat!, d.lng!)/1000;
                           print("Distance "+distance.round().toString());
                           if(distance.round()<=sliderValue.value.round()){
                             print(distance.round()<=sliderValue.value.round());
                             filteredList.add(d);
                           }
                         }
                         print("FilteredList Length "+filteredList.length.toString());
                         Get.back();
                       },
                       child: Text("Set Distance"),

                     ),
                   ],
                 )
             );
           });

         }
       });
       return;
     }else if(permission == LocationPermission.deniedForever){
       Utils.showError(context,"You have to give location permission from setting of your device");
       return;
     }
   });
   Geolocator.getCurrentPosition().then((position){
     Get.dialog(
         AlertDialog(
           title: Text("Select Distance"),
           content:Container(
               width: 950,
               height: 64,
               child: StatefulBuilder(
                 builder: ((context, setState) {
                   return Scaffold(
                     backgroundColor: Colors.transparent,
                     body: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text("Distance "+sliderValue.value.round().toString()+" Km"),
                         Slider(
                           value: sliderValue.value,
                           onChanged: (value){
                             setState((){
                               sliderValue.value=value.roundToDouble();
                             });
                           },
                           min: 1,
                           max: 50,
                           divisions: 50,
                           label: sliderValue.value.roundToDouble().toString()+" "+"Km",
                         ),

                       ],
                     ),
                   );
                 }),
               )
           ),
           actions: [


             TextButton(
               onPressed: (){
                 Get.back();
               },
               child: Text("Cancel"),

             ),

             TextButton(
               onPressed: (){
                 filteredList.clear();
                 filteredList.assignAll(foodRequests);
                 Get.back();
               },
               child: Text("All"),
             ),
             TextButton(
               onPressed: (){
                 filteredList.clear();
                 for(Donation d in donations){
                   double distance=Geolocator.distanceBetween(position.latitude, position.longitude, d.lat!, d.lng!)/1000;
                   print("Distance "+distance.round().toString());
                   if(distance.round()<=sliderValue.value.round()){
                     print(distance.round()<=sliderValue.value.round());
                     filteredList.add(d);
                   }

                 }
                 print("FilteredList Length "+filteredList.length.toString());
                 Get.back();
               },
               child: Text("Set Distance"),

             ),
           ],
         )
     );
   });
 }
}