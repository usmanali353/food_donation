import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donation/Controllers/AccountController.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../IRepositories/IDonorRepository.dart';
import '../Models/Donation.dart';
import '../Models/userData.dart';
import '../Ui/Donor/DonorHome.dart';
import '../Utils/Address.dart';
import '../Utils/Constants.dart';
import '../Utils/Locator.dart';
import '../Utils/Utils.dart';

class DonorController extends GetxController{
  late TextEditingController descriptionTextEditingController,addressTextEditingController,personsQuantityTextEditingController,expiryDateTextEditingController;
  int? selectedCategoryId,selectedDeliveryTypeId;
  Rx<DateTime> selectedDate=DateTime.now().obs;
 var selectedFiles=[].obs;
 List<XFile> selectedImages=[];
  String? selectedCategory,selectedDeliveryType;
  Address? address;
  Rx<bool> isDonating=false.obs;
  var donations=[].obs;
  var donated=[].obs;
  var fulfilledRequests=[].obs;
  var foodRequests=[].obs;
  var filteredList=[].obs;
  var _selected=[].obs;
  Rx<double> sliderValue=1.0.obs;
  List<String> categories=["Cooked Food","Fruits","Vegetables","Sweets","Chocolates","Cakes","Biscuits","Milk","Grains","Mix Items","Others",];
  List<String> deliveryTypes=["Pick Up","Drop Off"];
  late IDonorRepository donorRepository;
  onInit(){
    super.onInit();
    descriptionTextEditingController = TextEditingController();
    addressTextEditingController = TextEditingController();
    personsQuantityTextEditingController = TextEditingController();
    expiryDateTextEditingController = TextEditingController();
    donorRepository=locator<IDonorRepository>();
  }

  void donateFood(BuildContext context){
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
          Utils.showError(context,"Specify Your Address");
        }else if(address==null){
          Utils.showError(context,"Specify Your Address");
        }else if(selectedFiles.length<2){
          Utils.showError(context, "Select atleast 2 images");
        }else{
          SharedPreferences.getInstance().then((prefs){
            if(prefs.getString("user_data")!=null){
              isDonating.value=true;
              UserData user= UserData.userFromJson(prefs.getString("user_data")!);
              donorRepository.donateFood(context,Donation(name: user.name,userId: FirebaseAuth.instance.currentUser?.uid,phone: user.phone,description: descriptionTextEditingController.text,deliveryType: selectedDeliveryTypeId,category: selectedCategoryId,lat: address?.latitude,lng: address?.longitude,address: address?.address,createdOn: DateTime.now().toIso8601String(),personsQuantity: int.parse(personsQuantityTextEditingController.text),availableUpTo: expiryDateTextEditingController.text,images: []),selectedImages).then((value){
                descriptionTextEditingController.text="";
                addressTextEditingController.text = "";
                personsQuantityTextEditingController.text= "";
                selectedDeliveryType=null;
                selectedCategory=null;
                expiryDateTextEditingController.text="";
                selectedImages.clear();
                selectedFiles.clear();
                isDonating.value=false;
                Get.offAll(()=>DonorHome());
              }).catchError((error){
                Utils.showError(context,error.toString());
                isDonating.value=false;
              });

            }
          });
        }

      }else{
        Utils.showError(context,"Device is not Connected to the Network");
      }
    });
  }

  Future getDonations(BuildContext context) async{
    Utils.isInternetAvailable().then((isConnected)async{
      if(isConnected){
        if(FirebaseAuth.instance.currentUser!=null){
          List<Donation> donationList= await donorRepository.getDonations(context, FirebaseAuth.instance.currentUser!.uid);
          donations.clear();
          donations.assignAll(donationList);
          log("No of Donations "+donations.length.toString());
        }
      }else{
        Utils.showError(context,"Your Device is not Connected to Network");
      }
    });
  }

  Future getFoodRequests(BuildContext context) async{
    Utils.isInternetAvailable().then((isConnected)async{
      if(isConnected){
        if(FirebaseAuth.instance.currentUser!=null){
          List<Donation> donationList= await donorRepository.getFoodRequests(context);
          filteredList.clear();
          foodRequests.clear();
          foodRequests.assignAll(donationList);
          filteredList.assignAll(donationList);
          log("No of Requests "+foodRequests.length.toString());
        }
      }else{
        Utils.showError(context,"Your Device is not Connected to Network");
      }
    });

  }

  Future getFoodRequestsFulfilledByDonor(BuildContext context) async{
    Utils.isInternetAvailable().then((isConnected)async{
      if(isConnected){
        if(FirebaseAuth.instance.currentUser!=null){
          fulfilledRequests.clear();
          List<Donation> donationList= await donorRepository.getRequestsFulfilledByDonor(context);
          fulfilledRequests.assignAll(donationList);
        }
      }else{
        Utils.showError(context,"Your Device is not Connected to Network");
      }
    });
  }
  Future getDonationsReceivedByReceivers(BuildContext context) async{
    Utils.isInternetAvailable().then((isConnected)async{
      if(isConnected){
        if(FirebaseAuth.instance.currentUser!=null){
          donated.clear();
          List<Donation> donationList= await donorRepository.getDonationsReceivedByReceivers(context);
          donated.assignAll(donationList);
        }
      }else{
        Utils.showError(context,"Your Device is not Connected to Network");
      }
    });
  }
  void fulfillRequest(BuildContext context,String donationId){
    Utils.isInternetAvailable().then((isConnected){
      if(isConnected){
        isDonating.value=true;
        donorRepository.fulfillRequest(context, donationId).then((value){
          isDonating.value=false;
          Get.offAll(()=>DonorHome());
        }).catchError((error){
          Utils.showError(context, error);
          isDonating.value=false;
        });
      }else{
        Utils.showError(context,"Your Device is not Connected to Network");
      }
    });

  }
  void getUserInfoById(BuildContext context,String userId){
    Get.find<AccountController>().accountRepository.getUserInfoById(context, userId).then((userInfo){

    }).catchError((error){
      Utils.showError(context, error.toString());
    });
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
                                  Text("Distance "+sliderValue.value.roundToDouble().toString()+" Km"),
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
                          for(Donation d in foodRequests){
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
                  for(Donation d in foodRequests){
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
                  for(Donation d in foodRequests){
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
              filteredList.assignAll(foodRequests);
              // WidgetsBinding.instance
              //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
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
}