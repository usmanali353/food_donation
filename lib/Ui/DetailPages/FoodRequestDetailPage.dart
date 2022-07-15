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
import 'package:rating_dialog/rating_dialog.dart';
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
            visible: this.requests[index!].rating!=null,
            child: IconButton(
              icon: Icon(Icons.star),
              color: Colors.white,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context){
                      return Dialog(
                        child: Container(
                          width: 500,
                          height: 150,
                          child: Scaffold(
                            body: Card(
                                elevation: 4,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 2, color: Color1)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                            color: Color2,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(2), bottomLeft:Radius.circular(2))
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            FaIcon(FontAwesomeIcons.solidStar, size: 30, color: Colors.amberAccent,),
                                            SizedBox(height: 5,),
                                            Text(this.requests[index!].rating.toString(), style: TextStyle(
                                                fontSize: 25,
                                                color: Color6,
                                                fontWeight: FontWeight.bold
                                            ),)
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Expanded(
                                          child: Container(
                                            //color: Colors.yellow,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Color2,
                                                    border: Border.all(color: Color1, width: 1),
                                                    //borderRadius: BorderRadius.circular(4)
                                                  ),
                                                  child: Center(
                                                    child: Text(this.requests[index!].ratedByName, style: TextStyle(
                                                        color: Color6, fontSize: 22, fontWeight: FontWeight.bold
                                                    ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Expanded(

                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      //color: Color6,
                                                      border: Border.all(color: Color1, width: 1),
                                                      //borderRadius: BorderRadius.circular(8)
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                            color: Color2,
                                                            border: Border.all(color: Color1, width: 0.5),
                                                            //borderRadius: BorderRadius.circular(4)
                                                          ),
                                                          child: Center(
                                                            child: Text("Date: " + Utils.getFormattedDate(this.requests[index!].ratedOn), style: TextStyle(
                                                                color: Color6, fontSize: 20, fontWeight: FontWeight.bold
                                                            ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(this.requests[index!].comment,
                                                          maxLines: 3,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color2, fontSize: 15, fontWeight: FontWeight.bold
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                      // Expanded(
                                      //   child:
                                      // ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                      );
                    }
                );
              },
            ),
          ),
          Visibility(
            visible: openedFrom=="Donor"&&this.donationId!=null,
            child: IconButton(
              onPressed: (){
                final _dialog = RatingDialog(
                  initialRating: 1.0,
                  // your app's name?
                  title: Text(
                    'Rate Receiver',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // encourage your user to leave a high rating?
                  message: Text(
                    'Rate Receiver and Leave Some Comment',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                  ),
                  // your app's logo?
                  image: Image.asset("Assets/charitylogo.png",width: 100,height: 100,),
                  submitButtonText: 'Submit',
                  commentHint: 'Your Comment',
                  onCancelled: () => print('cancelled'),
                  onSubmitted: (response) {
                    print('rating: ${response.rating}, comment: ${response.comment}');
                    if(response.comment.isNotEmpty){
                      Get.find<DonorController>().fulfillRequest(context, this.donationId!,response.comment,response.rating,this.requests[index!].userId);
                    }else{
                      Utils.showError(context,"Please Leave Comment and Rating");
                    }
                  },
                );

                // show the dialog
                showDialog(
                  context: context,
                  barrierDismissible: true, // set to false if you want to force a rating
                  builder: (context) => _dialog,
                );

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
            visible: this.requests[index!].rating!=null,
            child: IconButton(
              icon: Icon(Icons.star),
              color: Colors.white,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context){
                      return Dialog(
                        child: Container(
                          width: 500,
                          height: 150,
                          child: Scaffold(
                            body: Card(
                                elevation: 4,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 2, color: Color1)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                            color: Color2,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(2), bottomLeft:Radius.circular(2))
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            FaIcon(FontAwesomeIcons.solidStar, size: 30, color: Colors.amberAccent,),
                                            SizedBox(height: 5,),
                                            Text(this.requests[index!].rating.toString(), style: TextStyle(
                                                fontSize: 25,
                                                color: Color6,
                                                fontWeight: FontWeight.bold
                                            ),)
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Expanded(
                                          child: Container(
                                            //color: Colors.yellow,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Color2,
                                                    border: Border.all(color: Color1, width: 1),
                                                    //borderRadius: BorderRadius.circular(4)
                                                  ),
                                                  child: Center(
                                                    child: Text(this.requests[index!].ratedByName, style: TextStyle(
                                                        color: Color6, fontSize: 22, fontWeight: FontWeight.bold
                                                    ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Expanded(

                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      //color: Color6,
                                                      border: Border.all(color: Color1, width: 1),
                                                      //borderRadius: BorderRadius.circular(8)
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                            color: Color2,
                                                            border: Border.all(color: Color1, width: 0.5),
                                                            //borderRadius: BorderRadius.circular(4)
                                                          ),
                                                          child: Center(
                                                            child: Text("Date: " + Utils.getFormattedDate(this.requests[index!].ratedOn), style: TextStyle(
                                                                color: Color6, fontSize: 20, fontWeight: FontWeight.bold
                                                            ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(this.requests[index!].comment,
                                                          maxLines: 3,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color2, fontSize: 15, fontWeight: FontWeight.bold
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                      // Expanded(
                                      //   child:
                                      // ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                      );
                    }
                );
              },
            ),
          ),
          Visibility(
            visible: openedFrom=="Donor"&&this.donationId!=null,
            child: IconButton(
              onPressed: (){
                final _dialog = RatingDialog(
                  initialRating: 1.0,
                  // your app's name?
                  title: Text(
                    'Rate Receiver',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // encourage your user to leave a high rating?
                  message: Text(
                    'Rate Receiver and Leave Some Comment',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                  ),
                  // your app's logo?
                  image: Image.asset("Assets/charitylogo.png",width: 100,height: 100,),
                  submitButtonText: 'Submit',
                  commentHint: 'Your Comment',
                  onCancelled: () => print('cancelled'),
                  onSubmitted: (response) {
                    print('rating: ${response.rating}, comment: ${response.comment}');
                    if(response.comment.isNotEmpty){
                      Get.find<DonorController>().fulfillRequest(context, this.donationId!,response.comment,response.rating,this.requests[index!].userId);
                    }else{
                      Utils.showError(context,"Please Leave Comment and Rating");
                    }
                  },
                );

                // show the dialog
                showDialog(
                  context: context,
                  barrierDismissible: true, // set to false if you want to force a rating
                  builder: (context) => _dialog,
                );
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
                                      maxLines: 2,
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
