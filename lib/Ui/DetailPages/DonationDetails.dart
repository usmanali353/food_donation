import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation/Utils/LoadingScreen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Controllers/AdminController.dart';
import '../../Controllers/DonorController.dart';
import '../../Controllers/ReceiverController.dart';
import '../../Utils/Constants.dart';
import '../../Utils/Utils.dart';




class DonationDetailsScreen extends StatelessWidget{
  String? openedFrom,donationId;
  int? index;
  bool? isHistory;
  List<dynamic> donations=[];
  DonationDetailsScreen(this.index,this.openedFrom,{this.donationId,this.isHistory});
  @override
  Widget build(BuildContext context) {
    if(donations.length==0){
      if(openedFrom=="Donor"){
        if(isHistory!=null&&isHistory==true){
          this.donations.addAll(Get.find<DonorController>().donated);
        }else{
          this.donations.addAll(Get.find<DonorController>().donations);
        }
      }else if(openedFrom=="Receiver"){
        if(isHistory!=null&&isHistory==true){
          this.donations.addAll(Get.find<ReceiverController>().donated);
        }else{
          this.donations.addAll(Get.find<ReceiverController>().filteredList);
        }
      }else{
        this.donations.addAll(Get.find<AdminController>().filteredList);
      }
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Color6
        ),
        backgroundColor: Color2,
        elevation: 8,
        centerTitle: true,
        title: Text("Details", style: TextStyle(
            color: Color6, fontSize: 25, fontWeight: FontWeight.bold
        ),
        ),
        actions: [
          Visibility(
            visible: this.donations[index!].rating!=null,
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
                                            Text(this.donations[index!].rating.toString(), style: TextStyle(
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
                                                    child: Text(this.donations[index!].ratedByName, style: TextStyle(
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
                                                            child: Text("Date: " + Utils.getFormattedDate(this.donations[index!].ratedOn), style: TextStyle(
                                                                color: Color6, fontSize: 20, fontWeight: FontWeight.bold
                                                            ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(this.donations[index!].comment,
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
            visible: isHistory==true&&openedFrom!="Receiver",
            child: IconButton(
              onPressed: (){
                if(openedFrom=="Receiver"){
                 Get.find<ReceiverController>().getUserInfoById(context, this.donations[this.index!].status);
                }else if(openedFrom == "Donor"){
                  Get.find<DonorController>().getUserInfoById(context, this.donations[this.index!].status);
                }else{
                  Get.find<AdminController>().getUserInfoById(context, this.donations[this.index!].status);
                }
              },
              icon: Icon(FontAwesomeIcons.idCard,color: Colors.white,),
            ),
          ),
          Visibility(
            visible: openedFrom=="Receiver"&&this.donationId!=null,
            child: IconButton(
              onPressed: (){
                final _dialog = RatingDialog(
                  initialRating: 1.0,
                  // your app's name?
                  title: Text(
                    'Rate Donor',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // encourage your user to leave a high rating?
                  message: Text(
                    'Rate Donor and Leave Some Comment',
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
                    Get.find<ReceiverController>().receiveDonations(context, this.donationId!,response.comment,response.rating,this.donations[index!].userId);
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
        ],
      ),
      body:openedFrom=="Receiver"?Obx(() => !Get.find<ReceiverController>().addingFoodRequest.value? Column(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              //height: 650,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(48), bottomLeft: Radius.circular(48))
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 5,),
                    Container(
                      height: MediaQuery.of(context).size.height /5.5,
                      width: MediaQuery.of(context).size.width,
                      child:  CarouselSlider.builder(itemCount:donations[index!].images.length, options: CarouselOptions(
                        height: 400,
                        aspectRatio: 16/9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 4),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        // onPageChanged: callbackFunction,
                        scrollDirection: Axis.horizontal,
                      ), itemBuilder: (BuildContext context, int index, int realIndex) {
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Color2, width: 2),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(donations[this.index!].images[index])
                                )
                            ),
                          ),
                        );
                      },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(

                      width: MediaQuery.of(context).size.width,
                      height: openedFrom=="Donor"?490:410,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(48), bottomLeft: Radius.circular(48)),
                        color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                                    border: Border.all(color: Color1, width: 2),
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 90,
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
                                    Text(donations[index!].description,
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
                                              color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color1, width: 2)
                                          ),
                                          child: Center(
                                            child: Text(Utils.getCategoryName(donations[index!].category), style: TextStyle(
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
                                              color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color1, width: 2)
                                          ),
                                          child: Center(
                                            child: Text(donations[index!].personsQuantity.toString(), style: TextStyle(
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
                                          child: Center(child: FaIcon(FontAwesomeIcons.hourglassStart, color: Color2,)),
                                        )),
                                    SizedBox(width: 5,),
                                    Expanded(
                                        flex: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color1, width: 2)
                                          ),
                                          child: Center(
                                            child: Text(donations[index!].availableUpTo, style: TextStyle(
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
                                              color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color1, width: 2)
                                          ),
                                          child: Center(
                                            child: Text(Utils.getDeliveryTypeName(donations[index!].deliveryType), style: TextStyle(
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
                                              color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color1, width: 2)
                                          ),
                                          child: Center(
                                            child: Text(donations[index!].address, style: TextStyle(
                                                color: Color2, fontSize: 18, fontWeight: FontWeight.bold
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
          ),
          Visibility(
              visible: openedFrom=="Receiver",
              child:  Expanded(
                child: InkWell(
                  onTap: ()async{
                    await launchUrl(
                      Uri.parse("tel://${this.donations[index!].phone}")  );
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
                          visible: openedFrom=="Receiver"&&donations[index!].deliveryType==1,
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
                                              destination: Coords(this.donations[index!].lat,this.donations[index!].lng),
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
                                      destination: Coords(this.donations[index!].lat,this.donations[index!].lng),
                                      origin: Coords(position.latitude,position.longitude),
                                      destinationTitle: donations[index!].address,
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
              )
          )
        ],
      ):LoadingScreen()):Column(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              //height: 650,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(48), bottomLeft: Radius.circular(48))
              ),
              child: Column(
                children: [
                  SizedBox(height: 5,),
                  Container(
                    height: MediaQuery.of(context).size.height /5.5,
                    width: MediaQuery.of(context).size.width,
                    child:  CarouselSlider.builder(itemCount:donations[index!].images.length, options: CarouselOptions(
                      height: 400,
                      aspectRatio: 16/9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 4),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      // onPageChanged: callbackFunction,
                      scrollDirection: Axis.horizontal,
                    ), itemBuilder: (BuildContext context, int index, int realIndex) {
                      return Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Color2, width: 2),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(donations[this.index!].images[index])
                              )
                          ),
                        ),
                      );
                    },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(

                    width: MediaQuery.of(context).size.width,
                    height: openedFrom=="Donor"?490:450,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(48), bottomLeft: Radius.circular(48)),
                      color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                                  border: Border.all(color: Color1, width: 2),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 90,
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
                                  Text(donations[index!].description,
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
                                            color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(Utils.getCategoryName(donations[index!].category), style: TextStyle(
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
                                            color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(donations[index!].personsQuantity.toString(), style: TextStyle(
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
                                        child: Center(child: FaIcon(FontAwesomeIcons.hourglassStart, color: Color2,)),
                                      )),
                                  SizedBox(width: 5,),
                                  Expanded(
                                      flex: 6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(donations[index!].availableUpTo, style: TextStyle(
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
                                            color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(Utils.getDeliveryTypeName(donations[index!].deliveryType), style: TextStyle(
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
                                            color: !Get.isDarkMode?Color6:Theme.of(context).appBarTheme.backgroundColor,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color1, width: 2)
                                        ),
                                        child: Center(
                                          child: Text(donations[index!].address, style: TextStyle(
                                              color: Color2, fontSize: 18, fontWeight: FontWeight.bold
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
              visible: openedFrom=="Receiver",
              child:  Expanded(
                child: InkWell(
                  onTap: ()async{
                    await launchUrl(
                        Uri.parse("tel://${this.donations[index!].phone}"));
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
                          visible: openedFrom=="Receiver"&&donations[index!].deliveryType==1,
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
                                              destination: Coords(this.donations[index!].lat,this.donations[index!].lng),
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
                                      destination: Coords(this.donations[index!].lat,this.donations[index!].lng),
                                      origin: Coords(position.latitude,position.longitude),
                                      destinationTitle: donations[index!].address,
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
              )
          )
        ],
      ) ,
    );
  }
}
