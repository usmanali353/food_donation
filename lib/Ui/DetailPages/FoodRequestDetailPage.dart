import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation/Controllers/AdminController.dart';
import 'package:food_donation/Controllers/DonorController.dart';
import 'package:food_donation/Controllers/ReceiverController.dart';
import 'package:food_donation/Utils/LoadingScreen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/Constants.dart';
import '../../Utils/Utils.dart';

class FoodRequestDetailPage extends StatelessWidget {
 String? openedFrom;
 int? index;
 String? donationId;
 List<dynamic> requests=[];
 bool? isHistory;
 FoodRequestDetailPage(this.openedFrom, this.index,{this.donationId,this.isHistory});

  @override
  Widget build(BuildContext context) {
    if(requests.length==0){
      log("isHistory "+isHistory.toString());
      log("Role:  "+openedFrom!);
      if(openedFrom=="Donor"){

        if(isHistory!=null&&isHistory==true){
          this.requests.addAll(Get.find<DonorController>().fulfilledRequests);
        }else{
          this.requests.addAll(Get.find<DonorController>().filteredList);
        }
        print(this.requests[index!].lat.toString());
        print(this.requests[index!].lng.toString());
      }else if(openedFrom=="Receiver"){
        if(isHistory!=null&&isHistory==true){
          this.requests.addAll(Get.find<ReceiverController>().fulfilledRequests);
        }else{
          this.requests.addAll(Get.find<ReceiverController>().foodRequests);
        }
      }else if(openedFrom=="Admin"){
        this.requests.addAll(Get.find<AdminController>().filteredList);
      }
    }
    return openedFrom=="Donor"?Obx(() => !Get.find<DonorController>().isDonating.value?Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Color6
        ),
        backgroundColor: Color2,
        elevation: 8,
        centerTitle: true,
        title: Text("Details", style: TextStyle(
            color: Color6, fontSize: 30, fontWeight: FontWeight.bold
        ),
        ),
        actions: [
          Visibility(
            visible: openedFrom=="Donor"&&this.donationId!=null,
            child: IconButton(
              onPressed: (){
                Get.find<DonorController>().fulfillRequest(context, this.donationId!);
              },
              icon: Icon(FontAwesomeIcons.handHoldingHeart),
            ),
          ),
          Visibility(
            visible: isHistory==true,
            child: IconButton(
              onPressed: (){
                if(openedFrom =="Receiver"){
                  Get.find<ReceiverController>().getUserInfoById(context, this.requests[this.index!].status);
                }else if(openedFrom == "Donor"){
                  Get.find<DonorController>().getUserInfoById(context, this.requests[this.index!].status);
                }else{
                  Get.find<AdminController>().getUserInfoById(context, this.requests[this.index!].status);
                }
              },
              icon: Icon(FontAwesomeIcons.idCard,color: Colors.white,),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              //height: 650,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                //color: Color6,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(48), bottomLeft: Radius.circular(48))
              ),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Container(

                    width: MediaQuery.of(context).size.width,
                    height: 570,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(48), bottomLeft: Radius.circular(48)),

                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(

                                  border: Border.all(color: Color1, width: 2),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Color2,
                                        border: Border.all(color: Color1, width: 1),
                                        borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: Center(
                                      child: Text("Description", style: TextStyle(
                                          color: Color6, fontSize: 22, fontWeight: FontWeight.bold
                                      ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 45,
                                    child: Text(this.requests[index!].description,
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color2,fontSize: 17, fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                //color: Color1,
                                //border: Border.all(color: Color1, width: 1),
                                //borderRadius: BorderRadius.circular(4)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color1,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color2, width: 2)
                                        ),
                                        child: Center(child: FaIcon(FontAwesomeIcons.sitemap, color: Color2,)),
                                      )),
                                  SizedBox(width: 5,),
                                  Expanded(
                                      flex: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(Utils.getCategoryName(requests[index!].category), style: TextStyle(
                                              color: Color2, fontSize: 20, fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ),

                                      )),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                //color: Color1,
                                //border: Border.all(color: Color1, width: 1),
                                //borderRadius: BorderRadius.circular(4)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color1,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color2, width: 2)
                                        ),
                                        child: Center(child: FaIcon(FontAwesomeIcons.users, color: Color2,)),
                                      )),
                                  SizedBox(width: 5,),
                                  Expanded(
                                      flex: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(this.requests[index!].personsQuantity.toString(), style: TextStyle(
                                              color: Color2, fontSize: 20, fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ),

                                      )),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                //color: Color1,
                                //border: Border.all(color: Color1, width: 1),
                                //borderRadius: BorderRadius.circular(4)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color1,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color2, width: 2)
                                        ),
                                        child: Center(child: FaIcon(FontAwesomeIcons.calendar, color: Color2,)),
                                      )),
                                  SizedBox(width: 5,),
                                  Expanded(
                                      flex: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(Utils.getFormattedDate(this.requests[index!].createdOn), style: TextStyle(
                                              color: Color2, fontSize: 20, fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ),

                                      )),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                //color: Color1,
                                //border: Border.all(color: Color1, width: 1),
                                //borderRadius: BorderRadius.circular(4)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color1,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color2, width: 2)
                                        ),
                                        child: Center(child: FaIcon(FontAwesomeIcons.truck, color: Color2,)),
                                      )),
                                  SizedBox(width: 5,),
                                  Expanded(
                                      flex: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(Utils.getDeliveryTypeName(this.requests[index!].deliveryType), style: TextStyle(
                                              color: Color2, fontSize: 20, fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                //color: Color1,
                                //border: Border.all(color: Color1, width: 1),
                                //borderRadius: BorderRadius.circular(4)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color1,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color2, width: 2)
                                        ),
                                        child: Center(child: FaIcon(FontAwesomeIcons.mapLocationDot, color: Color2,)),
                                      )),
                                  SizedBox(width: 5,),
                                  Expanded(
                                      flex: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(this.requests[index!].address, style: TextStyle(
                                              color: Color2, fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ),

                                      )),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                //color: Color1,
                                //border: Border.all(color: Color1, width: 1),
                                //borderRadius: BorderRadius.circular(4)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color1,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color2, width: 2)
                                        ),
                                        child: Center(child: FaIcon(FontAwesomeIcons.phoneFlip, color: Color2,)),
                                      )),
                                  SizedBox(width: 5,),
                                  Expanded(
                                      flex: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(this.requests[index!].phone, style: TextStyle(
                                              color: Color2, fontSize: 20,fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ),

                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
          Visibility(
            visible: openedFrom=="Donor",
            child: Expanded(
              child: InkWell(
                onTap: ()async{
                  await launchUrl(
                     Uri.parse("tel://${this.requests[index!].phone}") );
                },
                child: Container(
                  //height: 650,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    //color: Color2,
                    //borderRadius: BorderRadius.only(bottomRight: Radius.circular(18), bottomLeft: Radius.circular(18))
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 8,
                          color: Color1,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Color2,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Color1, width: 2)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      color: Color2,
                                      child: Center(
                                        child: Text("Contact", style: TextStyle(
                                            color: Color6, fontSize: 22, fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color1,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Color2, width: 2)
                                      ),
                                      child: Center(child: FaIcon(FontAwesomeIcons.phoneFlip, color: Color2,)),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ),
                      ),
                      Visibility(
                        visible: openedFrom=="Donor"&&requests[index!].deliveryType==2,
                        child: Expanded(
                          child: InkWell(
                            onTap: ()async{
                              bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                              if(!serviceEnabled){
                                Utils.showError(context,"Please Enable Location Services");
                                return;
                              }
                              Geolocator.checkPermission().then((permission){
                                if(permission == LocationPermission.denied){
                                  Geolocator.requestPermission().then((permission){
                                    if(permission!= LocationPermission.denied){
                                      Geolocator.getCurrentPosition().then((position)async{
                                        final availableMaps = await MapLauncher.installedMaps;
                                        availableMaps.first.showDirections(
                                            destination: Coords(this.requests[index!].lat,this.requests[index!].lng),
                                            origin: Coords(position.latitude,position.longitude),
                                            destinationTitle: "Hospital",
                                            originTitle: "Mobile Market"
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
                              Geolocator.getCurrentPosition().then((position)async{
                                final availableMaps = await MapLauncher.installedMaps;
                                List<Placemark> p = await placemarkFromCoordinates(position.latitude,position.longitude);

                                Placemark place = p[0];
                                availableMaps.first.showDirections(
                                    destination: Coords(this.requests[index!].lat,this.requests[index!].lng),
                                    origin: Coords(position.latitude,position.longitude),
                                    destinationTitle: requests[index!].address,
                                    originTitle: "${place.name},${place.subLocality}, ${place.locality}, ${place.country}"
                                );
                              });

                            },
                            child: Card(
                              elevation: 8,
                              color: Color1,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Color2,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Color1, width: 2)
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          color: Color2,
                                          child: Center(
                                            child: Text("Location", style: TextStyle(
                                                color: Color6, fontSize: 22, fontWeight: FontWeight.bold
                                            ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color1,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color2, width: 2)
                                          ),
                                          child: Center(child: FaIcon(FontAwesomeIcons.mapLocationDot, color: Color2,)),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ):LoadingScreen()) :Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Color6
        ),
        backgroundColor: Color2,
        elevation: 8,
        centerTitle: true,
        title: Text("Details", style: TextStyle(
            color: Color6, fontSize: 30, fontWeight: FontWeight.bold
        ),
        ),
        actions: [
          Visibility(
            visible: openedFrom=="Donor"&&this.donationId!=null,
            child: IconButton(
              onPressed: (){
                Get.find<DonorController>().fulfillRequest(context, this.donationId!);
              },
              icon: Icon(FontAwesomeIcons.handHoldingHeart),
            ),
          ),
          Visibility(
            visible: isHistory==true,
            child: IconButton(
              onPressed: (){
                if(openedFrom=="Receiver"){
                  Get.find<ReceiverController>().getUserInfoById(context, this.requests[this.index!].status);
                }else if(openedFrom=="Donor"){
                  Get.find<DonorController>().getUserInfoById(context, this.requests[this.index!].status);
                }else{
                  Get.find<AdminController>().getUserInfoById(context, this.requests[this.index!].status);
                }
              },
              icon: Icon(FontAwesomeIcons.idCard,color: Colors.white,),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              //height: 650,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  //color: Color6,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(48), bottomLeft: Radius.circular(48))
              ),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Container(

                    width: MediaQuery.of(context).size.width,
                    height: 570,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(48), bottomLeft: Radius.circular(48)),

                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(

                                  border: Border.all(color: Color1, width: 2),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Color2,
                                        border: Border.all(color: Color1, width: 1),
                                        borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: Center(
                                      child: Text("Description", style: TextStyle(
                                          color: Color6, fontSize: 22, fontWeight: FontWeight.bold
                                      ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 45,
                                    child: Text(this.requests[index!].description,
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color2,fontSize: 17, fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                //color: Color1,
                                //border: Border.all(color: Color1, width: 1),
                                //borderRadius: BorderRadius.circular(4)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color1,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color2, width: 2)
                                        ),
                                        child: Center(child: FaIcon(FontAwesomeIcons.sitemap, color: Color2,)),
                                      )),
                                  SizedBox(width: 5,),
                                  Expanded(
                                      flex: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(Utils.getCategoryName(requests[index!].category), style: TextStyle(
                                              color: Color2, fontSize: 20, fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ),

                                      )),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                //color: Color1,
                                //border: Border.all(color: Color1, width: 1),
                                //borderRadius: BorderRadius.circular(4)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color1,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color2, width: 2)
                                        ),
                                        child: Center(child: FaIcon(FontAwesomeIcons.users, color: Color2,)),
                                      )),
                                  SizedBox(width: 5,),
                                  Expanded(
                                      flex: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(this.requests[index!].personsQuantity.toString(), style: TextStyle(
                                              color: Color2, fontSize: 20, fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ),

                                      )),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                //color: Color1,
                                //border: Border.all(color: Color1, width: 1),
                                //borderRadius: BorderRadius.circular(4)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color1,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color2, width: 2)
                                        ),
                                        child: Center(child: FaIcon(FontAwesomeIcons.calendar, color: Color2,)),
                                      )),
                                  SizedBox(width: 5,),
                                  Expanded(
                                      flex: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(Utils.getFormattedDate(this.requests[index!].createdOn), style: TextStyle(
                                              color: Color2, fontSize: 20, fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ),

                                      )),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                //color: Color1,
                                //border: Border.all(color: Color1, width: 1),
                                //borderRadius: BorderRadius.circular(4)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color1,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color2, width: 2)
                                        ),
                                        child: Center(child: FaIcon(FontAwesomeIcons.truck, color: Color2,)),
                                      )),
                                  SizedBox(width: 5,),
                                  Expanded(
                                      flex: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(Utils.getDeliveryTypeName(this.requests[index!].deliveryType), style: TextStyle(
                                              color: Color2, fontSize: 20, fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                //color: Color1,
                                //border: Border.all(color: Color1, width: 1),
                                //borderRadius: BorderRadius.circular(4)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color1,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color2, width: 2)
                                        ),
                                        child: Center(child: FaIcon(FontAwesomeIcons.mapLocationDot, color: Color2,)),
                                      )),
                                  SizedBox(width: 5,),
                                  Expanded(
                                      flex: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(this.requests[index!].address, style: TextStyle(
                                              color: Color2, fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ),

                                      )),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                //color: Color1,
                                //border: Border.all(color: Color1, width: 1),
                                //borderRadius: BorderRadius.circular(4)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color1,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color2, width: 2)
                                        ),
                                        child: Center(child: FaIcon(FontAwesomeIcons.phoneFlip, color: Color2,)),
                                      )),
                                  SizedBox(width: 5,),
                                  Expanded(
                                      flex: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(this.requests[index!].phone, style: TextStyle(
                                              color: Color2, fontSize: 20,fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ),

                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
          Visibility(
            visible: openedFrom=="Donor",
            child: Expanded(
              child: InkWell(
                onTap: ()async{
                  await launchUrl(
                    Uri.parse("tel://${this.requests[index!].phone}")  );
                },
                child: Container(
                  //height: 650,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    //color: Color2,
                    //borderRadius: BorderRadius.only(bottomRight: Radius.circular(18), bottomLeft: Radius.circular(18))
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 8,
                          color: Color1,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Color2,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Color1, width: 2)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      color: Color2,
                                      child: Center(
                                        child: Text("Contact", style: TextStyle(
                                            color: Color6, fontSize: 22, fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color1,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Color2, width: 2)
                                      ),
                                      child: Center(child: FaIcon(FontAwesomeIcons.phoneFlip, color: Color2,)),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ),
                      ),
                      Visibility(
                        visible: openedFrom=="Donor"&&requests[index!].deliveryType==2,
                        child: Expanded(
                          child: InkWell(
                            onTap: ()async{
                              bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                              if(!serviceEnabled){
                                Utils.showError(context,"Please Enable Location Services");
                                return;
                              }
                              Geolocator.checkPermission().then((permission){
                                if(permission == LocationPermission.denied){
                                  Geolocator.requestPermission().then((permission){
                                    if(permission!= LocationPermission.denied){
                                       Geolocator.getCurrentPosition().then((position)async{
                                         final availableMaps = await MapLauncher.installedMaps;
                                         availableMaps.first.showDirections(
                                             destination: Coords(this.requests[index!].lat,this.requests[index!].lng),
                                             origin: Coords(position.latitude,position.longitude),
                                            destinationTitle: "Hospital",
                                           originTitle: "Mobile Market"
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
                              Geolocator.getCurrentPosition().then((position)async{
                                final availableMaps = await MapLauncher.installedMaps;
                                List<Placemark> p = await placemarkFromCoordinates(position.latitude,position.longitude);

                                Placemark place = p[0];
                                availableMaps.first.showDirections(
                                    destination: Coords(this.requests[index!].lat,this.requests[index!].lng),
                                    origin: Coords(position.latitude,position.longitude),
                                    destinationTitle: requests[index!].address,
                                    originTitle: "${place.name},${place.subLocality}, ${place.locality}, ${place.country}"
                                );
                              });

                            },
                            child: Card(
                              elevation: 8,
                              color: Color1,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Color2,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Color1, width: 2)
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          color: Color2,
                                          child: Center(
                                            child: Text("Location", style: TextStyle(
                                                color: Color6, fontSize: 22, fontWeight: FontWeight.bold
                                            ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color1,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color2, width: 2)
                                          ),
                                          child: Center(child: FaIcon(FontAwesomeIcons.mapLocationDot, color: Color2,)),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
